using Toybox.WatchUi as Ui;
using Toybox.Math;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Application;
using Toybox.Time.Gregorian as Date;

class AnalogDial extends Ui.Drawable {

	hidden var secondHandDisabled;
	hidden var hour_font_1, hour_font_2, hour_font_3, hour_font_4, hour_font_5, hour_font_6;
	hidden var minu_font_1, minu_font_2, minu_font_3, minu_font_4, minu_font_5, minu_font_6;
	hidden var hour_1, hour_2, hour_3, hour_4, hour_5, hour_6;
	hidden var minu_1, minu_2, minu_3, minu_4, minu_5, minu_6;

	var offset_x = 0;
	var offset_y = 0;
	var offset_rad = 0;

	function initialize(params) {
        Drawable.initialize(params);

//    	if (centerX == 109) {
//    		offset_x = -11;
//    		offset_y = -11;
//    		offset_rad = 10;
//    	} else if (centerX == 130) {
//    		offset_x = 11;
//    		offset_y = 11;
//    	} else if (centerX == 140) {
//    		offset_x = 21;
//    		offset_y = 21;
//    	}
    	
    	secondHandDisabled = true;
    }
    
    function disableSecondHand() {
    	secondHandDisabled = true;
    }
    
    function enableSecondHand() {
    	secondHandDisabled = false;
    }
    
    function removeFontHour() {
    	hour_font_1 = null;
		hour_1 = null;
		hour_font_2 = null;
		hour_2 = null;
		hour_font_3 = null;
		hour_3 = null;
		hour_font_4 = null;
		hour_4 = null;
		hour_font_5 = null;
		hour_5 = null;
		hour_font_6 = null;
		hour_6 = null;
    }
    
    function removeFontMinute() {
    	minu_font_1 = null;
		minu_1 = null;
		minu_font_2 = null;
		minu_2 = null;
		minu_font_3 = null;
		minu_3 = null;
		minu_font_4 = null;
		minu_4 = null;
		minu_font_5 = null;
		minu_5 = null;
		minu_font_6 = null;
		minu_6 = null;
    }
    
    function removeFont() {
		removeFontHour();
		removeFontMinute();
    }
    
    function checkCurrentFont() {
    	if (Application.getApp().getProperty("use_analog") == false) {
    		removeFont();
    		return;
    	}
    	
    	checkCurrentFontHour();
    	checkCurrentFontMinute();
    }
    
    function checkCurrentFontHour() {
    	removeFontHour();
    	var hour_i = getHourHandFragment() % 60;
    	if (hour_i >= 50) {
//    		hour_font_1 = null;
//    		hour_1 = null;
//    		hour_font_2 = null;
//    		hour_2 = null;
//    		hour_font_3= null;
//    		hour_3 = null;
//    		hour_font_4 = null;
//    		hour_4 = null;
//    		hour_font_5 = null;
//    		hour_5 = null;
//    		if (hour_font_6 == null) {
	    		hour_font_6 = Ui.loadResource(Rez.Fonts.hour_6);
	    		hour_6 = Ui.loadResource(Rez.JsonData.hour_6_data);
//			}
    	} else if (hour_i >= 40) {
//    		hour_font_1 = null;
//    		hour_1 = null;
//    		hour_font_2 = null;
//    		hour_2 = null;
//    		hour_font_3= null;
//    		hour_3 = null;
//    		hour_font_4 = null;
//    		hour_4 = null;
//    		hour_font_6 = null;
//    		hour_6 = null;
//    		if (hour_font_5 == null) {
	    		hour_font_5 = Ui.loadResource(Rez.Fonts.hour_5);
	    		hour_5 = Ui.loadResource(Rez.JsonData.hour_5_data);
//			}
    	} else if (hour_i >= 30){
//    		hour_font_1 = null;
//    		hour_1 = null;
//    		hour_font_2 = null;
//    		hour_2 = null;
//    		hour_font_3= null;
//    		hour_3 = null;
//    		hour_font_5 = null;
//    		hour_5 = null;
//    		hour_font_6 = null;
//    		hour_6 = null;
//    		if (hour_font_4 == null) {
	    		hour_font_4 = Ui.loadResource(Rez.Fonts.hour_4);
	    		hour_4 = Ui.loadResource(Rez.JsonData.hour_4_data);
//			}
    	} else if (hour_i >= 20){
//    		hour_font_1 = null;
//    		hour_1 = null;
//    		hour_font_2 = null;
//    		hour_2 = null;
//    		hour_font_4= null;
//    		hour_4 = null;
//    		hour_font_5 = null;
//    		hour_5 = null;
//    		hour_font_6 = null;
//    		hour_6 = null;
//    		if (hour_font_3 == null) {
	    		hour_font_3 = Ui.loadResource(Rez.Fonts.hour_3);
	    		hour_3 = Ui.loadResource(Rez.JsonData.hour_3_data);
//			}
    	} else if (hour_i >= 10){
//    		hour_font_1 = null;
//    		hour_1 = null;
//    		hour_font_3 = null;
//    		hour_3 = null;
//    		hour_font_4= null;
//    		hour_4 = null;
//    		hour_font_5 = null;
//    		hour_5 = null;
//    		hour_font_6 = null;
//    		hour_6 = null;
//    		if (hour_font_2 == null) {
	    		hour_font_2 = Ui.loadResource(Rez.Fonts.hour_2);
	    		hour_2 = Ui.loadResource(Rez.JsonData.hour_2_data);
//			}
    	} else if (hour_i >= 0){
//    		hour_font_2 = null;
//    		hour_2 = null;
//    		hour_font_3 = null;
//    		hour_3 = null;
//    		hour_font_4= null;
//    		hour_4 = null;
//    		hour_font_5 = null;
//    		hour_5 = null;
//    		hour_font_6 = null;
//    		hour_6 = null;
//    		if (hour_font_1 == null) {
	    		hour_font_1 = Ui.loadResource(Rez.Fonts.hour_1);
	    		hour_1 = Ui.loadResource(Rez.JsonData.hour_1_data);
//			}
    	}
    }
    
