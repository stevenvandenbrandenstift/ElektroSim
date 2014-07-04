
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
    
    private ArrayList<float?> values;
    private float maxValue;
    private float minValue;
    private ArrayList<float?> time;
	public signal ArrayList<float?> request_selected_component_values();
	public signal ArrayList<float?> request_time_values();
	
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
		redraw_canvas ();
	}

	public override bool draw (Cairo.Context cr) {
		
		//possible to paint the background
		cr.new_path();
		cr.set_source_rgb( 0.6, 0.6, 0.6 );
        cr.fill( );
		cr.close_path ();
		cr.paint();
		
		cr.set_source_rgb (200, 200, 200);
		cr.set_line_width (3);
		cr.select_font_face ("Adventure", Cairo.FontSlant.NORMAL,Cairo.FontWeight.BOLD);			
    		if(time!=null&&time.size!=0){
				int width = get_allocated_width ();
				int height = get_allocated_height ();
				cr.new_path();
				cr.set_source_rgb (200, 200, 200);
				cr.set_line_width (1.0);
				print("time size %i",time.size);
				float stepX=width/time[time.size-1];
				float stepY=height/(maxValue-minValue);
				print("maxValue and minValue: %f - %f\n",maxValue,minValue);
				float offset=0;
				if(minValue<0){
					offset=minValue*-1;
				}
					print("stepX and stepY: %f - %f\n",stepX,stepY);
			
				int counter=0;
				foreach (var t in time) {
				    float timepoint=t*stepX;
				    float val = stepY*(values[counter]+offset);
					print("adding point time: %f val: %f\n",timepoint,val);
				    if (counter == 0)
				        cr.move_to (0, val);
				    else
				        cr.line_to (timepoint, val);
				    counter++;
				}
				cr.close_path();
				cr.stroke ();
			}

		return true;
	}
	
	public void set_timepoints(ArrayList<float?> timepoints){
        time=timepoints;
    }
    
    public void set_values(ArrayList<float?> values){
        this.values=values;
        maxValue=float.MIN;
        minValue=float.MAX;
        foreach (float p in values) {
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
