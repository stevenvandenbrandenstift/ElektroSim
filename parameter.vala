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
	public int val{get;set;default=0;}
	public bool editable{get;set;default=false;}
	public string name{get;set;default="";}
	
	private Label label{get;set;}
	private Entry entry{get;set;}

	public Parameter(string name , int val){
		this.name=name;
		this.val=val;
		set_can_focus(false);	
		
		label= new Label.with_mnemonic (name+":");
		label.set_can_focus(false);
		label.selectable=false;
		
		entry= new Entry();
		entry.set_text (val.to_string());
		entry.set_width_chars(5);
		
		add(label);
		add(entry);	
	}		
	public int get_input(){
		return int.parse(entry.get_text ());
	}
	
	public void set_value(int temp){
		entry.set_text (temp.to_string());
		val=temp;
	}
	}
}