    function checkCurrentFontMinute() {
    	removeFontMinute();
    	var minu_i = getMinuteHandFragment() % 60;
    	if (minu_i >= 50) {
//    		minu_font_1 = null;
//    		minu_1 = null;
//    		minu_font_2 = null;
//    		minu_2 = null;
//    		minu_font_3 = null;
//    		minu_3 = null;
//    		minu_font_4 = null;
//    		minu_4 = null;
//    		minu_font_5 = null;
//    		minu_5 = null;
//    		if (minu_font_6 == null) {
	    		minu_font_6 = Ui.loadResource(Rez.Fonts.minu_6);
				minu_6 = Ui.loadResource(Rez.JsonData.minu_6_data);
//			}
    		
    	} else if (minu_i >= 40) {
//    		minu_font_1 = null;
//    		minu_1 = null;
//    		minu_font_2 = null;
//    		minu_2 = null;
//    		minu_font_3 = null;
//    		minu_3 = null;
//    		minu_font_4 = null;
//    		minu_4 = null;
//    		minu_font_6 = null;
//    		minu_6 = null;
//    		if (minu_font_5 == null) {
	    		minu_font_5 = Ui.loadResource(Rez.Fonts.minu_5);
	    		minu_5 = Ui.loadResource(Rez.JsonData.minu_5_data);
//    		}
    	} else if (minu_i >= 30) {
//    		minu_font_1 = null;
//    		minu_1 = null;
//    		minu_font_2 = null;
//    		minu_2 = null;
//    		minu_font_3 = null;
//    		minu_3 = null;
//    		minu_font_5 = null;
//    		minu_5 = null;
//    		minu_font_6 = null;
//    		minu_6 = null;
//    		if (minu_font_4 == null) {
	    		minu_font_4 = Ui.loadResource(Rez.Fonts.minu_4);
	    		minu_4 = Ui.loadResource(Rez.JsonData.minu_4_data);
//    		}
    	} else if (minu_i >= 20) {
//    		minu_font_1 = null;
//    		minu_1 = null;
//    		minu_font_2 = null;
//    		minu_2 = null;
//    		minu_font_4 = null;
//    		minu_4 = null;
//    		minu_font_5 = null;
//    		minu_5 = null;
//    		minu_font_6 = null;
//    		minu_6 = null;
//    		if (minu_font_3 == null) {
	    		minu_font_3 = Ui.loadResource(Rez.Fonts.minu_3);
	    		minu_3 = Ui.loadResource(Rez.JsonData.minu_3_data);
//    		}
    	} else if (minu_i >= 10) {
//    		minu_font_1 = null;
//    		minu_1 = null;
//    		minu_font_3 = null;
//    		minu_3 = null;
//    		minu_font_4 = null;
//    		minu_4 = null;
//    		minu_font_5 = null;
//    		minu_5 = null;
//    		minu_font_6 = null;
//    		minu_6 = null;
//    		if (minu_font_2 == null) {
	    		minu_font_2 = Ui.loadResource(Rez.Fonts.minu_2);
	    		minu_2 = Ui.loadResource(Rez.JsonData.minu_2_data);
//    		}
    	} else if (minu_i >= 0) {
//    		minu_font_2 = null;
//    		minu_2 = null;
//    		minu_font_3 = null;
//    		minu_3 = null;
//    		minu_font_4 = null;
//    		minu_4 = null;
//    		minu_font_5 = null;
//    		minu_5 = null;
//    		minu_font_6 = null;
//    		minu_6 = null;
//    		if (minu_font_1 == null) {
	    		minu_font_1 = Ui.loadResource(Rez.Fonts.minu_1);
	    		minu_1 = Ui.loadResource(Rez.JsonData.minu_1_data);
//    		}
    	}
    }
    
