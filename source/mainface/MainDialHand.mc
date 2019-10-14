using Toybox.WatchUi as Ui;
using Toybox.Math;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Application;
using Toybox.Time.Gregorian as Date;

class MainDialHand extends Ui.Drawable {

	////////////////////////
    /// common variables ///
    ////////////////////////
	hidden var digitalFont, xdigitalFont;
	hidden var midDigitalFont;
	hidden var midBoldFont;
	hidden var midSemiFont;
	hidden var xmidBoldFont;
	hidden var xmidSemiFont;
	hidden var barRadius;

	///////////////////////////////
    /// non-antialias variables ///
    ///////////////////////////////
	hidden var centerX;
    hidden var centerY;
	
	hidden var alignment;
	
	function initialize(params) {
        Drawable.initialize(params);
        
        var size = Application.getApp().getView().getViewSize();
        centerX = size[0]/2;
    	centerY = size[1]/2;
        barRadius = centerX - 10;
        
        alignment = Graphics.TEXT_JUSTIFY_VCENTER|Graphics.TEXT_JUSTIFY_CENTER;
    }
    
    function disableSecondHand() {
    	secondHandDisabled = true;
    }
    
    function enableSecondHand() {
    	secondHandDisabled = false;
    }
    
    function checkCurrentFont() {
    
    	if (Application.getApp().getProperty("use_analog") == true) {
    		midBoldFont = null;
			midSemiFont = null;
    		xmidBoldFont = null;
			xmidSemiFont = null;
			xdigitalFont = null;
			digitalFont = null;
			midDigitalFont = null;
    		return;
    	}
    
    	var digital_style = Application.getApp().getProperty("digital_style");
    	if (digital_style == 0) {
    		// big
    		midBoldFont = null;
			midSemiFont = null;
			xmidBoldFont = null;
			xmidSemiFont = null;
			xdigitalFont = null;
			if (digitalFont == null) {
				digitalFont = Ui.loadResource(Rez.Fonts.bigdigi);
				midDigitalFont = Ui.loadResource(Rez.Fonts.middigi);
			}
    	} else if (digital_style == 1) {
    		// small
    		xdigitalFont = null;
    		digitalFont = null;
    		xmidBoldFont = null;
			xmidSemiFont = null;
    		midDigitalFont = null;
    		if(midBoldFont == null) {
    			midBoldFont = Ui.loadResource(Rez.Fonts.midbold);
				midSemiFont = Ui.loadResource(Rez.Fonts.midsemi);
    		}
    	} else if (digital_style == 2) {
    		// extra big
    		midBoldFont = null;
			midSemiFont = null;
			digitalFont = null;
			xmidBoldFont = null;
			xmidSemiFont = null;
			if (xdigitalFont == null) {
				xdigitalFont = Ui.loadResource(Rez.Fonts.xbigdigi);
				midDigitalFont = Ui.loadResource(Rez.Fonts.middigi);
			}
    	} else {
    		// medium
    		xdigitalFont = null;
    		digitalFont = null;
    		midBoldFont = null;
			midSemiFont = null;
    		midDigitalFont = null;
    		if(xmidBoldFont == null) {
    			xmidBoldFont = Ui.loadResource(Rez.Fonts.xmidbold);
				xmidSemiFont = Ui.loadResource(Rez.Fonts.xmidsemi);
    		}
    	}
    	
    }
    
