using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;

using Toybox.Time.Gregorian as Date;
using Toybox.Application as App;
using Toybox.ActivityMonitor as Mon;
using Toybox.UserProfile;

var smallDigitalFont = null;
var second_digi_font = null;
var second_x = 160;
var second_y = 140;
var heart_x = 80;

var second_font_height_half = 7;
var second_background_color = 0x000000;
var second_font_color = 0xFFFFFF;
var second_clip_size = null;

// theming
var gbackground_color = 0x000000;
var gmain_color = 0xFFFFFF;
var gsecondary_color = 0xFF0000;
var garc_color = 0x555555;
var gbar_color_indi = 0xAAAAAA;
var gbar_color_back = 0x550000;
var gbar_color_0 = 0xFFFF00;
var gbar_color_1 = 0x0000FF;

var force_render_component = false;

var last_battery_percent = -1;
var last_hour_consumtion = -1;

class HuwaiiView extends WatchUi.WatchFace {

	var last_draw_minute = -1;
	var restore_from_resume = false;
	var last_resume_mili = 0;
	
	var last_battery_hour = null;
	
	var font_padding = 12;
	var font_height_half = 7;
	
	var face_radius;
	var current_is_analogue = false;
	
	var did_clear = false;
	
	var last_theme_code = -1;

    var screenbuffer = null;
	
    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
    	smallDigitalFont = WatchUi.loadResource(Rez.Fonts.smadigi);
    	centerX = dc.getWidth()/2;
    	centerY = dc.getHeight()/2;
    	
    	face_radius = centerX - (18*centerX/120).toNumber();

    	current_is_analogue = Application.getApp().getProperty("use_analog");
    	
        setLayout(Rez.Layouts.WatchFace(dc));

        // vivoactive4(s) sometimes clears the watch dc before onupdate
        if(Application.getApp().getProperty("enable_buffering")) {
            // create a buffer to draw to 
            // so it can be pasted straight to
            // the screen instead of redrawing
            System.println("device has clearbufferbug");
            if (Toybox.Graphics has :BufferedBitmap) {
                screenbuffer = new Graphics.BufferedBitmap(
                        {:width=>dc.getWidth(),
                        :height=>dc.getHeight(),
                        } );
            }
        }
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    	 var clockTime = System.getClockTime(); 

    	last_draw_minute = -1;
    	restore_from_resume = true;
    	last_resume_mili = System.getTimer();
    	
