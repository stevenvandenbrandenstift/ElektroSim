
/* -*- Mode: vala; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/*
 * simulationArea.vala
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

public class SimulationArea : Gtk.DrawingArea {

	public signal ArrayList<Component> request_components(ElektroSim.ComponentType type2);
	public signal void new_component(Component comp);
	public signal Component request_selected_component();
	public signal void request_simulation();
	
	
	// Constructor
	public SimulationArea () {
		add_events (EventMask.BUTTON_PRESS_MASK);
   		
   		this.button_press_event.connect((event)=>{
   			//if(get_selected_row ()==null)
   				//print ("row selection = null\n"); //debug line
   			insert_component((int)event.x,(int)event.y,request_selected_component ());
   			return true;
   		});
  

		destroy.connect (Gtk.main_quit);
		set_vexpand(true);
		set_hexpand(true);

	}
	
	public override bool draw (Cairo.Context cr) {
		
		//possible to paint the background
		cr.new_path();
		cr.set_source_rgb( 0.5, 0.5, 0.5 );
        cr.fill( );
		cr.close_path ();
		cr.paint();
		
		cr.set_source_rgb (200, 200, 200);
		cr.set_line_width (3);
		cr.select_font_face ("Adventure", Cairo.FontSlant.NORMAL,Cairo.FontWeight.BOLD);			

		foreach (Component component in request_components(ElektroSim.ComponentType.COMPONENT)){
			component.draw_image(cr);
		}
		
		return true;
	}	
	private void insert_component (int x , int y, Component component){
		Component? newComponent=null;
		
		//add line check for 2 points
		if(component.name=="Line"){
			foreach(Component component2 in request_components(ElektroSim.ComponentType.COMPONENT)){
				if(component2.name=="Line"&&(component2 as Line).second_point_needed){
				newComponent=component2;
				}
			}
		}
		if(newComponent==null){	//its no line or new line
		newComponent=component.clone();
		newComponent.request_simulate.connect (() => {
   					simulate();
			});
		}
		newComponent.snap(20,x,y);
		newComponent.componentType=ElektroSim.ComponentType.COMPONENT;
		new_component(newComponent);
		redraw_canvas();
	}

	public void redraw_canvas () {
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

	public void simulate(){
		//gen.generate_file(items);
		request_simulation();
		redraw_canvas();
		//list_print();
	}
}
}

