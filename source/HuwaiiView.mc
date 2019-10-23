using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;

using Toybox.Time.Gregorian as Date;
using Toybox.Application as App;
using Toybox.ActivityMonitor as Mon;

var smallDigitalFont = null;
var second_digi_font = null;
var second_x = 160;
var second_y = 140;
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

class HuwaiiView extends WatchUi.WatchFace {

	var last_draw_minute = -1;
	var restore_from_resume = false;
	var last_resume_mili = 0;
	
	var view_width = 240;
	var view_height = 240;
	var centerX = 120;
	var centerY = 120;
	var font_padding = 12;
	var font_height_half = 7;
	
	var face_radius;
	var current_is_analogue = false;
	
    function initialize() {
        WatchFace.initialize();
    }

	function getViewSize() {
		return [view_width, view_height];
	}

    // Load your resources here
    function onLayout(dc) {
    	smallDigitalFont = WatchUi.loadResource(Rez.Fonts.smadigi);
    	view_width = dc.getWidth();
    	view_height = dc.getHeight();
    	centerX = view_width/2;
    	centerY = view_height/2;
    	
    	face_radius = view_width/2 - 18;
    	
//    	if (view_width==218) {
//    		face_radius = ;
//    	} else if (view_width==240) {
//    	
//    	} else if (view_width==260) {
//    	
//    	} else if (view_width==280) {
//    	
//    	}
    	current_is_analogue = Application.getApp().getProperty("use_analog");
    	
    	System.println("" + view_width + " " + view_height);
    	
        setLayout(Rez.Layouts.WatchFace(dc));
        if (HuwaiiApp has :checkPendingWebRequests) { // checkPendingWebRequests() can be excluded to save memory.
			App.getApp().checkPendingWebRequests(); // Depends on mDataFields.hasField().
		}
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    	 var clockTime = System.getClockTime(); 
    	 System.println("show");
    	 System.println("" + clockTime.min + ":" + clockTime.sec);
    	 
    	last_draw_minute = -1;
    	restore_from_resume = true;
    	last_resume_mili = System.getTimer();
    }

