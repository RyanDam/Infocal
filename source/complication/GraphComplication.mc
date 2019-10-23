using Toybox.WatchUi as Ui;
using Toybox.Math;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Application;

using Toybox.Activity as Activity;
using Toybox.ActivityMonitor as ActivityMonitor;
using Toybox.SensorHistory as SensorHistory;

class GraphComplication extends Ui.Drawable {

	hidden var centerX;
    hidden var centerY;
    hidden var position;
    hidden var position_x, position_y;
    hidden var graph_width, graph_height;
    
    function initialize(params) {
    	Drawable.initialize(params);
    	var size = Application.getApp().getView().getViewSize();
        centerX = size[0]/2;
    	centerY = size[1]/2;
    	position = params.get(:position);
    	if (position==0) {
    		// top
    		position_x = centerX;
    		position_y = 0.5*centerY;
    	} else {
    		// bottom
    		position_x = centerX;
    		position_y = 1.5*centerY;
    	}
    	
    	graph_width = 90;
    	graph_height = 20;
    	
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
    
    function draw(dc) {
    	if (!need_draw()) {
    		return;
    	}
    
//    	var start = System.getTimer();
		var primaryColor = position == 1 ? gbar_color_1 : gbar_color_0;
    	
    	//Calculation
        var HistoryIter = get_data_interator(get_data_type());
        
        if (HistoryIter == null) {
        	dc.setColor(gmain_color, Graphics.COLOR_TRANSPARENT);
        	dc.drawText(position_x, position_y, smallDigitalFont, "--", Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
        	return;
        }
        
        var HistoryMin = HistoryIter.getMin();
        var HistoryMax = HistoryIter.getMax();
        var minMaxDiff = (HistoryMax - HistoryMin).toFloat();
        var xStep = graph_width;
        var height = graph_height;
        var HistoryPresent = null;
//        System.println("a");
    	HistoryPresent = HistoryIter.next().data;
        
		var HistoryNew = 0;
		
		dc.setPenWidth(2);
		dc.setColor(primaryColor, Graphics.COLOR_TRANSPARENT);
		
		var lastyStep = 0;
		var step_max = -1;
		var step_min = -1;
		
//        System.println("b");
		//Build and draw Iteration
		for(var i = 90; i > 0; i--){
			var sample = HistoryIter.next();
			
			if (sample != null) {
				HistoryNew = sample.data;
//				System.println(""+i+": "+HistoryNew);
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
//        System.println("c");
		
//		dc.setPenWidth(1);
//		dc.setColor(gsecondary_color, Graphics.COLOR_TRANSPARENT);
//		dc.drawLine(position_x-(step_max-graph_width/2), 
//					position_y - graph_height/2 - 2, 
//					position_x-(step_max-graph_width/2), 
//					position_y - graph_height/2 - 5);
//		dc.drawLine(position_x-(step_min-graph_width/2), 
//					position_y + graph_height/2 + 2, 
//					position_x-(step_min-graph_width/2), 
//					position_y + graph_height/2 + 5);
//		
//		dc.setColor(gmain_color, Graphics.COLOR_TRANSPARENT);
////		dc.drawText(position_x-(step_max-graph_width/2), 
////					position_y - graph_height/2 - 13, 
////					smallDigitalFont, 
////					HistoryMax.toString(), 
////					Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
//		dc.drawText(position_x + graph_width/2 + 15, 
//					position_y,// - graph_height/2 - 6, 
//					smallDigitalFont, 
//					HistoryMax.toString(), 
//					Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
////		dc.drawText(position_x-(step_min-graph_width/2), 
////					position_y + graph_height/2 + 2, 
////					smallDigitalFont, 
////					HistoryMin.toString(), 
////					Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
//		dc.drawText(position_x - graph_width/2 - 15, 
//					position_y,// + graph_height/2 - 6, 
//					smallDigitalFont, 
//					HistoryMin.toString(), 
//					Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);

//		dc.drawText(position_x+graph_width/2 + 2, 
//					position_y, 
//					smallDigitalFont, 
//					HistoryPresent.toString(), 
//					Graphics.TEXT_JUSTIFY_VCENTER);

		
		dc.setColor(gmain_color, Graphics.COLOR_TRANSPARENT);

		if (HistoryPresent == null) {
        	dc.drawText(position_x, 
					position_y + graph_height/2 + 10, 
					smallDigitalFont, 
					"--", 
					Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
        	return;
        }
		dc.drawText(position_x, 
					position_y + (position==1?(graph_height/2 + 10):(-graph_height/2-16)), 
					smallDigitalFont, 
					HistoryPresent.toString(), 
					Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
					
//        System.println("d");
    }
}