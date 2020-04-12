using Toybox.WatchUi as Ui;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Activity;
using Toybox.ActivityMonitor;
using Toybox.Application;

class BarDataComplication extends BarComplication {

	var dt_field;
	var field_type;
	
	function initialize(params) {
		BarComplication.initialize(params);
		field_type = params.get(:field_type);
		dt_field = buildFieldObject(field_type);
	}
	
	function min_val() {
    	var curval = dt_field.min_val();
		return curval;
    }
    
    function max_val() {
    	var curval = dt_field.max_val();
		return curval;
    }
    
    function cur_val() {
    	var curval = dt_field.cur_val();
		return curval;
    }
    
    function get_title() {
    	var curval = dt_field.cur_val();
		var pre_label = dt_field.cur_label(curval);
		return pre_label;
    }

	function need_draw() {
		return dt_field.need_draw();
	}
	
	function bar_data() {
		return dt_field.bar_data();
	}
	
	function get_weather_icon() {
    	return dt_field.cur_icon();
    }
	
	function getSettingDataKey() {
		if (position==0) {
			// upper
        	return Application.getApp().getProperty("compbart");
        } else if (position==1) {
        	// lower
        	return Application.getApp().getProperty("compbarb");
        }
	}

	function draw(dc) {
		field_type = getSettingDataKey();
		if (field_type != dt_field.field_id()) {
			dt_field = buildFieldObject(field_type);
		}
		
		if (need_draw()) {
			BarComplication.draw(dc);
		}
	}

}