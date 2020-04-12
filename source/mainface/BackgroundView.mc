using Toybox.WatchUi as Ui;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Application;
using Toybox.Time.Gregorian as Date;

class BackgroundView extends Ui.Drawable {

	hidden var bgcir_font, bgcir_info;

    var radius;
	
    function initialize(params) {
        Drawable.initialize(params);
        radius = centerX - (10*centerX/120).toNumber();
    }

    function draw(dc) {
    	var isFull = false;
    	
    	dc.setPenWidth(4);
		dc.setColor(gsecondary_color, Graphics.COLOR_TRANSPARENT);
		var mark_length = 10;
		if (centerX==195) {
			mark_length = 20;
		}
    	for(var i = 0; i < 6; i += 1) {
		    var rad = (i.toFloat()/(6.0))*2*Math.PI;
	    	dc.drawLine(
			    convertCoorX(rad, radius - mark_length/2), 
			    convertCoorY(rad, radius - mark_length/2), 
			    convertCoorX(rad, radius + mark_length/2), 
			    convertCoorY(rad, radius + mark_length/2)
		    );
		}
		
		var ticks_style = Application.getApp().getProperty("ticks_style");
		var use_analog = Application.getApp().getProperty("use_analog");
		var digital_style = Application.getApp().getProperty("digital_style");
		var left_digital_info = Application.getApp().getProperty("left_digital_info");
		
		if (ticks_style == 0) {
			return;
		} else if (ticks_style == 1) {
			var excluded = 0;
			if (use_analog == 1) {
				excluded = -1;
			} else {
				if (digital_style == 1 || digital_style == 3) {
					excluded = -1;
				} else if (left_digital_info) {
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
		} else if (ticks_style == 2) {
			dc.setColor(garc_color, Graphics.COLOR_TRANSPARENT);
			var bonus = 0;
			if (centerX==130) {
				bonus = 2;
			} else if (centerX==140) {
				bonus = 3;
			} else if (centerX==109) {
				bonus = -2;
			}
			for(var i = 0; i < 12*5; i += 1) {

				if (use_analog != 1 && (digital_style == 2 || digital_style == 0)) {
					if (left_digital_info) {
						if (i>45 && i<55) {continue;}
					} else {
						if (i>5 && i<15) {continue;}
					}
				}

			    var rad = (i.toFloat()/(5*12.0))*2*Math.PI - 0.5*Math.PI;
			    if (i%5 == 0) {
			    	dc.setPenWidth(3);
			    } else {
			    	dc.setPenWidth(1);
			    }
			    
			    dc.drawLine(
				    convertCoorX(rad, radius - 20 - bonus), 
				    convertCoorY(rad, radius - 20 - bonus), 
				    convertCoorX(rad, radius - 13), 
				    convertCoorY(rad, radius - 13)
			    );
			}
		}
    }
}