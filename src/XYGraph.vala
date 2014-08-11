
/* -*- Mode: vala; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/*
 * Graph.vala
 * Copyright (C) 2014 Steven Vanden Branden <Stevenvandenbrandenstift@gmail.com>
	 *
 * ElektroSim is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the
 * Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
	 * 
 * ElektroSim is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 * See the GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License along
 * with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
using Gtk;
using Gdk;
using Gee;

namespace ElektroSim{

public class XYGraph : Gtk.DrawingArea {
    

    private ArrayList<double?> values;
    private double maxValue;
    private double minValue;
    private ArrayList<double?> time;
    private string name;
    private double rangeX;
    private double rangeY;
    private double offset;
    private int height;
    private int width;
    
	public signal ArrayList<double?> request_selected_component_values(bool next);
	public signal ArrayList<double?> request_time_values();
	
	// Constructor
	public XYGraph () {
		add_events (EventMask.BUTTON_PRESS_MASK);
   		
   		this.button_press_event.connect(()=>{
   			set_values(request_selected_component_values(true));
			set_timepoints(request_time_values());
			redraw_canvas();
			return true;
   		});
   		
		set_vexpand(true);
		set_hexpand(true);
		name="select a component and click here";
		redraw_canvas ();
	}

	private void draw_axes(Cairo.Context cr,double border,double offset){
			
			//x-axis
			cr.save();
			cr.set_line_width (3);
			cr.set_source_rgb (0, 0,0);
			cr.move_to (border, height-border+offset);
			cr.line_to (width-border/2,height-border+offset);
			cr.stroke ();
			//y-axis
			cr.move_to (border+border/2,border/2);
			cr.line_to (border+border/2,height-border/2);
			cr.stroke ();
			cr.restore();
	}
	

	public void redraw(){
			ArrayList<double?> temp=request_selected_component_values(false);
			if(temp!=null)
			set_values(temp);
			set_timepoints(request_time_values());
			redraw_canvas();
	}
	public override bool draw (Cairo.Context cr) {
		
		//possible to paint the background
		
		cr.set_source_rgb( 0.6, 0.6, 0.6 );
		cr.fill();
                cr.paint( );
		
		cr.set_source_rgb (200, 200, 200);
		cr.set_line_width (5);
		cr.select_font_face ("Adventure", Cairo.FontSlant.NORMAL,Cairo.FontWeight.BOLD);
		
		
		int border=50;
		width = get_allocated_width ();
		height = get_allocated_height ();
		int width_graph= width-2*border;
		int height_graph= height-2*border;
				
        draw_label(cr,25,name,width/2-name.length,border/2);
		
		
    		if(time!=null&&values!=null&&values.size>=time.size){
    		               
				double scaleX=width_graph/rangeX;
				double scaleY=height_graph/rangeY;

				debug("offset: "+offset.to_string()+" scale: x: "+scaleX.to_string()+" y: "+scaleY.to_string());
				
				cr.set_source_rgb (22, 22,22);

				draw_axes(cr,border,offset*scaleY);
				 cr.translate(border+border/2,height-border+offset*scaleY);
				//cr.scale(scaleX,scaleY); //problem: scales the lines also!
				//does not scale 
                debug("minValue "+minValue.to_string()+" maxValue "+maxValue.to_string());
				draw_label(cr,10,"%f".printf(minValue),-50,-minValue*scaleY);
				draw_label(cr,10,"%f".printf(maxValue),-50,-maxValue*scaleY);
                cr.set_source_rgb (22, 22,22);
				cr.set_line_width (2);
				int counter=0;
				foreach (var t in time) {
				 if (counter == 0){
						cr.move_to (t*scaleX, -1*values[counter]*scaleY);
				    }else 
				        cr.line_to (t*scaleX,-1*values[counter]*scaleY);

				   counter++;
					//print("added point time: %f val: %f x: %f  y: %f\n",t,values[counter],t*xScale,values[counter]*yScale);
				    
				 
			    }
                cr.stroke();
            }

		return true;
	}

	private void draw_label(Cairo.Context cr,int fontsize,string label,double x,double y){
	        cr.save();
			cr.set_font_size (fontsize);
			cr.move_to (x-label.length,y);
			cr.text_path (label);
			cr.fill();
			cr.restore();
	}
	
	public void set_name(string name){
			this.name=name;
			debug("setname: "+name);
	}


     public void set_timepoints(ArrayList<double?> timepoints){
	if(timepoints!=null&&timepoints.size!=0){
        time=timepoints;
        rangeX=timepoints[timepoints.size-1];
        }
     }
    
    public void set_values(ArrayList<double?> values){
        if(values!=null){
        this.values=values;
        offset=0;
        maxValue=double.MIN;
        minValue=0; //always keep relative to x-axis
		
		    foreach (double p in values) {
		        if(p>maxValue)
		          maxValue=p;
		        if(p<minValue)
		          minValue=p;
		    }
		
        if(minValue<=0&&maxValue>=0){
            rangeY=maxValue-minValue;
            offset=minValue;
        }
        else if(minValue<=0&&maxValue<0){
            rangeY=-minValue;
            offset=rangeY;
        }
        }else
            debug("ERROR values=null");
    }
    
	public void clear(){
        time.clear();
		values.clear();
		redraw_canvas();
	}

	private void redraw_canvas () {
		Gdk.Window window = get_window();
		if (null == window) {
			print("no window");
			return;
		}
		var region = window.get_clip_region ();
		// redraw the cairo canvas completely by exposing it
		window.invalidate_region (region, true);
		window.process_updates (true);
	}		
	
}
}