    	if (HuwaiiApp has :checkPendingWebRequests) { // checkPendingWebRequests() can be excluded to save memory.
			App.getApp().checkPendingWebRequests(); // Depends on mDataFields.hasField().
		}
    }

    // Update the view
    function onUpdate(dc) {
    	
    	var clockTime = System.getClockTime();
    	var current_tick = System.getTimer();

//		System.println("" + current_time_duration + ", " + sleep_time + ", " + wake_time);
		
////		System.println("" + is_in_sleep + ", " + Application.getApp().getProperty("sleep_time_behaviour") + ", " + did_clear);
//		var sleep_time_behaviour = Application.getApp().getProperty("sleep_time_behaviour");
//		if (sleep_time_behaviour == 1) {
//			var profile = UserProfile.getProfile();
//			var current_time_duration = clockTime.hour*3600 + clockTime.min*60 + clockTime.sec;
//	    	var sleep_time = profile.sleepTime.value();
//	    	var wake_time = profile.wakeTime.value();
//		
//			var is_in_sleep = false;
//			if (wake_time < sleep_time) {
//				// sleep before 24h wake after 24
//				if (current_time_duration >= sleep_time) {
//					is_in_sleep = true;
//				} else if (current_time_duration <= wake_time) {
//					is_in_sleep = true;
//				}
//			} else {
//				// sleep & wake after 24
//				if ((current_time_duration >= sleep_time) && (current_time_duration <= wake_time)) {
//					is_in_sleep = true;
//				}
//			}
//			
//			if (is_in_sleep) {
//				if (!did_clear) {
//					dc.setColor(0x000000, 0x000000);
//					dc.clear();
//					did_clear = true;
//				}
//				return;
//			} else {
//				did_clear = false;
//			}
//		}
    	
//    	System.println("1");
    	
//    	System.println("update");
//    	System.println("" + clockTime.min + ":" + clockTime.sec);
    	
    	var time_now = Time.now();
    	if (last_battery_hour == null) {
    		last_battery_hour = time_now;
    		last_battery_percent = System.getSystemStats().battery;
    		last_hour_consumtion = -1;
    	} else if (time_now.compare(last_battery_hour) >= 60*60) { // 60 min
    		last_battery_hour = time_now;
    		var current_battery = System.getSystemStats().battery;
    		last_hour_consumtion = last_battery_percent-current_battery;
    		if (last_hour_consumtion < 0) {
    			last_hour_consumtion = -1;
    		}
			if (last_hour_consumtion>0) {
    			App.getApp().setProperty("last_hour_consumtion", last_hour_consumtion);
    			
				var consumtion_history = App.getApp().getProperty("consumtion_history");
				if (consumtion_history == null) {
					App.getApp().setProperty("consumtion_history", [last_hour_consumtion]);
				} else {
//					System.println(consumtion_history);
//					System.println(last_hour_consumtion);
					consumtion_history.add(last_hour_consumtion);
					if (consumtion_history.size() > 24) {
						var object0 = consumtion_history[0];
						consumtion_history.remove(object0);
					}
					App.getApp().setProperty("consumtion_history", consumtion_history);
				}
//				System.println("consumtion_history_set");
//				System.println(App.getApp().getProperty("consumtion_history"));
    		}
    		last_battery_percent = current_battery;
    	} else {
    		//System.println(time_now.compare(last_battery_hour));
    	}
        
        // if this device has the clear dc bug
        // use a screen buffer to save having to redraw
        // everything on every update
        if (Application.getApp().getProperty("power_save_mode")
                && screenbuffer != null) {
            var current_minute = clockTime.min;
            // if minute has changed, draw to the buffer
            if (current_minute!=last_draw_minute) {
                last_draw_minute = current_minute;
                force_render_component = true;
                mainDrawComponents(screenbuffer.getDc());
                force_render_component = false;
            }
            // copy buffer to screen
            dc.drawBitmap(0,0,screenbuffer);
            return;
        } 
    	
        var always_on_style = Application.getApp().getProperty("always_on_style");
    	if (always_on_style == 0) {
    		second_digi_font = WatchUi.loadResource(Rez.Fonts.secodigi);
    		second_font_height_half = 7;
    		second_clip_size = [20, 15];
    	} else {
    		second_digi_font = WatchUi.loadResource(Rez.Fonts.xsecodigi);
    		second_font_height_half = 14;
    		second_clip_size = [26, 22];
    	}
    	
    	force_render_component = true;
    	if (Application.getApp().getProperty("power_save_mode")) {
    		if (restore_from_resume) {
				var current_mili = current_tick;
				force_render_component = true;
				// will allow watch face to refresh in 5s when resumed (`onShow()` called)
				if ((current_mili-last_resume_mili) > 5000) {
					restore_from_resume = false;
				}
				// in resume time
				mainDrawComponents(dc);
				force_render_component = false;
    		} else {
	    		var current_minute = clockTime.min;
	    		if (current_minute!=last_draw_minute) {
	    			// continue
	    			last_draw_minute = current_minute;
	    			// minute turn
	    			mainDrawComponents(dc);
	    		} else {
	    			// only draw spatial
//	    			return;
	    		}
    		}
    	} else {
    		last_draw_minute = -1;
    		// normal power mode
    		if (restore_from_resume) {
    			var current_mili = current_tick;
				force_render_component = true;
				// will allow watch face to refresh in 5s when resumed (`onShow()` called)
				if ((current_mili-last_resume_mili) > 5000) {
					restore_from_resume = false;
				}
			}
			force_render_component = true;
    		mainDrawComponents(dc);
    		force_render_component = false;
    	}
    	force_render_component = false;
    	
    	onPartialUpdate(dc);
    }

	function mainDrawComponents(dc) {
		checkTheme();
		
		if (force_render_component) {
			dc.setColor(Graphics.COLOR_TRANSPARENT, gbackground_color);
			dc.clear();
			dc.setColor(gbackground_color, Graphics.COLOR_TRANSPARENT);
    		dc.fillRectangle(0,0,centerX*2,centerY*2);
		}
		
		var analogDisplay = View.findDrawableById("analog");
		var digitalDisplay = View.findDrawableById("digital");
		
		if (current_is_analogue != Application.getApp().getProperty("use_analog")){
			// switch style
			if (current_is_analogue) {
				// turned to digital
				analogDisplay.removeFont();
			} else {
				// turned to analogue
				digitalDisplay.removeFont();
			}
		}
		
		var backgroundView = View.findDrawableById("background");
		var bar1 = View.findDrawableById("aBarDisplay");
		var bar2 = View.findDrawableById("bBarDisplay");
		var bar3 = View.findDrawableById("cBarDisplay");
		var bar4 = View.findDrawableById("dBarDisplay");
		var bar5 = View.findDrawableById("eBarDisplay");
		var bar6 = View.findDrawableById("fBarDisplay");
		var bbar1 = View.findDrawableById("bUBarDisplay");
		var bbar2 = View.findDrawableById("tUBarDisplay");
		
		bar1.draw(dc);
		bar2.draw(dc);
		bar3.draw(dc);
		bar4.draw(dc);
		bar5.draw(dc);
		bar6.draw(dc);
		
        dc.setColor(gbackground_color, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(centerX, centerY, face_radius);
		
		backgroundView.draw(dc);
		bbar1.draw(dc);
		bbar2.draw(dc);

		var bgraph1 = View.findDrawableById("tGraphDisplay");
		var bgraph2 = View.findDrawableById("bGraphDisplay");
		bgraph1.draw(dc);
		bgraph2.draw(dc);
		
        // Call the parent onUpdate function to redraw the layout
        if (Application.getApp().getProperty("use_analog")) {
        	analogDisplay.draw(dc);
        } else {
        	digitalDisplay.draw(dc);
        }
        
	}

	function onPartialUpdate(dc) {
		if (!((Application.getApp().getProperty("use_analog")))) {
			if (Application.getApp().getProperty("always_on_second")) {
				var clockTime = System.getClockTime(); 
				var second_text = clockTime.sec.format("%02d");
				var ss = dc.getTextDimensions(second_text, second_digi_font);
				
				dc.setClip(second_x, second_y, second_clip_size[0], second_clip_size[1]);
				dc.setColor(Graphics.COLOR_TRANSPARENT, gbackground_color);
				dc.clear();
				dc.setColor(gmain_color, Graphics.COLOR_TRANSPARENT);
				dc.drawText(second_x, second_y-font_padding, 
							second_digi_font, 
							second_text, 
							Graphics.TEXT_JUSTIFY_LEFT);
				dc.clearClip();
			}
			
			if (Application.getApp().getProperty("always_on_heart")) {
				
				var h = _retrieveHeartrate();
				var heart_text = "--";
				if (h != null) {
					heart_text = h.format("%d");
				}
				var ss = dc.getTextDimensions(heart_text, second_digi_font);
				var s = (ss[0]*1.2).toNumber();
				var s2 = (second_clip_size[0]*1.25).toNumber();
				dc.setClip(heart_x-s2-1, second_y, s2+2, second_clip_size[1]);
				dc.setColor(Graphics.COLOR_TRANSPARENT, gbackground_color);
				
				dc.clear();
				dc.setColor(gmain_color, Graphics.COLOR_TRANSPARENT);
				dc.drawText(heart_x-1, second_y-font_padding, 
							second_digi_font, 
							heart_text, 
							Graphics.TEXT_JUSTIFY_RIGHT);
				dc.clearClip();
			}
		}
	}

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    	// var clockTime = System.getClockTime(); 
    	// System.println("hide");
    	// System.println("" + clockTime.min + ":" + clockTime.sec);
    }
    
    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
		var dialDisplay = View.findDrawableById("analog");
		dialDisplay.enableSecondHand();
    	
    	if (HuwaiiApp has :checkPendingWebRequests) { // checkPendingWebRequests() can be excluded to save memory.
			App.getApp().checkPendingWebRequests(); // Depends on mDataFields.hasField().
		}
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
   		var dialDisplay = View.findDrawableById("analog");
		dialDisplay.disableSecondHand();
    }

	function checkTheme() {
		var theme_code = Application.getApp().getProperty("theme_code");
		if (last_theme_code == -1 || last_theme_code != theme_code) {
			var theme_pallete = WatchUi.loadResource(Rez.JsonData.theme_pallete);
			var theme = theme_pallete[""+theme_code];
			gbackground_color = theme[0];
			gmain_color = theme[1];
			gsecondary_color = theme[2];
			garc_color = theme[3];
			gbar_color_indi = theme[4];
			gbar_color_back = theme[5];
			gbar_color_0 = theme[6];
			gbar_color_1 = theme[7];
		}
	}

}
