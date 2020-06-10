using Toybox.WatchUi as Ui;
using Toybox.Math;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Application;

using Toybox.Activity as Activity;
using Toybox.ActivityMonitor as ActivityMonitor;
using Toybox.SensorHistory as SensorHistory;

class GraphComplication extends Ui.Drawable {

    hidden var position;
    hidden var position_x, position_y;
    hidden var graph_width, graph_height;
    var settings;
    
    function initialize(params) {
    	Drawable.initialize(params);
    	
    	position = params.get(:position);
    	if (position==0) {
    		// top
    		position_x = centerX;
    		position_y = 0.5*centerY;
    	} else {
    		// bottom
    		position_x = centerX;
    		position_y = 1.45*centerY;
    	}
    	
    	graph_width = 90;
    	graph_height = Math.round(0.25*centerX);
    }
	
	function get_data_type() {
		if (position==0) {
    		return Application.getApp().getProperty("compgrapht");
    	} else {
    		return Application.getApp().getProperty("compgraphb");
    	}
	}
	
	function get_data_interator(type) {
		if (type==1) {
			if ((Toybox has :SensorHistory) && (Toybox.SensorHistory has :getHeartRateHistory)) {
		        return Toybox.SensorHistory.getHeartRateHistory({});
		    }
	    } else if (type==2) {
	    	if ((Toybox has :SensorHistory) && (Toybox.SensorHistory has :getElevationHistory)) {
		        return Toybox.SensorHistory.getElevationHistory({});
		    }
	    } else if (type==3) {
	    	if ((Toybox has :SensorHistory) && (Toybox.SensorHistory has :getPressureHistory)) {
		        return Toybox.SensorHistory.getPressureHistory({});
		    }
	    } else if (type==4) {
	    	if ((Toybox has :SensorHistory) && (Toybox.SensorHistory has :getTemperatureHistory)) {
		        return Toybox.SensorHistory.getTemperatureHistory({});
		    }
	    }
	    return null;
	}

	function need_draw() {
		return get_data_type() > 0;
	}
    
    function parse_data_value(type, value) {
    	if (type==1) {
			return value;
	    } else if (type==2) {
			if (settings.elevationUnits == System.UNIT_METRIC) {
				// Metres (no conversion necessary).
				return value;
			} else {
				// Feet.
				return  value*3.28084;
			}
	    } else if (type==3) {
	    	return value/100.0;
	    } else if (type==4) {
		    if (settings.temperatureUnits == System.UNIT_STATUTE) {
				return (value * (9.0 / 5)) + 32; // Convert to Farenheit: ensure floating point division.
			} else {
				return value;
			}
	    }
    }
    
    function draw(dc) {
    	if (!need_draw()) {
    		return;
    	}
    	
    	try {
	    	settings = System.getDeviceSettings();
	    	
			var primaryColor = position == 1 ? gbar_color_1 : gbar_color_0;
	    	
	    	//Calculation
	    	var targetdatatype = get_data_type();
	        var HistoryIter = get_data_interator(targetdatatype);
	        
	        if (HistoryIter == null) {
	        	dc.setColor(gmain_color, Graphics.COLOR_TRANSPARENT);
	        	dc.drawText(position_x, position_y, smallDigitalFont, "--", Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
	        	return;
	        }
	        
	        var HistoryMin = HistoryIter.getMin();
	        var HistoryMax = HistoryIter.getMax();
	        
	        if (HistoryMin == null || HistoryMax == null) {
	        	dc.setColor(gmain_color, Graphics.COLOR_TRANSPARENT);
	        	dc.drawText(position_x, position_y, smallDigitalFont, "--", Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
	        	return;
	        }
	//         else if (HistoryMin.data == null || HistoryMax.data == null) {
	//        	dc.setColor(gmain_color, Graphics.COLOR_TRANSPARENT);
	//        	dc.drawText(position_x, position_y, smallDigitalFont, "--", Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
	//        	return;
	//        }
	        
	        var minMaxDiff = (HistoryMax - HistoryMin).toFloat();
	        
	        var xStep = graph_width;
	        var height = graph_height;
	        var HistoryPresent = 0;
	
			var HistoryNew = 0;
			var lastyStep = 0;
			var step_max = -1;
			var step_min = -1;
			
			var latest_sample = HistoryIter.next();
			if (latest_sample != null) {
	    		HistoryPresent = latest_sample.data;
	    		if (HistoryPresent != null) {
		    		// draw diagram
					var historyDifPers = (HistoryPresent - HistoryMin)/minMaxDiff;
					var yStep = historyDifPers * height;
					yStep = yStep>height?height:yStep;
					yStep = yStep<0?0:yStep;
					lastyStep = yStep;
				} else {
					lastyStep = null;
				}
	    	}
	        
			dc.setPenWidth(2);
			dc.setColor(primaryColor, Graphics.COLOR_TRANSPARENT);
			
			//Build and draw Iteration
			for(var i = 90; i > 0; i--){
				var sample = HistoryIter.next();
				
				if (sample != null) {
					HistoryNew = sample.data;
					if (HistoryNew == HistoryMax) {
						step_max = xStep;
					} else if (HistoryNew == HistoryMin) {
						step_min = xStep;
					}
					if (HistoryNew == null) {
						// ignore
					} else {
						// draw diagram
						var historyDifPers = ((HistoryNew - HistoryMin))/minMaxDiff;
						var yStep = historyDifPers * height;
						yStep = yStep>height?height:yStep;
						yStep = yStep<0?0:yStep;
						
						if (lastyStep == null) {
							// ignore
						} else {
							// draw diagram
							dc.drawLine(position_x+(xStep-graph_width/2), 
										position_y - (lastyStep-graph_height/2), 
										position_x+(xStep-graph_width/2), 
										position_y - (yStep-graph_height/2));
						}
						lastyStep = yStep;
					}
				}
				xStep--;
			}
			
			dc.setColor(gmain_color, Graphics.COLOR_TRANSPARENT);
	
			if (HistoryPresent == null) {
	        	dc.drawText(position_x, 
						position_y + (position==1?(graph_height/2 + 10):(-graph_height/2-16)), 
						smallDigitalFont, 
						"--", 
						Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
	        	return;
	        }
	        var value_label = parse_data_value(targetdatatype, HistoryPresent);
	        var labelll = value_label.format("%d");
			dc.drawText(position_x, 
						position_y + (position==1?(graph_height/2 + 10):(-graph_height/2-16)), 
						smallDigitalFont, 
						labelll, 
						Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
						
			settings = null;
		} catch(ex) { 
			// currently unkown, weird bug
			System.println(ex);
			dc.setColor(gmain_color, Graphics.COLOR_TRANSPARENT);
        	dc.drawText(position_x, position_y, smallDigitalFont, "--", Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
		}
    }
}