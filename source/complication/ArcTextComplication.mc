using Toybox.WatchUi as Ui;
using Toybox.Math;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Application;

var kerning_ratios = {
    	' ' => 0.40,
    	'%' => 0.92,
		'+' => 0.70,
		'-' => 0.38,
		'.' => 0.25,
		'0' => 0.66,
		'1' => 0.41,
		'2' => 0.60,
		'3' => 0.63,
		'4' => 0.67,
		'5' => 0.63,
		'6' => 0.64,
		'7' => 0.53,
		'8' => 0.67,
		'9' => 0.64,
		':' => 0.25,
		'A' => 0.68,
		'B' => 0.68,
		'C' => 0.66,
		'D' => 0.68,
		'E' => 0.59,
		'F' => 0.56,
		'G' => 0.67,
		'H' => 0.71,
		'I' => 0.33,
		'J' => 0.64,
		'K' => 0.68,
		'L' => 0.55,
		'M' => 0.89,
		'N' => 0.73,
		'O' => 0.68,
		'P' => 0.66,
		'R' => 0.67,
		'S' => 0.67,
		'T' => 0.55,
		'U' => 0.68,
		'V' => 0.64,
		'W' => 1.00,
		'Y' => 0.64,
		'°' => 0.47,
    };

class ArcTextComplication extends Ui.Drawable {

    hidden var barRadius;
    hidden var baseRadian;
    hidden var baseDegree;
    hidden var alignment;
    hidden var font;
    hidden var perCharRadius;
    hidden var text;
    hidden var last_draw_text;
    hidden var curved_radian;
    
    var accumulation_sign;
    var angle;
    var kerning = 1.0;
    
    function initialize(params) {
        Drawable.initialize(params);
    	barRadius = centerX - (13*centerX/120).toNumber();
    	if (centerX == 109) {
    		kerning = 1.1;
    		barRadius = centerX-11;
    	} else if (centerX == 130) {
    		kerning = 0.95;
    	} else if (centerX == 195) {
    		kerning = 0.95;
    		barRadius = barRadius+4;
    	}
    	
    	baseDegree = params.get(:base);
    	baseRadian = degreesToRadians(baseDegree);
    	curved_radian = 60.0;
    	
    	text = params.get(:text);
    	angle = params.get(:angle);
    	perCharRadius = kerning*4.70*Math.PI/100;
    	barRadius += ((baseDegree < 180 ? 8 : -3)*centerX/120).toNumber();
    	accumulation_sign = (baseDegree < 180 ? -1 : 1);
    	
    	alignment = Graphics.TEXT_JUSTIFY_VCENTER|Graphics.TEXT_JUSTIFY_CENTER;

		last_draw_text = "";
    }
    
    function get_text() {
    	return text;
    }
    
    function need_draw() {
		return true;
	}
    
    function draw(dc) {
		
    	dc.setPenWidth(1);
    	
    	var text = get_text();
		
    	
    	if (last_draw_text.equals(text) && !force_render_component) {
    		// do not draw
    	} else {
    		dc.setColor(gbackground_color, Graphics.COLOR_TRANSPARENT);
			
    		dc.setPenWidth(20);
    		var target_r = barRadius-((baseDegree < 180 ? 6 : -3)*centerX/120).toNumber();
			dc.drawArc(centerX, centerY, target_r, Graphics.ARC_CLOCKWISE, 360.0-(baseDegree-30.0), 360.0-(baseDegree+30.0));
			
			dc.setPenWidth(1);
			dc.setColor(gmain_color, Graphics.COLOR_TRANSPARENT);
			
    		drawArcText(dc, text);
    		last_draw_text = text;
    	}
    }
    
    hidden function drawArcText(dc, text) {
    	var totalChar = text.length().toFloat();
    	var charArray = text.toUpper().toCharArray();
    	
    	var totalRad = 0.0;
    	for (var i=0; i<totalChar; i++) {
    		var ra = perCharRadius*kerning_ratios[charArray[i]];
    		totalRad += ra;
    	}
    	var lastRad = -totalRad/2.0;

    	for (var i=0; i<totalChar; i++) {
    		var ra = perCharRadius*kerning_ratios[charArray[i]];
    		
			lastRad += ra;
			if (charArray[i] == ' ') {
			} else {
				var centering = ra/2.0;
	    		var targetRadian = baseRadian + (lastRad-ra/2.0)*accumulation_sign;

	    		var labelCurX = convertCoorX(targetRadian, barRadius);
	    		var labelCurY = convertCoorY(targetRadian, barRadius);
	    		
	    		set_font(targetRadian);
    		
	    		dc.drawText(labelCurX, labelCurY, font, charArray[i], alignment);
	    		font = null;
    		}
    	}
    }
    
    function set_font(current_rad) {
    	var converted = current_rad+Math.PI;
    	var degree = radiansToDegrees(converted).toNumber();
    	var idx = (((degree)%180)/3).toNumber();
    	get_font(idx);
    }
    
