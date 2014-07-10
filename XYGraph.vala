
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
    
	public enum Location{
		NONE,UP,LEFT,DOWN,RIGHT;
	}

    private ArrayList<double?> values;
    private double maxValue;
    private double minValue;
    private ArrayList<double?> time;
	private string name;
	public signal ArrayList<double?> request_selected_component_values();
	public signal ArrayList<double?> request_time_values();
	
	// Constructor
	public XYGraph () {
		add_events (EventMask.BUTTON_PRESS_MASK);
   		
   		this.button_press_event.connect(()=>{
   			set_values(request_selected_component_values());
			set_timepoints(request_time_values());
			redraw_canvas();
			return true;
   		});
   		
		set_vexpand(true);
		set_hexpand(true);
		name="select a component and click graph";
		redraw_canvas ();
	}

	public void draw_axes(Cairo.Context cr,int width,int height,int border,double offset){
			
			cr.set_line_width (3);
			cr.set_source_rgb (0, 0, 0);
			//x-axis
			cr.move_to (-border/2, 0);
			cr.line_to (width+border/2,0);
			cr.stroke ();
			//y-axis
			cr.move_to (0, -offset-border/2);
			cr.line_to (0,height-offset+border/2);
			cr.stroke ();
			cr.close_path();
	}

	public override bool draw (Cairo.Context cr) {
		
		//possible to paint the background
		cr.new_path();
		cr.set_source_rgb( 0.6, 0.6, 0.6 );
        cr.fill( );
		cr.close_path ();
		cr.paint();
		
		cr.set_source_rgb (200, 200, 200);
		cr.set_line_width (5);
		cr.select_font_face ("Adventure", Cairo.FontSlant.NORMAL,Cairo.FontWeight.BOLD);
		
		
		int border=50;
		int width = get_allocated_width ();
		
		draw_label(cr,25,name,width/2,border/2,Location.LEFT);
		

    		if(time!=null&&time.size!=0&&values!=null&&values.size>=time.size){
				int height = get_allocated_height ();
				int width_graph= width-2*border;
				int height_graph= height-2*border;
				
				double scaledOffset=minValue;

				double offset=height_graph*((-minValue)/(maxValue-minValue));
				print("offset: %f - scaledOffset: %f \n\n",offset,scaledOffset);
				cr.translate(0,height); // go to 0 0 for graph
				cr.scale(1,-1);			//set y axis from bottom up
				cr.translate(border,border+offset);	//add border
				draw_axes(cr,width_graph,height_graph,border,offset);

				double xScale=(width_graph)/(time[time.size-1]);
				double yScale=height_graph/((maxValue-minValue));
				//cr.scale(xScale,yScale) ;	//scaling
				print("xScale: %f - yScale: %f \n\n",xScale,yScale);
				

				cr.set_line_width (1.0);
				cr.set_source_rgb (300, 300, 300);
				int counter=0;
				foreach (var t in time) {
					
				    if (counter == 0){
						//draw_label(cr,15,values[counter].to_string(),0,values[counter]*yScale,Location.LEFT);
						cr.move_to (t*xScale, values[counter]*yScale);
				    }else {
				        cr.line_to (t*xScale, values[counter]*yScale);
						/*if(values[counter]==maxValue||values[counter]==minValue){
							draw_label(cr,15,values[counter].to_string(),0,values[counter]*yScale,Location.LEFT);*/
					}
				    counter++;
					print("added point time: %f val: %f x: %f  y: %f\n",t,values[counter],t*xScale,values[counter]*yScale);
				}
				cr.stroke ();
			}

		return true;
	}

	public void draw_label(Cairo.Context cr,int fontsize,string label,double x,double y, Location location){
			cr.set_font_size (fontsize);
			if(location==Location.LEFT&&x==0)
			cr.move_to (x-10*label.length,y+fontsize);
			else if(location==Location.LEFT)
			cr.move_to (x-10*label.length,y);
			cr.text_path (label);
			cr.fill( );
	}
	
	public void set_name(string name){
			this.name=name;
	}

	public void set_timepoints(ArrayList<double?> timepoints){
        time=timepoints;
    }
    
    public void set_values(ArrayList<double?> values){
        this.values=values;
        maxValue=double.MIN;
        minValue=0; //always keep relative to x-axis
        foreach (double p in values) {
            if(p>maxValue)
              maxValue=p;
            if(p<minValue)
              minValue=p;
        }
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