    function draw(dc) {
    	if (Application.getApp().getProperty("use_analog") == false) {
    		return;
    	}
    	
		draw_analog_hands(dc);
		
		removeFont();
    }
    
    function draw_analog_hands(dc) {

		dc.setColor(gmain_color, Graphics.COLOR_TRANSPARENT);
    	drawHandAntiAlias(dc);
    	second_x = centerX;
	    second_y  = centerY - second_font_height_half*2;
    	
    	if (secondHandDisabled) {
    		return;
    	}
    	
    	// no second hand in power save mode
    	if (Application.getApp().getProperty("power_save_mode")) {
    		return;
    	}
    	
        dc.setColor(gsecondary_color, Graphics.COLOR_TRANSPARENT);
        drawSecondHand(dc);
    	
    }
    
    /////////////////////////
    /// antialias handler ///
    /////////////////////////
    
    function drawHandAntiAlias(dc) {
    	removeFont() ;
    	checkCurrentFontHour();
    	var hour_i = getHourHandFragment() % 60;
    	if (hour_i >= 50) {
    		drawTiles(hour_6[(hour_i - 50).toNumber()], hour_font_6, dc, hour_i);
    	} else if (hour_i >= 40) {
    		drawTiles(hour_5[(hour_i - 40).toNumber()], hour_font_5, dc, hour_i);
    	} else if (hour_i >= 30) {
    		drawTiles(hour_4[(hour_i - 30).toNumber()], hour_font_4, dc, hour_i);
    	} else if (hour_i >= 20) {
    		drawTiles(hour_3[(hour_i - 20).toNumber()], hour_font_3, dc, hour_i);
    	} else if (hour_i >= 10) {
    		drawTiles(hour_2[(hour_i - 10).toNumber()], hour_font_2, dc, hour_i);
    	} else {
    		drawTiles(hour_1[hour_i.toNumber()], hour_font_1, dc, hour_i);
    	}
    	removeFont() ;
    	checkCurrentFontMinute();
    	var minu_i = getMinuteHandFragment() % 60;
    	if (minu_i >= 50) {
    		drawTiles(minu_6[(minu_i - 50).toNumber()], minu_font_6, dc, minu_i);
    	} else if (minu_i >= 40) {
    		drawTiles(minu_5[(minu_i - 40).toNumber()], minu_font_5, dc, minu_i);
    	} else if (minu_i >= 30) {
    		drawTiles(minu_4[(minu_i - 30).toNumber()], minu_font_4, dc, minu_i);
    	} else if (minu_i >= 20) {
    		drawTiles(minu_3[(minu_i - 20).toNumber()], minu_font_3, dc, minu_i);
    	} else if (minu_i >= 10) {
    		drawTiles(minu_2[(minu_i - 10).toNumber()], minu_font_2, dc, minu_i);
    	} else {
    		drawTiles(minu_1[minu_i.toNumber()], minu_font_1, dc, minu_i);
    	}
    	removeFont() ;
    	
    	//System.println(""+hour_i+":"+minu_i);
    }
    
    function drawSecondHand(dc) {
        var base_radius = centerX==109 ? 0.0 : 11.0;
        var minu_radius = centerX-23.0;
        var base_thick = 3.0;
        var radian = 2*(getSecondHandFragment()/60.0)*Math.PI-0.5*Math.PI;

        var startx = convertCoorX(radian, base_radius);
        var starty = convertCoorY(radian, base_radius);
        var endx = convertCoorX(radian, minu_radius);
        var endy = convertCoorY(radian, minu_radius);

        dc.setColor(gsecondary_color, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(base_thick);
        dc.drawLine(startx, starty, endx, endy);
    }
    
    function drawTiles(packed_array,font,dc,index) {
      var radian = (index.toFloat()/60.0)*(2*3.1415) - 0.5*3.1415;
      var offset_rad_x = convertCoorX(radian, offset_rad)-centerX;
      var offset_rad_y = convertCoorY(radian, offset_rad)-centerY;
      for(var i = 0; i < packed_array.size(); i++) {
      	var val = packed_array[i];
		var char = (val >> 16) & 255;
		var xpos = (val >> 8) & 255;
		var ypos = (val >> 0) & 255;
//		System.println("char " + char + " xpos " + xpos + " ypos");
        dc.drawText((xpos+offset_x-offset_rad_x).toNumber(),(ypos+offset_y-offset_rad_y).toNumber(),font,char.toNumber().toChar(),Graphics.TEXT_JUSTIFY_LEFT);
      }
    }
    
    private function getHourHandFragment() {    	
    	var clockTime = System.getClockTime();        		
    	var hour = clockTime.hour;
		var minute = clockTime.min;		
		return (((hour*60.0+minute) / (12.0*60))*60.0).toLong();
    }
    
    private function getMinuteHandFragment() {   
    	var clockTime = System.getClockTime(); 
		return clockTime.min.toLong();
	} 	
    
    private function getSecondHandFragment() {   
    	var clockTime = System.getClockTime(); 
		return clockTime.sec.toLong();
	} 
}