    function get_font(idx) {
    	if (idx==0) {
		font = Ui.loadResource(Rez.Fonts.e0);
		} else if (idx==1) {
		font = Ui.loadResource(Rez.Fonts.e1);
		} else if (idx==2) {
		font = Ui.loadResource(Rez.Fonts.e2);
		} else if (idx==3) {
		font = Ui.loadResource(Rez.Fonts.e3);
		} else if (idx==4) {
		font = Ui.loadResource(Rez.Fonts.e4);
		} else if (idx==5) {
		font = Ui.loadResource(Rez.Fonts.e5);
		} else if (idx==6) {
		font = Ui.loadResource(Rez.Fonts.e6);
		} else if (idx==7) {
		font = Ui.loadResource(Rez.Fonts.e7);
		} else if (idx==8) {
		font = Ui.loadResource(Rez.Fonts.e8);
		} else if (idx==9) {
		font = Ui.loadResource(Rez.Fonts.e9);
		} else if (idx==10) {
		font = Ui.loadResource(Rez.Fonts.e10);
		} else if (idx==11) {
		font = Ui.loadResource(Rez.Fonts.e11);
		} else if (idx==12) {
		font = Ui.loadResource(Rez.Fonts.e12);
		} else if (idx==13) {
		font = Ui.loadResource(Rez.Fonts.e13);
		} else if (idx==14) {
		font = Ui.loadResource(Rez.Fonts.e14);
		} else if (idx==15) {
		font = Ui.loadResource(Rez.Fonts.e15);
		} else if (idx==16) {
		font = Ui.loadResource(Rez.Fonts.e16);
		} else if (idx==17) {
		font = Ui.loadResource(Rez.Fonts.e17);
		} else if (idx==18) {
		font = Ui.loadResource(Rez.Fonts.e18);
		} else if (idx==19) {
		font = Ui.loadResource(Rez.Fonts.e19);
		} else if (idx==20) {
		font = Ui.loadResource(Rez.Fonts.e20);
		} else if (idx==21) {
		font = Ui.loadResource(Rez.Fonts.e21);
		} else if (idx==22) {
		font = Ui.loadResource(Rez.Fonts.e22);
		} else if (idx==23) {
		font = Ui.loadResource(Rez.Fonts.e23);
		} else if (idx==24) {
		font = Ui.loadResource(Rez.Fonts.e24);
		} else if (idx==25) {
		font = Ui.loadResource(Rez.Fonts.e25);
		} else if (idx==26) {
		font = Ui.loadResource(Rez.Fonts.e26);
		} else if (idx==27) {
		font = Ui.loadResource(Rez.Fonts.e27);
		} else if (idx==28) {
		font = Ui.loadResource(Rez.Fonts.e28);
		} else if (idx==29) {
		font = Ui.loadResource(Rez.Fonts.e29);
		} else if (idx==30) {
		font = Ui.loadResource(Rez.Fonts.e30);
		} else if (idx==31) {
		font = Ui.loadResource(Rez.Fonts.e31);
		} else if (idx==32) {
		font = Ui.loadResource(Rez.Fonts.e32);
		} else if (idx==33) {
		font = Ui.loadResource(Rez.Fonts.e33);
		} else if (idx==34) {
		font = Ui.loadResource(Rez.Fonts.e34);
		} else if (idx==35) {
		font = Ui.loadResource(Rez.Fonts.e35);
		} else if (idx==36) {
		font = Ui.loadResource(Rez.Fonts.e36);
		} else if (idx==37) {
		font = Ui.loadResource(Rez.Fonts.e37);
		} else if (idx==38) {
		font = Ui.loadResource(Rez.Fonts.e38);
		} else if (idx==39) {
		font = Ui.loadResource(Rez.Fonts.e39);
		} else if (idx==40) {
		font = Ui.loadResource(Rez.Fonts.e40);
		} else if (idx==41) {
		font = Ui.loadResource(Rez.Fonts.e41);
		} else if (idx==42) {
		font = Ui.loadResource(Rez.Fonts.e42);
		} else if (idx==43) {
		font = Ui.loadResource(Rez.Fonts.e43);
		} else if (idx==44) {
		font = Ui.loadResource(Rez.Fonts.e44);
		} else if (idx==45) {
		font = Ui.loadResource(Rez.Fonts.e45);
		} else if (idx==46) {
		font = Ui.loadResource(Rez.Fonts.e46);
		} else if (idx==47) {
		font = Ui.loadResource(Rez.Fonts.e47);
		} else if (idx==48) {
		font = Ui.loadResource(Rez.Fonts.e48);
		} else if (idx==49) {
		font = Ui.loadResource(Rez.Fonts.e49);
		} else if (idx==50) {
		font = Ui.loadResource(Rez.Fonts.e50);
		} else if (idx==51) {
		font = Ui.loadResource(Rez.Fonts.e51);
		} else if (idx==52) {
		font = Ui.loadResource(Rez.Fonts.e52);
		} else if (idx==53) {
		font = Ui.loadResource(Rez.Fonts.e53);
		} else if (idx==54) {
		font = Ui.loadResource(Rez.Fonts.e54);
		} else if (idx==55) {
		font = Ui.loadResource(Rez.Fonts.e55);
		} else if (idx==56) {
		font = Ui.loadResource(Rez.Fonts.e56);
		} else if (idx==57) {
		font = Ui.loadResource(Rez.Fonts.e57);
		} else if (idx==58) {
		font = Ui.loadResource(Rez.Fonts.e58);
		} else if (idx==59) {
		font = Ui.loadResource(Rez.Fonts.e59);
		} else if (idx==60) {
		font = Ui.loadResource(Rez.Fonts.e60);
		}
    }
}