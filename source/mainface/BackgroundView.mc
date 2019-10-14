using Toybox.WatchUi as Ui;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Application;
using Toybox.Time.Gregorian as Date;

class BackgroundView extends Ui.Drawable {

	hidden var bgcir_font, bgcir_info;
	
	hidden var centerX;
    hidden var centerY;
    
    var radius;
	
    function initialize(params) {
        Drawable.initialize(params);
        
        var size = Application.getApp().getView().getViewSize();
        centerX = size[0]/2;
    	centerY = size[1]/2;
        radius = (size[0]/2) - 10;
    }

    function draw(dc) {
//    	var start = System.getTimer();
    
    	drawDialBackground(dc, false);
    	
//    	var end = System.getTimer();
//        System.println("background draw " + (end-start) + "ms");
    }
    
    function drawDialBackground(dc, isFull) {
//    	dc.setColor(gbackground_color, Graphics.COLOR_TRANSPARENT);
//    	dc.fillRectangle(0,0,centerX*2,centerY*2);
    
		dc.setPenWidth(4);
		dc.setColor(gsecondary_color, Graphics.COLOR_TRANSPARENT);
    	for(var i = 0; i < 6; i += 1) {
		    var rad = (i.toFloat()/(6.0))*2*Math.PI;
	    	dc.drawLine(
			    convertCoorX(rad, radius - 5), 
			    convertCoorY(rad, radius - 5), 
			    convertCoorX(rad, radius + 5), 
			    convertCoorY(rad, radius + 5)
		    );
		}
		
//		return;
		
		if (Application.getApp().getProperty("render_arc_line") == false) {
    		return;
    	}
		
		var excluded = 0;
		if (Application.getApp().getProperty("use_analog") == 1) {
			excluded = -1;
		} else {
			var digital_style = Application.getApp().getProperty("digital_style");
			if (digital_style == 3) {
				return;
			}
			
			if (digital_style == 1 || digital_style == 3) {
				excluded = -1;
			} else if (Application.getApp().getProperty("left_digital_info")) {
	    		excluded = 2;
	    	}
    	}
    	
		dc.setPenWidth(2);
		dc.setColor(garc_color, Graphics.COLOR_TRANSPARENT);
    	for(var i = 0; i < 6; i += 1) {
    		if (i==excluded) {
    			continue;
    		}
		    var rad = (i.toFloat()/(6.0))*360;
	    	dc.drawArc(
			    centerX, 
			    centerY, 
			    radius-15, 
			    dc.ARC_COUNTER_CLOCKWISE,
			    rad+5,
			    rad+55
		    );
		}
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