    function draw(dc) {
//    	var start = System.getTimer();
    	
    	// possibly remove all font to save memory
    	checkCurrentFont();
    
    	if (Application.getApp().getProperty("use_analog") == true) {
    		return;
    	}
    	
    	var currentSettings = System.getDeviceSettings();
    	var clockTime = System.getClockTime();   
    	var hour = clockTime.hour;	
    	if(!(currentSettings.is24Hour)) {
			hour = hour % 12;
        	hour = (hour == 0) ? 12 : hour;  
        }    
		var minute = clockTime.min;
		
		var digital_style = Application.getApp().getProperty("digital_style");
		var alwayon_style = Application.getApp().getProperty("always_on_style");
		if (digital_style == 0 || digital_style == 2) { // big or extra big
			var bignumber = Application.getApp().getProperty("big_number_type") == 0 ? minute : hour;
			var smallnumber = Application.getApp().getProperty("big_number_type") == 0 ? hour : minute;
			
			var target_center_font = digital_style == 0 ? digitalFont : xdigitalFont;
			
			// DRAW CENTER
	    	var bigText = bignumber.format("%02d");
	    	dc.setPenWidth(1);     
	    	dc.setColor(gmain_color, Graphics.COLOR_TRANSPARENT);
	    	var h = dc.getFontHeight(target_center_font);
	    	var w = dc.getTextWidthInPixels(bigText, target_center_font);
	    	dc.drawText(centerX, centerY-h/4, target_center_font, bigText, alignment);
	    	
	    	// DRAW STRIPES
	    	if (Application.getApp().getProperty("big_num_stripes")) {
		    	dc.setColor(gbackground_color, Graphics.COLOR_TRANSPARENT);
		    	var w2 = dc.getTextWidthInPixels("\\", target_center_font);
		    	dc.drawText(centerX + w2 -w/2, centerY-h/4, target_center_font, "\\", Graphics.TEXT_JUSTIFY_VCENTER);
	    	}
	    	
	    	var f_align = digital_style == 0 ? 62 : 71;
	    	
	    	second_x = centerX+w/2 + 3;
	    	
	    	if (centerX==109 && digital_style == 2) {
	    		second_y  = centerY - second_font_height_half/2 - (alwayon_style == 0 ? 3 : 6);
	    	} else {
	    		second_y  = centerY+(h-f_align)/2 - second_font_height_half*2 + (alwayon_style == 0 ? 0 : 5);
	    	}
	    	// DRAW INFOS
	    	
	    	// calculate alignment
	    	var bonus_alignment = 0;
	    	var extra_info_alignment = 0;
	    	var vertical_alignment = 0;
	    	if (centerX==109) {
	    		bonus_alignment = 4;
	    		if (digital_style == 2) {
	    			bonus_alignment = 4;
	    			vertical_alignment = -23;
	    		}
	    	} else if (centerX==120 && digital_style == 2) {
	    		bonus_alignment = 6;
	    		extra_info_alignment = 4;
	    	} 
	    	var target_info_x = centerX*1.6;
	    	if (Application.getApp().getProperty("left_digital_info")) {
	    		target_info_x = centerX*0.4;
	    		bonus_alignment = -bonus_alignment;
	    		extra_info_alignment = -extra_info_alignment;
	    	}
	    	
	    	// draw background of date
	    	// this is a need to prevent power save mode not re-render
	    	
	    	dc.setColor(gbackground_color, Graphics.COLOR_TRANSPARENT);
//    		dc.setColor(0x555555, Graphics.COLOR_TRANSPARENT);
    		dc.setPenWidth(20);
	    	if (Application.getApp().getProperty("left_digital_info")) {
				dc.drawArc(centerX, centerY, barRadius, Graphics.ARC_CLOCKWISE, 180-10, 120+10);
	    	} else {
	    		dc.drawArc(centerX, centerY, barRadius, Graphics.ARC_CLOCKWISE, 60-10, 0+10);
	    	}
	    	dc.setPenWidth(1);
	    	
	    	// draw secondary info
	    	dc.setColor(gmain_color, Graphics.COLOR_TRANSPARENT);
	    	var h2 = dc.getFontHeight(midDigitalFont);
	    	dc.drawText(target_info_x+bonus_alignment, centerY*0.7-h2/4 + 5 + vertical_alignment, midDigitalFont, smallnumber.format("%02d"), alignment);
	    	
	    	if (centerX==109 && digital_style == 2) {
	    		return;
	    	}
			
			// draw date str
			var dateText = Application.getApp().getFormatedDate();
			dc.setColor(gmain_color, Graphics.COLOR_TRANSPARENT);
			var h3 = dc.getFontHeight(smallDigitalFont);
			dc.drawText(target_info_x-bonus_alignment+extra_info_alignment, centerY*0.4-h3/4 + 7, smallDigitalFont, dateText, alignment);
			
			// horizontal line
			var w3 = dc.getTextWidthInPixels(dateText, smallDigitalFont);
			dc.setPenWidth(2);     
			dc.setColor(gsecondary_color, Graphics.COLOR_TRANSPARENT);
			dc.drawLine(target_info_x-bonus_alignment-w3/2+extra_info_alignment, centerY*0.5 + 7, target_info_x-bonus_alignment+w3/2+extra_info_alignment, centerY*0.5 + 7);
			
		} else if (digital_style == 1) {
			var hourText = hour.format("%02d");
			var minuText = minute.format("%02d");
			var hourW = dc.getTextWidthInPixels(hourText, midBoldFont).toFloat();
			var h = dc.getFontHeight(midBoldFont).toFloat();
			var minuW = dc.getTextWidthInPixels(minuText, midSemiFont).toFloat();
			var half = (hourW+minuW + 6.0)/2.0;
			var left = centerX-half;
			
			dc.setColor(gmain_color, Graphics.COLOR_TRANSPARENT);
			dc.drawText(left.toNumber(), centerY-70, midBoldFont, hourText, Graphics.TEXT_JUSTIFY_LEFT);
			dc.drawText((left+hourW+6.0).toNumber(), centerY-70, midSemiFont, minuText, Graphics.TEXT_JUSTIFY_LEFT);
			
			var f_align = 40;
	    	second_x = centerX+half+1;
	    	
	    	second_y  = centerY - second_font_height_half/2 - (alwayon_style == 0 ? 3 : 6);
		} else {
			var hourText = hour.format("%02d");
			var minuText = minute.format("%02d");
			var hourW = dc.getTextWidthInPixels(hourText, xmidBoldFont).toFloat();
			var h = dc.getFontHeight(xmidBoldFont).toFloat();
			var minuW = dc.getTextWidthInPixels(minuText, xmidSemiFont).toFloat();
			var half = (hourW+minuW + 6.0)/2.0;
			var left = centerX-half;
			
			dc.setColor(gmain_color, Graphics.COLOR_TRANSPARENT);
			dc.drawText(left.toNumber(), centerY-83, xmidBoldFont, hourText, Graphics.TEXT_JUSTIFY_LEFT);
			dc.drawText((left+hourW+6.0).toNumber(), centerY-83, xmidSemiFont, minuText, Graphics.TEXT_JUSTIFY_LEFT);
			
			var f_align = 40;
	    	second_x = centerX+half+1;
	    	second_y  = centerY - second_font_height_half/2 - (alwayon_style == 0 ? 3 : 6);
		}
		
//		var end = System.getTimer();
//        System.println("digital draw  " + (end-start) + "ms");
    }
    
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
}