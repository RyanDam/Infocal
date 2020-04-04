using Toybox.WatchUi as Ui;
using Toybox.Math;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Application;

class BarComplication extends Ui.Drawable {

    hidden var position, position_y_draw;
    hidden var font, fontInfo, arrFont, arrInfo;
    hidden var textFont;
    
    function initialize(params) {
    	Drawable.initialize(params);
    	position = params.get(:position);
    }
	
	function load_font() {
		if (position == 0) {
    		// up
    		font = Ui.loadResource(Rez.Fonts.cur_up);
    		arrFont = Ui.loadResource(Rez.Fonts.arr_up);
    		if (centerX == 120) {
	    		fontInfo = [
	    			[0x213130,0x223142,0x234330],
					[0x244923,0x255b23],
					[0x266820,0x277a20],
					[0x288823,0x299a23],
					[0x2aa430,0x2ba442,0x2cb630,0x2db642],
	    		];
	    		arrInfo = [
	    			[0x213e3f],
					[0x22552e],
					[0x237028],
					[0x248c2e],
					[0x25a43f],
	    		];
	    		position_y_draw = centerY - 36 - 18 - 14; // font height 14
    		} else if (centerX == 130) {
	    		fontInfo = [
	    			[0x213736,0x223748,0x234936],
					[0x245028,0x256228],
					[0x267125,0x278325],
					[0x289328,0x29a528],
					[0x2ab136,0x2bb148,0x2cc336,0x2dc348],
	    		];
	    		arrInfo = [
	    			[0x214544],
					[0x225d33],
					[0x23792d],
					[0x249733],
					[0x25b044],
	    		];
	    		position_y_draw = centerY - 36 - 18 - 14 - 4; // font height 14
    		} else if (centerX == 140) {
	    		fontInfo = [
	    			[0x213938,0x22394a,0x234b38],
					[0x245528,0x25553a,0x266728],
					[0x277925,0x288b25],
					[0x299f28,0x2ab128,0x2bb13a],
					[0x2cc138,0x2dc14a,0x2ed338,0x2fd34a],
	    		];
	    		arrInfo = [
	    			[0x214847],
					[0x226233],
					[0x23832d],
					[0x24a433],
					[0x25c147],
	    		];
	    		position_y_draw = centerY - 36 - 18 - 14 - 8; // font height 14
    		} else {
	    		fontInfo = [
	    			[0x212d2d,0x222d3f,0x233f2d],
					[0x244321,0x255521],
					[0x265e1e,0x27701e],
					[0x287b21,0x298d21],
					[0x2a942d,0x2b943f,0x2ca62d,0x2da63f],
	    		];
	    		arrInfo = [
	    			[0x213a39],
					[0x224e2b],
					[0x236626],
					[0x247e2b],
					[0x259239],
	    		];
	    		position_y_draw = centerY - 36 - 18 - 14 + 5; // font height 14
    		}
    		
    	} else {
    		// down
    		font = Ui.loadResource(Rez.Fonts.cur_bo);
    		arrFont = Ui.loadResource(Rez.Fonts.arr_bo);
    		if (centerX == 120) {
	    		fontInfo = [
	    			[0x2131a5,0x2231b7,0x2343a5,0x2443b7],
					[0x2549ba,0x265bba],
					[0x2768c5,0x287ac5],
					[0x2988ba,0x2a9aba],
					[0x2ba4a5,0x2ca4b7,0x2db6a5],
	    		];
	    		arrInfo = [
	    			[0x213ea4],
					[0x2255b5],
					[0x2370bc],
					[0x248cb5],
					[0x25a4a4],
	    		];
	    		position_y_draw = centerY + 36;
    		} else if (centerX == 130) {
	    		fontInfo = [
	    			[0x2137b2,0x2237c4,0x2349b2,0x2449c4],
					[0x2550c8,0x2662c8],
					[0x2771d4,0x2883d4],
					[0x2993c8,0x2aa5c8],
					[0x2bb1b2,0x2cb1c4,0x2dc3b2],
	    		];
	    		arrInfo = [
	    			[0x2145b1],
					[0x225dc3],
					[0x2379cb],
					[0x2497c3],
					[0x25b0b1],
	    		];
	    		position_y_draw = centerY + 36 + 4;
    		} else if (centerX == 140) {
	    		fontInfo = [
	    			[0x2139c2,0x2239d4,0x234bc2,0x244bd4],
					[0x2555db,0x2667db,0x2767ed],
					[0x2879e7,0x298be7],
					[0x2a9fdb,0x2b9fed,0x2cb1db],
					[0x2dc1c1,0x2ec1d3,0x2fd3c1],
	    		];
	    		arrInfo = [
	    			[0x2148c2],
					[0x2262d6],
					[0x2383df],
					[0x24a4d6],
					[0x25c1c2],
	    		];
	    		position_y_draw = centerY + 36 + 8;
    		} else {
	    		fontInfo = [
	    			[0x212d94,0x222da6,0x233f94,0x243fa6],
					[0x2543a7,0x2655a7],
					[0x275eb1,0x2870b1],
					[0x297ba7,0x2a8da7],
					[0x2b9494,0x2c94a6,0x2da694],
	    		];
	    		arrInfo = [
	    			[0x213a93],
					[0x224ea2],
					[0x2366a8],
					[0x247ea2],
					[0x259293],
	    		];
	    		position_y_draw = centerY + 36 - 5;
    		}
    		
    	}
	}
	
