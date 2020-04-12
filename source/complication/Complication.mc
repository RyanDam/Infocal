using Toybox.WatchUi as Ui;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Activity;
using Toybox.ActivityMonitor;
using Toybox.Application;

class Complication extends ArcTextComplication {

	var dt_field;
	var field_type;
	
	function initialize(params) {
		ArcTextComplication.initialize(params);
		field_type = params.get(:field_type);
		dt_field = buildFieldObject(field_type);
	}
	
	function get_text() {
		var curval = dt_field.cur_val();
		var pre_label = dt_field.cur_label(curval);
		return pre_label;
	}
	
	function getSettingDataKey() {
		return Application.getApp().getProperty("comp"+angle+"h");
	}

	function need_draw() {
		var digital_style = Application.getApp().getProperty("digital_style");
		if (digital_style == 1 || digital_style == 3) {
			// small digital
			return dt_field.need_draw();
		}
		if (Application.getApp().getProperty("left_digital_info")) {
			var can_draw = !(angle==10 && !(Application.getApp().getProperty("use_analog")));
			return dt_field.need_draw() && can_draw;
		} else {
			var can_draw = !(angle==2 && !(Application.getApp().getProperty("use_analog")));
			return dt_field.need_draw() && can_draw;
		}
	}

	function draw(dc) {
		field_type = getSettingDataKey();
		if (field_type != dt_field.field_id()) {
			dt_field = buildFieldObject(field_type);
		}
    
//    	System.println(field_type);
    
		
		if (need_draw()) {
			ArcTextComplication.draw(dc);
		}
	}

}