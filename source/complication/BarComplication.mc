using Toybox.WatchUi as Ui;
using Toybox.Math;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Application;

class BarComplication extends Ui.Drawable {

    hidden var position, position_y_draw, position_y_draw_bonus;
    hidden var font, fontInfo, arrFont, arrInfo;
    hidden var textFont;
    hidden var weatherFont;
    
    function initialize(params) {
    	Drawable.initialize(params);
    	position = params.get(:position);
    	if (position == 0) {
    		// up
    		if (centerX == 120) {
	    		position_y_draw = 52;//centerY - 36 - 18 - 14; // font height 14
	    		position_y_draw_bonus = -15;
    		} else if (centerX == 130) {
	    		position_y_draw = 58;//centerY - 36 - 18 - 14 - 4; // font height 14
	    		position_y_draw_bonus = -20;
    		} else if (centerX == 140) {
	    		position_y_draw = 64;//centerY - 36 - 18 - 14 - 8; // font height 14
	    		position_y_draw_bonus = -20;
    		} else {
	    		position_y_draw = 46;//centerY - 36 - 18 - 14 + 5; // font height 14
	    		position_y_draw_bonus = -15;
    		}
    	} else {
    		// down
    		if (centerX == 120) {
	    		position_y_draw = 156;//centerY + 36;
	    		position_y_draw_bonus = 31;
    		} else if (centerX == 130) {
	    		position_y_draw = 170;//centerY + 36 + 4;
	    		position_y_draw_bonus = 35;
    		} else if (centerX == 140) {
	    		position_y_draw = 184;//centerY + 36 + 8;
	    		position_y_draw_bonus = 35;
    		} else {
	    		position_y_draw = 140;//centerY + 36 - 5;
	    		position_y_draw_bonus = 31;
    		}
    	}
    }
	
	function load_font() {
		if (position == 0) {
    		// up
    		font = Ui.loadResource(Rez.Fonts.cur_up);
    		arrFont = Ui.loadResource(Rez.Fonts.arr_up);
    		fontInfo = Ui.loadResource(Rez.JsonData.bar_font_top);
    		arrInfo = Ui.loadResource(Rez.JsonData.bar_pos_top);
		} else {
			// down
    		font = Ui.loadResource(Rez.Fonts.cur_bo);
    		arrFont = Ui.loadResource(Rez.Fonts.arr_bo);
    		fontInfo = Ui.loadResource(Rez.JsonData.bar_font_bottom);
    		arrInfo = Ui.loadResource(Rez.JsonData.bar_pos_bottom);
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
    
    function get_weather_icon() {
    	return null;
    }

	function need_draw() {
		return true;
	}
    
    function bar_data() {
		return false;
	}
    
    function draw(dc) {
////    	var start = System.getTimer();
		var is_bar_data = bar_data();
		if (is_bar_data) {
			load_font();
		}
		
		if (field_type == FIELD_TYPE_WEATHER) {
    		weatherFont = Ui.loadResource(Rez.Fonts.weather);
    	} else {
    		weatherFont = null;
    	}
//		
		var primaryColor = position == 1 ? gbar_color_1 : gbar_color_0;
    	
    	var bonus_padding = 0;
    	
    	if (is_bar_data) {
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
    	} else if (field_type == FIELD_TYPE_WEATHER) {
    		var icon = get_weather_icon();
    		if (icon != null) {
	    		dc.setColor(gmain_color, Graphics.COLOR_TRANSPARENT);
		    	dc.drawText(centerX, position_y_draw + position_y_draw_bonus, weatherFont, icon, Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
    		}
    	} else {
    		bonus_padding = position == 0 ? -7 : 5;
    	}
    	
    	var title = get_title();
    	if (title == null) {
    		title = "--";
    	}
    	
    	title = title.toUpper();
    	dc.setColor(gmain_color, Graphics.COLOR_TRANSPARENT);
    	dc.drawText(centerX, position_y_draw+bonus_padding, smallDigitalFont, title, Graphics.TEXT_JUSTIFY_CENTER);

		font = null;
		fontInfo = null;
		arrFont = null;
		arrInfo = null;
		weatherFont = null;
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