using Toybox.Application;
using Toybox.Activity as Activity;
using Toybox.System as Sys;
using Toybox.Time;
using Toybox.Time.Gregorian as Date;

// In-memory current location.
// Previously persisted in App.Storage, but now persisted in Object Store due to #86 workaround for App.Storage firmware bug.
// Current location retrieved/saved in checkPendingWebRequests().
// Persistence allows weather and sunrise/sunset features to be used after watch face restart, even if watch no longer has current
// location available.
var gLocationLat = null;
var gLocationLng = null;

class HuwaiiApp extends Application.AppBase {

	var mView;
	var days;
	
    function initialize() {
        AppBase.initialize();
        
        days = {Date.DAY_MONDAY => "MON", 
				Date.DAY_TUESDAY => "TUE", 
				Date.DAY_WEDNESDAY => "WED", 
				Date.DAY_THURSDAY => "THU", 
				Date.DAY_FRIDAY => "FRI", 
				Date.DAY_SATURDAY => "SAT", 
				Date.DAY_SUNDAY => "SUN"};
    }

    // onStart() is called on application start up
    function onStart(state) {
    	// var clockTime = Sys.getClockTime(); 
    	 Sys.println("start");
    	// Sys.println("" + clockTime.min + ":" + clockTime.sec);
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    	// var clockTime = Sys.getClockTime(); 
    	 System.println("stop");
    	// Sys.println("" + clockTime.min + ":" + clockTime.sec);
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
//		Sys.println("Check check: " + gLocationLat + ", " + gLocationLng);
	}
	
	function getFormatedDate() {
		var now = Time.now();
		var date_formater = Application.getApp().getProperty("date_format");
		if (date_formater == 0) {
			if (Application.getApp().getProperty("force_date_english")) {
				var date = Date.info(now, Time.FORMAT_SHORT);
				var day_of_weak = date.day_of_week;
				return Lang.format("$1$ $2$",[days[day_of_weak], date.day.format("%d")]);
			} else {
				var date = Date.info(now, Time.FORMAT_LONG);
				var day_of_weak = date.day_of_week;
				return Lang.format("$1$ $2$",[day_of_weak.toUpper(), date.day.format("%d")]);
			}
		} else if (date_formater == 1) {
			// dd/mm
			var date = Date.info(now, Time.FORMAT_SHORT);
			return Lang.format("$1$.$2$",[date.day.format("%d"), date.month.format("%d")]);
		} else if (date_formater == 2) {
			// mm/dd
			var date = Date.info(now, Time.FORMAT_SHORT);
			return Lang.format("$1$.$2$",[date.month.format("%d"), date.day.format("%d")]);
		} else if (date_formater == 3) {
			// dd/mm/yyyy
			var date = Date.info(now, Time.FORMAT_SHORT);
			var year = date.year;
			var yy = year/100.0;
			yy = Math.round((yy-yy.toNumber())*100.0);
			return Lang.format("$1$.$2$.$3$",[date.day.format("%d"), date.month.format("%d"), yy.format("%d")]);
		} else if (date_formater == 4) {
			// mm/dd/yyyy
			var date = Date.info(now, Time.FORMAT_SHORT);
			var year = date.year;
			var yy = year/100.0;
			yy = Math.round((yy-yy.toNumber())*100.0);
			return Lang.format("$1$.$2$.$3$",[date.month.format("%d"), date.day.format("%d"), yy.format("%d")]);
		}
	}
}