    // Update the view
    function onUpdate(dc) {
    	var clockTime = System.getClockTime(); 
    	
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
//    	System.println("1");
    	
//    	System.println("update");
//    	System.println("" + clockTime.min + ":" + clockTime.sec);
    	
    	force_render_component = true;
    	if (Application.getApp().getProperty("power_save_mode")) {
    		if (restore_from_resume) {
				var current_mili = System.getTimer();
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
    			var current_mili = System.getTimer();
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
    	
//    	System.println("2");
    	
    	onPartialUpdate(dc);
    }

	function mainDrawComponents(dc) {
		var start = System.getTimer();
		
		checkTheme();
		
//		System.println("3");
		
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
				digitalDisplay.checkCurrentFont();
			} else {
				// turned to analogue
				digitalDisplay.removeFont();
				analogDisplay.checkCurrentFont();
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
//		System.println("4");
		bar2.draw(dc);
//		System.println("5");
		bar3.draw(dc);
//		System.println("6");
		bar4.draw(dc);
//		System.println("7");
		bar5.draw(dc);
//		System.println("8");
		bar6.draw(dc);
//		System.println("9");
		
        dc.setColor(gbackground_color, Graphics.COLOR_TRANSPARENT);
//        dc.setColor(0x555555, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(centerX, centerY, face_radius);
		
		backgroundView.draw(dc);
//		System.println("10");
		
		bbar1.draw(dc);
		bbar2.draw(dc);
//		System.println("11");


		var bgraph1 = View.findDrawableById("tGraphDisplay");
		var bgraph2 = View.findDrawableById("bGraphDisplay");
		bgraph1.draw(dc);
		bgraph2.draw(dc);
//		System.println("12");
        
        // Call the parent onUpdate function to redraw the layout
        if (Application.getApp().getProperty("use_analog")) {
        	analogDisplay.draw(dc);
        } else {
        	digitalDisplay.draw(dc);
        }
        
//		System.println("13");
//        View.onUpdate(dc);
        var end = System.getTimer();
        
        System.println("global draw " + (end-start) + "ms");
        System.println("");
	}

	function onPartialUpdate(dc) {
		if (Application.getApp().getProperty("always_on_second") && !((Application.getApp().getProperty("use_analog")))) {
			// var start = System.getTimer();
			
			dc.setClip(second_x, second_y, second_clip_size[0], second_clip_size[1]);
			dc.setColor(Graphics.COLOR_TRANSPARENT, gbackground_color);
			dc.clear();
			var clockTime = System.getClockTime(); 
			var second_text = clockTime.sec.format("%02d");
			var ss = dc.getTextDimensions(second_text, second_digi_font);
			
			dc.setColor(gmain_color, Graphics.COLOR_TRANSPARENT);
			dc.drawText(second_x, second_y-font_padding, 
						second_digi_font, 
						second_text, 
						Graphics.TEXT_JUSTIFY_LEFT);
			dc.clearClip();
			
			// var end = System.getTimer();
			
			// System.println("spatial draw " + (end-start) + "ms");
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
		if (theme_code == 0) {
			// dark
			gbackground_color = 0x000000;
			gmain_color = 0xFFFFFF;
			gsecondary_color = 0xFF0000;
			garc_color = 0x555555;
			gbar_color_indi = 0xAAAAAA;
			gbar_color_back = 0x550000;
			gbar_color_0 = 0xFFFF00;
			gbar_color_1 = 0x0000FF;
		} else if (theme_code == 1) {
			// light
			gbackground_color = 0xFFFFFF;
			gmain_color = 0x000000;
			gsecondary_color = 0xFF0000;
			garc_color = 0xAAAAAA;
			gbar_color_indi = 0x555555;
			gbar_color_back = 0xAAAAAA;
			gbar_color_0 = 0xFFFF00;
			gbar_color_1 = 0x0000FF;
		} else if (theme_code == 2) {
			// Ocean
			gbackground_color = 0x0055AA;
			gmain_color = 0xFFFFFF;
			gsecondary_color = 0x000055;
			garc_color = 0x555555;
			gbar_color_indi = 0x000055;
			gbar_color_back = 0x00AAFF;
			gbar_color_0 = 0xFFFF00;
			gbar_color_1 = 0x0000FF;
		} else if (theme_code == 3) {
			// Orange
			gbackground_color = 0xFF5500;
			gmain_color = 0xFFFFFF;
			gsecondary_color = 0x000055;
			garc_color = 0x555555;
			gbar_color_indi = 0xFFFFFF;
			gbar_color_back = 0x000055;
			gbar_color_0 = 0xFFFF00;
			gbar_color_1 = 0x0000FF;
		} else if (theme_code == 4) {
			// radio active
			gbackground_color = 0xFFFF00;
			gmain_color = 0x000000;
			gsecondary_color = 0xAAAAAA;
			garc_color = 0x555555;
			gbar_color_indi = 0x555555;
			gbar_color_back = 0xAAAAAA;
			gbar_color_0 = 0xFF0000;
			gbar_color_1 = 0x0000FF;
		} 
//		else if (theme_code == 5) {
//			// flashlight
//			gbackground_color = 0x000000;
//			gmain_color = 0xFFFF00;
//			gsecondary_color = 0xAAAAAA;
//			garc_color = 0x555555;
//			gbar_color_indi = 0x555555;
//			gbar_color_back = 0xAAAAAA;
//			gbar_color_0 = 0xFF0000;
//			gbar_color_1 = 0x0000FF;
//		} else if (theme_code == 6) {
//			// Dusk
//			gbackground_color = 0xAAAA00;
//			gmain_color = 0xFFFF00;
//			gsecondary_color = 0xAAAAAA;
//			garc_color = 0x555555;
//			gbar_color_indi = 0x555555;
//			gbar_color_back = 0xAAAAAA;
//			gbar_color_0 = 0xFF0000;
//			gbar_color_1 = 0x0000FF;
//		} 
		else if (theme_code == 7) {
			// dark blue
			gbackground_color = 0x000000;
			gmain_color = 0xFFFFFF;
			gsecondary_color = 0x0000FF;
			garc_color = 0x555555;
			gbar_color_indi = 0xFFFFFF;
			gbar_color_back = 0x000055;
			gbar_color_0 = 0xFFFF00;
			gbar_color_1 = 0x00AAFF;
		} else if (theme_code == 8) {
			// light blue
			gbackground_color = 0xFFFFFF;
			gmain_color = 0x000000;
			gsecondary_color = 0x0000FF;
			garc_color = 0x555555;
			gbar_color_indi = 0x555555;
			gbar_color_back = 0xAAAAAA;
			gbar_color_0 = 0xFFFF00;
			gbar_color_1 = 0x0000FF;
		} else if (theme_code == 9) {
			// gray
			gbackground_color = 0x555555;
			gmain_color = 0xFFFFFF;
			gsecondary_color = 0x000000;
			garc_color = 0x000000;
			gbar_color_indi = 0xFFFFFF;
			gbar_color_back = 0xAAAAAA;
			gbar_color_0 = 0xFFFF00;
			gbar_color_1 = 0x0000FF;
		} else if (theme_code == 10) {
			// light gray
			gbackground_color = 0xAAAAAA;
			gmain_color = 0x000000;
			gsecondary_color = 0x555555;
			garc_color = 0x555555;
			gbar_color_indi = 0x000000;
			gbar_color_back = 0x555555;
			gbar_color_0 = 0xFFFF00;
			gbar_color_1 = 0x0000FF;
		} else if (theme_code == 11) {
			// pink
			gbackground_color = 0xFF0055;
			gmain_color = 0xFFFFFF;
			gsecondary_color = 0xAAAAAA;
			garc_color = 0xAAAAAA;
			gbar_color_indi = 0xFFFFFF;
			gbar_color_back = 0xAA0055;
			gbar_color_0 = 0xFFFF00;
			gbar_color_1 = 0x0000FF;
		} else if (theme_code == 12) {
			// deep ocean
			gbackground_color = 0x000055;
			gmain_color = 0xFFFFFF;
			gsecondary_color = 0x0000FF;
			garc_color = 0x0000AA;
			gbar_color_indi = 0xFFFFFF;
			gbar_color_back = 0x0000AA;
			gbar_color_0 = 0xFFFF00;
			gbar_color_1 = 0x00AAFF;
		} 
	}

}