	function min_val() {
    	return 0.0;
    }
    
    function max_val() {
    	return 5.0;
    }
    
    function cur_val() {
    	return 3.0;
    }
    
    function get_title() {
    	return "Step 2577";
    }

	function need_draw() {
		return true;
	}
    
    function bar_data() {
		return false;
	}
    
    function draw(dc) {
//    	var start = System.getTimer();
		load_font();
		
		var primaryColor = position == 1 ? gbar_color_1 : gbar_color_0;
    	
    	var bonus_padding = 0;
    	if (bar_data()) {
	    	var mi = min_val().toFloat(); // 0
	    	var ma = max_val().toFloat(); // 5
	    	var cu = cur_val().toFloat(); // 1
	    	
	    	var i = 0;
	    	if (cu >= ma) {
	    		i = 4;
	    	} else if (cu <= mi) {
	    		i = -1;
	    	} else {
	    		var fraction = (cu-mi)/(ma-mi);
	    		if (fraction > 0.81) {
	    			i = 4;
	    		} else if (fraction > 0.61) {
	    			i = 3;
	    		} else if (fraction > 0.41) {
	    			i = 2;
	    		} else if (fraction > 0.21) {
	    			i = 1;
	    		} else {
	    			i = 0;
	    		}
	    	}
	    	
	    	var start2 = System.getTimer();
	    	for (var j=0;j<=4;j++) {
	    		if (j==i) {
	    			dc.setColor(primaryColor, Graphics.COLOR_TRANSPARENT);
	    		} else {
	    			dc.setColor(gbar_color_back, Graphics.COLOR_TRANSPARENT);
	    		}
	    		drawTiles(fontInfo[j], font, dc);
	    	}
	    	
	    	if (i>=0) {
		    	dc.setColor(gbar_color_indi, Graphics.COLOR_TRANSPARENT);
		    	drawTiles(arrInfo[i], arrFont, dc);
	    	}
//	    	var end2 = System.getTimer();
//        	System.println(" render bar  " + (end2-start2) + "ms: ");
    	} else {
    		bonus_padding = position==0 ? -7 : 5;
    	}
    	
    	var title = get_title().toUpper();
    	dc.setColor(gmain_color, Graphics.COLOR_TRANSPARENT);
//    	var startt = System.getTimer();
    	dc.drawText(centerX, position_y_draw+bonus_padding, smallDigitalFont, title, Graphics.TEXT_JUSTIFY_CENTER);
    	
//    	var end = System.getTimer();
//        System.println("bar draw " + (end-start) + "ms: " + title + " text draw " + (end-startt));

		font = null;
		fontInfo = null;
		arrFont = null;
		arrInfo = null;
    }
    
    function drawTiles(packed_array,font,dc) {
		for(var i = 0; i < packed_array.size(); i++) {
		  	var val = packed_array[i];
			var char = (val >> 16) & 255;
			var xpos = (val >> 8) & 255;
			var ypos = (val >> 0) & 255;
		    dc.drawText((xpos).toNumber(),(ypos).toNumber(),font,char.toNumber().toChar(),Graphics.TEXT_JUSTIFY_LEFT);
		}
    }
}