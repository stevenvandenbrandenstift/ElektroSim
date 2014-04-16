
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

	private ListBox list;
	public ArrayList<Component> items;
	public NGSpiceSimulator gen;


	// Constructor
	public SimulationArea (ListBox list) {
		this.list=list;
		list.set_selection_mode(SelectionMode.SINGLE);
		
		add_events (EventMask.BUTTON_PRESS_MASK);
   		
   		this.button_press_event.connect((event)=>{
   			stdout.printf ("buton pressed= x %i y %i\n",(int)event.x,(int)event.y); //debug line
   			insert_component((int)event.x,(int)event.y,(list.get_selected_row()as Component));
   			return true;
   		});
   		
		items= new ArrayList<Component>();
		gen= new NGSpiceSimulator();
		gen.data_ready.connect (insert_simulation_data);

		destroy.connect (Gtk.main_quit);
		set_vexpand(true);
		set_hexpand(true);
		set_size_request(500,500);

	}
	
	public void set_list_adjustable(){
		int i=0;
		Component component;
		component=(list.get_row_at_index(i) as Component);
		while(component!=null){
			component.set_adjustable();
			i++;
			component=(list.get_row_at_index(i) as Component);
		}	
	}
	
	public override bool draw (Cairo.Context cr) {
		//print("redrawing\n");
		//print("will print %u components \n",items.length ());
		foreach (Component component in items){
			//component.update_image();
			component.update_emoticon();
			
			int x,y;
			x=0;
			y=0;
			if(component.orientation!=ElektroSim.Orientation.NONE){
			switch (component.orientation){
		
			case ElektroSim.Orientation.RIGHT:
				x=component.connections[0].x;
				y=component.connections[0].y-component.height/2;
				break;
			case ElektroSim.Orientation.LEFT:
				x=component.connections[0].x-component.width;
				y=component.connections[0].y-component.height/2;
				break;
			case ElektroSim.Orientation.UP:
				x=component.connections[0].x-component.height/2;
				y=component.connections[0].y;
				break;
			case ElektroSim.Orientation.DOWN:
				x=component.connections[0].x-component.height/2;
				y=component.connections[0].y;
				break;
			case ElektroSim.Orientation.NONE:
				x=component.connections[0].x;
				y=component.connections[0].y-component.height/2;
				break;
			}
			if(component.image_context!=null){
			//stdout.printf ("drawing component image %s\n",component.name);
			cr.set_source_surface(component.image_context.get_target(),x,y);
			cr.paint();
			}
			if(component.emoticon_context!=null){
			//stdout.printf ("drawing emoticon image %s\n",component.name);
			cr.set_source_surface(component.emoticon_context.get_target(),x+component.width/2-35,y-component.height-35);
			cr.paint();
			}
			}
		}
		return true;
	}
	
	
	public void clear(){
		
		foreach(Component component in items){
				component.clear_counter();
		}
		Point.clear();
		items.clear(); //will not work?
		redraw_canvas();
	}
	
	private void insert_component (int x , int y, Component component){
		Component? new_component=null;
		
		//add line check for 2 points
		if(component.name=="Line"){
			foreach(Component component2 in items){
				if(component2.name=="Line"&&!(component2 as Line).second_point){
				new_component=component2;
				}
			}
		}
		if(new_component==null){
		new_component=component.clone();
		}
		new_component.snap(20,x,y);
		if(!items.contains(new_component)){
			items.add(new_component);
		}
		new_component.make_image();
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

	public void simulate(){
		gen.generate_file(items);
		foreach(Component component in items){
				stdout.printf ("component: '%s' \n", component.name); 
		}
		gen.run_simulation(items);
		redraw_canvas();
		
	}

	public void insert_simulation_data(string component_name,string data){
		foreach(Component component in items){
					if(component.name.contains(component_name)){
						component.insert_simulation_data(data);
						continue;
					}
		}
	}		
}
}

