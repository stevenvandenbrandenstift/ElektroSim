/* -*- Mode: vala; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/*
 * Parameter.vala
 * Copyright (C) 2014 Steven Vanden Branden <StevenVandenBrandenStift@gmail.com>
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
using Gee;

namespace ElektroSim{

public class Parameter : Box{

	
	public static ArrayList<Parameter> parameters=new ArrayList<Parameter>(); // could be used for a new Component generator
	public double val{get;set;}
	public ArrayList<double?> values{get;set;}
	private ArrayList<Widget> edit{get;set;}
	private ArrayList<Widget> simulation{get;set;}
	public string val_string{get;set;}
	public string name{get;set;default="";}
	public bool invalidate_values{get;set;}

	public signal void updated();
	public signal void edited();
	

	public Parameter(string name , double val, string val_string){
		values=new ArrayList<double?>();
		edit=new ArrayList<Widget>();
		simulation=new ArrayList<Widget>();
		invalidate_values=false;

		this.name=name;
		this.val_string=val_string;
		this.val=val;
		//set_can_focus(false);	
		set_size_request(-1,-1);
		}
	
	public void set_mode(Mode mode){

		switch(mode){
		
		case Mode.EDIT:
				fill_box(edit);
			break;
		
		case  Mode.SIMULATION:
				fill_box(simulation);
			break;
		}
	}

	private void clear_box(){
		GLib.List<weak Widget> widgets =this.get_children();
			foreach(Widget widget in widgets){
					this.remove(widget);
			}
	}

	private void fill_box(ArrayList<Widget> widgets){
		clear_box();
		foreach(Widget widget in widgets){
			this.add(widget);
		}
	}

	private void set_widgets_value(){
			GLib.List<weak Widget> widgets =this.get_children();
			foreach(Widget widget in widgets){
				if(widget is Label){
					if(!(widget as Label).get_text().contains(name))
						(widget as Label).set_label(val.to_string());
				}else if(widget is Entry)
					(widget as Entry).set_text(val.to_string());
				else if(widget is Scale)
					(widget as Scale).set_value(val);
				
			}
	}

	public void set_simulation_array(ArrayList<Widget> simulation_array){
			simulation=simulation_array;
	}

	public void set_edit_array(ArrayList<Widget> edit_array){
			edit=edit_array;
	}
	

	public void set_value(double temp){
		val=temp;
		set_widgets_value();
		updated();
	}
	
	public void add_value(double temp){
			if(invalidate_values){
				values=new ArrayList<double?>();
				invalidate_values=false;
			}
			values.add(temp);
			//set_widgets_value();
			//updated();
	}

	public ArrayList<Widget> arraylist_label_slider(){
		ArrayList<Widget> widgets= new ArrayList<Widget>();
		widgets.add(make_label());
		widgets.add(make_scale());
		return widgets;
	}

	public ArrayList<Widget> arraylist_label_label(){
		ArrayList<Widget> widgets= new ArrayList<Widget>();
		widgets.add(make_label());
		widgets.add(make_label_value());
		return widgets;
	}

	public ArrayList<Widget> arraylist_label_text(){
		ArrayList<Widget> widgets= new ArrayList<Widget>();
		widgets.add(make_label());
		widgets.add(make_entry());
		return widgets;
	}

	private Scale make_scale(){
		Scale scale=new Scale.with_range (Gtk.Orientation.HORIZONTAL, 0, 100, 1);
		scale.set_has_origin (false);
		scale.set_hexpand(true);
		scale.set_value(val);
		scale.value_changed.connect (()=>{
				val=scale.get_value();
				edited();
		});
		return scale;
	}
	private Entry make_entry(){
		Entry entry=new Entry();
		entry.set_width_chars(20);
		entry.set_hexpand(true);
		entry.set_text(val.to_string());
		entry.key_release_event.connect (()=>{
				val=double.parse(entry.get_text());
				edited();
				return true;
		});
		return entry;
/*
values=new ArrayList<float?>();
						print(" changed string from %s to %s \n",val_string,entry.get_text());
						}
				}else{
					set_value(double.parse(entry.get_text()));
				}
				return false;
			});
*/
	}

	private Label make_label(){
		Label label= new Label (name);
		label.set_can_focus(false);
		label.width_chars=10;
		label.selectable=false;
		return label;
	}

	private Label make_label_value(){
		Label label= new Label (val.to_string());
		label.set_can_focus(false);
		label.width_chars=15;
		label.selectable=false;
		return label;
	}
	
	}
}
