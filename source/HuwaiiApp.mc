using Toybox.Application;
using Toybox.Activity as Activity;
using Toybox.System as Sys;
using Toybox.Background as Bg;
using Toybox.WatchUi as Ui;
using Toybox.Time;
using Toybox.Math;
using Toybox.Time.Gregorian as Date;

// In-memory current location.
// Previously persisted in App.Storage, but now persisted in Object Store due to #86 workaround for App.Storage firmware bug.
// Current location retrieved/saved in checkPendingWebRequests().
// Persistence allows weather and sunrise/sunset features to be used after watch face restart, even if watch no longer has current
// location available.
var gLocationLat = null;
var gLocationLng = null;

var centerX;
var centerY;

hidden function degreesToRadians(degrees) {
	return degrees * Math.PI / 180;
}  

hidden function radiansToDegrees(radians) {
	return radians * 180 / Math.PI;
}  

hidden function convertCoorX(radians, radius) {
	return centerX + radius*Math.cos(radians);
}

hidden function convertCoorY(radians, radius) {
	return centerY + radius*Math.sin(radians);
}

(:background)
class HuwaiiApp extends Application.AppBase {

	var mView;
	var days;
	var months;
	
    function initialize() {
        AppBase.initialize();
        days = {Date.DAY_MONDAY => "MON", 
				Date.DAY_TUESDAY => "TUE", 
				Date.DAY_WEDNESDAY => "WED", 
				Date.DAY_THURSDAY => "THU", 
				Date.DAY_FRIDAY => "FRI", 
				Date.DAY_SATURDAY => "SAT", 
				Date.DAY_SUNDAY => "SUN"};
		months = {Date.MONTH_JANUARY => "JAN",
				Date.MONTH_FEBRUARY => "FEB",
				Date.MONTH_MARCH => "MAR",
				Date.MONTH_APRIL => "APR",
				Date.MONTH_MAY => "MAY",
				Date.MONTH_JUNE => "JUN",
				Date.MONTH_JULY => "JUL",
				Date.MONTH_AUGUST => "AUG",
				Date.MONTH_SEPTEMBER => "SEP",
				Date.MONTH_OCTOBER => "OCT",
				Date.MONTH_NOVEMBER => "NOV",
				Date.MONTH_DECEMBER => "DEC"};
    }

    // onStart() is called on application start up
    function onStart(state) {
//    	// var clockTime = Sys.getClockTime(); 
//    	// Sys.println("" + clockTime.min + ":" + clockTime.sec);
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
//    	// var clockTime = Sys.getClockTime(); 
//    	// Sys.println("" + clockTime.min + ":" + clockTime.sec);
    }

    // Return the initial view of your application here
    function getInitialView() {
    	mView = new HuwaiiView();
        return [mView];
    }

	function getView() {
		return mView;
	}

	function onSettingsChanged() { // triggered by settings change in GCM
		if (HuwaiiApp has :checkPendingWebRequests) { // checkPendingWebRequests() can be excluded to save memory.
			checkPendingWebRequests();
		}
    	mView.last_draw_minute = -1;
	    WatchUi.requestUpdate();   // update the view to reflect changes
	}
	
	// Determine if any web requests are needed.
	// If so, set approrpiate pendingWebRequests flag for use by BackgroundService, then register for
	// temporal event.
	// Currently called on layout initialisation, when settings change, and on exiting sleep.
	(:background_method)
	function checkPendingWebRequests() {
		
		// Attempt to update current location, to be used by Sunrise/Sunset, and Weather.
		// If current location available from current activity, save it in case it goes "stale" and can not longer be retrieved.
		var location = Activity.getActivityInfo().currentLocation;
		if (location) {
			// Sys.println("Saving location");
			location = location.toDegrees(); // Array of Doubles.
			gLocationLat = location[0].toFloat();
			gLocationLng = location[1].toFloat();

			Application.getApp().setProperty("LastLocationLat", gLocationLat);
			Application.getApp().setProperty("LastLocationLng", gLocationLng);
		// If current location is not available, read stored value from Object Store, being careful not to overwrite a valid
		// in-memory value with an invalid stored one.
		} else {
			var lat = Application.getApp().getProperty("LastLocationLat");
			if (lat != null) {
				gLocationLat = lat;
			}

			var lng = Application.getApp().getProperty("LastLocationLng");
			if (lng != null) {
				gLocationLng = lng;
			}
		}
		
		Sys.println("Check check: " + gLocationLat + ", " + gLocationLng);

		if (!(Sys has :ServiceDelegate)) {
			return;
		}
		
		var pendingWebRequests = getProperty("PendingWebRequests");
		if (pendingWebRequests == null) {
			pendingWebRequests = {};
		}
		
		// 2. Weather:
		// Location must be available, weather or humidity (#113) data field must be shown.
		if (gLocationLat != null) {

			var owmCurrent = getProperty("OpenWeatherMapCurrent");

			// No existing data.
			if (owmCurrent == null) {
				pendingWebRequests["OpenWeatherMapCurrent"] = true;
			// Successfully received weather data.
			} else if (owmCurrent["cod"] == 200) {

				// Existing data is older than 30 mins.
				// TODO: Consider requesting weather at sunrise/sunset to update weather icon.
				if ((Time.now().value() > (owmCurrent["dt"] + 900)) ||
 
				// Existing data not for this location.
				// Not a great test, as a degree of longitude varies betwee 69 (equator) and 0 (pole) miles, but simpler than
				// true distance calculation. 0.02 degree of latitude is just over a mile.
				(((gLocationLat - owmCurrent["lat"]).abs() > 0.02) || ((gLocationLng - owmCurrent["lon"]).abs() > 0.02))) {
					pendingWebRequests["OpenWeatherMapCurrent"] = true;
				}
			}
		}
		

		// If there are any pending requests:
		if (pendingWebRequests.keys().size() > 0) {
			// Register for background temporal event as soon as possible.
			var lastTime = Bg.getLastTemporalEventTime();

			if (lastTime) {
				// Events scheduled for a time in the past trigger immediately.
				var nextTime = lastTime.add(new Time.Duration(5 * 60));
				Bg.registerForTemporalEvent(nextTime);
			} else {
				Bg.registerForTemporalEvent(Time.now());
			}
		}

		setProperty("PendingWebRequests", pendingWebRequests);
	}
	
