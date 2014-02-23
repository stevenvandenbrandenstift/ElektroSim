
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

public class SimulationArea : Gtk.DrawingArea {

	private ListBox list;
	private List<Component> items;
	private static int netAmount=0;


	// Constructor
	public SimulationArea (ListBox list) {
		this.list=list;
		items= new List<Component>();
		netAmount=1;


		destroy.connect (Gtk.main_quit);
		set_vexpand(true);
		set_hexpand(true);
		set_size_request(500,500);

		//set drag and drop end
		Gtk.drag_dest_set (
		                   this,                     // widget that will accept a drop
		                   DestDefaults.MOTION       // default actions for dest on DnD
		                   | DestDefaults.HIGHLIGHT,
		                   target_list,              // lists of target to support
		                   DragAction.COPY           // what to do with data after dropped
		                   );

		this.drag_drop.connect(this.on_drag_drop);
		this.drag_data_received.connect(this.on_drag_data_received);
	}

	public override bool draw (Cairo.Context cr) {
		//print("redrawing\n");
		//print("will print %u components \n",items.length ());
		foreach (Component component in items){
			component.draw_symbol(cr);
		}
		cr.restore ();
		return false;
	}

	private bool on_drag_drop (Widget widget, DragContext context, int x, int y, uint time)
	{
		//print ("%s: on_drag_drop\n", widget.name);

		// Check to see if (x, y) is a valid drop site within widget
		bool is_valid_drop_site = true;

		// If the source offers a target
		if (context.list_targets() != null) {
			// Choose the best target type
			var target_type = (Atom) context.list_targets().nth_data (Target.INT32);

			// Request the data from the source.
			Gtk.drag_get_data (
			                   widget,         // will receive 'drag_data_received' signal
			                   context,        // represents the current state of the DnD
			                   target_type,    // the target type we want
			                   time            // time stamp
			                   );
			//print("send to %s : want %i type ",widget.name,Target.INT32);
		} else {
			// No target offered by source => error
			is_valid_drop_site = false;
			print("SimulationArea: no valid dropsite \n");
		}

		return is_valid_drop_site;
	}

	/**
	 * Emitted when the data has been received from the source. It should check
	 * the SelectionData sent by the source, and do something with it. Finally
	 * it needs to finish the operation by calling Gtk.drag_finish, which will
	 * emit the "data_delete" signal if told to.
	 */
	private void on_drag_data_received (Widget widget, DragContext context,
	                                    int x, int y,
	                                    SelectionData selection_data,
	                                    uint target_type, uint time)
	{
		bool dnd_success = false;
		bool delete_selection_data = false;

		//print ("%s: on_drag_data_received\n", widget.name);

		// Deal with what we are given from source
		if ((selection_data != null) && (selection_data.get_length() >= 0)) {
			if (context.get_suggested_action() == DragAction.ASK) {
				// Ask the user to move or copy, then set the context action.
			}

			if (context.get_suggested_action() == DragAction.MOVE) {
				delete_selection_data = true;
			}

			// Check that we got the format we can use
			switch (target_type) {
				case Target.INT32:
					int* data = (int*) selection_data.get_data();
					insert_component(x,y,get_component(*data));
					dnd_success = true;
					break;
				default:
					print ("nothing good");
					break;
			}

			//print (".\n");
		}

		if (dnd_success == false) {
			print ("DnD data transfer failed!\n");
		}
		Gtk.drag_finish (context, dnd_success, delete_selection_data, time);
	}
	private Component get_component(int index){
		return (Component)list.get_row_at_index(index);
	}

	private void insert_component (int x , int y, Component component){
		Component newComponent=component.clone(component,x,y);
		netAmount=newComponent.snap(items,20,netAmount);
		items.append(newComponent);
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
		NGSpiceSimulator gen= new NGSpiceSimulator
			();
		gen.generate_file(items);
		gen.run_simulation(items);
		
	}
}


