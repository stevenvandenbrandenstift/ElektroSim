
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

	public signal void list_update (ArrayList<Component> list);
	public signal void list_print();
	public signal Component get_selected_row ();
	public ArrayList<Component> items;
	public ArrayList<Component> templates;
	public NGSpiceSimulator gen;
	
	// Constructor
	public SimulationArea () {
		add_events (EventMask.BUTTON_PRESS_MASK);
   		
   		this.button_press_event.connect((event)=>{
   			//if(get_selected_row ()==null)
   				//print ("row selection = null\n"); //debug line
   			insert_component((int)event.x,(int)event.y,get_selected_row ());
   			return true;
   		});
   		
		items= new ArrayList<Component>();
		templates= new ArrayList<Component>();
		
		gen= new NGSpiceSimulator(items);

		destroy.connect (Gtk.main_quit);
		set_vexpand(true);
		set_hexpand(true);

	}
	public void init(){
	
		if(templates.size==0){
		fill_templates();
		}
		set_list_adjustable(templates,Visual.EDITABLE);
		list_update(templates);
	}
	
	private void fill_templates(){
		Resistor resistor=new Resistor(5,1);
		templates.add(resistor);
		PowerSource power_source=new PowerSource("sin(0 1 1 0 0)");
		templates.add(power_source);
		Ground ground=new Ground();
		templates.add(ground);
		
		Line line= new Line();
		templates.add(line);

		Simulation sim=new Simulation("tran 0.02 1");
		templates.add(sim);
	}
	
	public void set_list_adjustable(ArrayList<Component> items,Visual vis){
		foreach(Component component in items){
			component.set_display_parameter(vis);
		}
	}
	
	
	
	
	public override bool draw (Cairo.Context cr) {
		
		//possible to paint the background
		cr.new_path();
		cr.set_source_rgb( 0.5, 0.5, 0.5 );
        cr.fill( );
		cr.close_path ();
		//cr.paint();
		
		cr.set_source_rgb (200, 200, 200);
		cr.set_line_width (3);
		cr.select_font_face ("Adventure", Cairo.FontSlant.NORMAL,Cairo.FontWeight.BOLD);			

		foreach (Component component in items){
			component.draw_image(cr);
		}
		
		return true;
	}
	
	
	public void clear(){
		
		foreach(Component component in items){
				component.clear_counter();
		}
		Point.clear();
		items.clear();
		redraw_canvas();
		init();
	}
	
	private void insert_component (int x , int y, Component component){
		Component? new_component=null;
		
		//add line check for 2 points
		if(component.name=="Line"){
			foreach(Component component2 in items){
				if(component2.name=="Line"&&(component2 as Line).second_point_needed){
				new_component=component2;
				}
			}
		}
		if(new_component==null){	//its no line or new line
		new_component=component.clone();
		new_component.request_simulate.connect (() => {
   					simulate();
			});
		}
		new_component.snap(20,x,y);
		if(!items.contains(new_component)){
			items.add(new_component);
		}
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
		//gen.generate_file(items);
		gen.load_netlist(items);
		gen.run_simulation();
		redraw_canvas();
		//list_print();
	}
	
	public void simulate_button(){
		//gen.generate_file(items);
		gen.load_netlist(items);
		gen.run_simulation();
		set_list_adjustable(items,Visual.SIMULATION);
		list_update (items);
		redraw_canvas();
		//list_print();	
	}
	
}
}