	(:background_method)
	function getServiceDelegate() {
		return [new BackgroundService()];
	}
	
	// Handle data received from BackgroundService.
	// On success, clear appropriate pendingWebRequests flag.
	// data is Dictionary with single key that indicates the data type received. This corresponds with Object Store and
	// pendingWebRequests keys.
	(:background_method)
	function onBackgroundData(data) {
		Sys.println("onBackgroundData() called");
		
		var pendingWebRequests = getProperty("PendingWebRequests");
		if (pendingWebRequests == null) {
//			//Sys.println("onBackgroundData() called with no pending web requests!");
			pendingWebRequests = {};
		}

		var type = data.keys()[0]; // Type of received data.
		var storedData = getProperty(type);
		var receivedData = data[type]; // The actual data received: strip away type key.
		
		// No value in showing any HTTP error to the user, so no need to modify stored data.
		// Leave pendingWebRequests flag set, and simply return early.
		if (receivedData["httpError"]) {
			return;
		}

		// New data received: clear pendingWebRequests flag and overwrite stored data.
		storedData = receivedData;
		pendingWebRequests.remove(type);
		setProperty("PendingWebRequests", pendingWebRequests);
		setProperty(type, storedData);

		Ui.requestUpdate();
	}
	
	function getFormatedDate() {
		var now = Time.now();
		var date = Date.info(now, Time.FORMAT_SHORT);
		var date_formater = Application.getApp().getProperty("date_format");
		if (date_formater == 0) {
			if (Application.getApp().getProperty("force_date_english")) {
				var day_of_weak = date.day_of_week;
				return Lang.format("$1$ $2$",[days[day_of_weak], date.day.format("%d")]);
			} else {
				var date = Date.info(now, Time.FORMAT_LONG);
				var day_of_weak = date.day_of_week;
				return Lang.format("$1$ $2$",[day_of_weak.toUpper(), date.day.format("%d")]);
			}
		} else if (date_formater == 1) {
			// dd/mm
			return Lang.format("$1$.$2$",[date.day.format("%d"), date.month.format("%d")]);
		} else if (date_formater == 2) {
			// mm/dd
			return Lang.format("$1$.$2$",[date.month.format("%d"), date.day.format("%d")]);
		} else if (date_formater == 3) {
			// dd/mm/yyyy
			var year = date.year;
			var yy = year/100.0;
			yy = Math.round((yy-yy.toNumber())*100.0);
			return Lang.format("$1$.$2$.$3$",[date.day.format("%d"), date.month.format("%d"), yy.format("%d")]);
		} else if (date_formater == 4) {
			// mm/dd/yyyy
			var year = date.year;
			var yy = year/100.0;
			yy = Math.round((yy-yy.toNumber())*100.0);
			return Lang.format("$1$.$2$.$3$",[date.month.format("%d"), date.day.format("%d"), yy.format("%d")]);
		} else if (date_formater == 5 || date_formater == 6) {
			// dd mmm
			var day = null;
			var month = null;
			if (Application.getApp().getProperty("force_date_english")) {
				day = date.day;
				month = months[date.month];
			} else {
				var date = Date.info(now, Time.FORMAT_MEDIUM);
				day = date.day;
				month = months[date.month];
			}
			if (date_formater == 5) {
				return Lang.format("$1$ $2$",[day.format("%d"), month]);
			} else {
				return Lang.format("$1$ $2$",[month, day.format("%d")]);
			}
		}
	}
	
	function toKValue(value) {
		var valK = value/1000.0;
		return valK.format("%0.1f");
	}
}