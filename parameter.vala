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

public enum Visual{
		ALL,EDITABLE,EDITABLE_SLIDER,NO_OPTIONAL;
}
public enum Group{
	PARAMETER,ADJUSTABLE,OPTIONAL_PARAMETER;
}

public class Parameter : Box{

	public signal void val_changed();
	public static ArrayList<Parameter> parameters=new ArrayList<Parameter>(); // could be used for a new Component generator
	public int val{get;set;default=0;}
	public string name{get;set;default="";}
	public Group group{get;set;}
	public Visual visual;
	private bool updating;
	
	private Label label{get;set;}
	private Entry entry{get;set;}
	private Scale scale {get;set;}

	public Parameter(string name , int val, Group group){
		this.name=name;
		this.val=val;
		updating=false;
		//set_can_focus(false);	
		set_size_request(200,-1);
		label= new Label.with_mnemonic (name+":");
		label.set_can_focus(false);
		label.selectable=false;
		
		entry= new Entry();
		entry.set_text (val.to_string());
		entry.set_width_chars(5);
		entry.set_hexpand(true);
		if(group==Group.PARAMETER||group==Group.PARAMETER){
			 entry.set_overwrite_mode(false);
		}
		entry.key_release_event.connect (() => {
				val=int.parse(entry.get_text() );
				//val_changed();
				//print("%s changed too %d\n",name,val);
				return false;
			});
		
		if(group==Group.ADJUSTABLE){
			scale = new Gtk.Scale.with_range (Gtk.Orientation.HORIZONTAL, 0, 1000, 1);
			scale.set_has_origin (false);
			scale.set_value(val);
			scale.set_hexpand(true);
			
			scale.value_changed.connect (() => {
				if(!updating){
				updating=true;
				val=(int)scale.get_value ();
				val_changed();
				updating=false;
				}
				//print("%s  changed too %d\n",name,val);
			});
		}
		
		add(label);
		add(entry);
		this.group=group;	
		}
	
	public void set_visual(Visual vis){
		//remove(entry);
		remove(scale);
		switch(vis){
		
		case Visual.ALL:
			set_no_show_all(false);
			break;
		
		case  Visual.EDITABLE:
			if(group==Group.ADJUSTABLE)
				set_no_show_all(false);
			else
				set_no_show_all(true);
			break;
			
		case  Visual.NO_OPTIONAL:
			if(group!=Group.OPTIONAL_PARAMETER)
				set_no_show_all(false);
			else
				set_no_show_all(true);
			break;
		
		case  Visual.EDITABLE_SLIDER:
			if(group!=Group.OPTIONAL_PARAMETER){
				set_no_show_all(false);
				if(group==Group.ADJUSTABLE){
					remove(entry);
					add(scale);
				}
			}
			else
				set_no_show_all(true);
			break;
		}
		visual=vis;
	}
	public void set_value(int temp){
		entry.set_text (temp.to_string());
		if(scale!=null){
		scale.set_value(temp);
		}
		val=temp;
	}
	

	
	}
}
