/* -*- Mode: vala; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/*
 * simulation.vala
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
using Gee;
using Gtk;

namespace ElektroSim{



public class Simulation : Component {
	

	private ArrayList<Parameter> optionsAdded;

	public enum Type{
		OP,TRAN,AC,DC;
	}

	public enum AcVariation{
		DECADE,OCTAVE,LINEAIR;
	}

	public Simulation (int option) {
			base("Simulation");
			clear_parameters();
			optionsAdded=new ArrayList<Parameter>();
			add_parameter("time",0,Parameter.WidgetStyle.LABEL);
		
			ArrayList<string> temp=new ArrayList<string>();
			temp.add("op");
			temp.add("dc");
			temp.add("tran");
			temp.add("ac");
			Parameter type=add_parameter("type",option,Parameter.WidgetStyle.OPTIONS,Parameter.WidgetStyle.OPTIONS,temp);
		
			type.optionsMethod=change_type;
				
			change_type(option);

			this.width=100;
			this.height=50;
			this.componentType=Component.ComponentType.SIMULATION;
	}
	
	public override void draw_image(Cairo.Context cr){
	
	}
	
	
	public void reset_options(){
		foreach(Parameter par in optionsAdded){
			grid.remove((par as Widget));
			parameters.remove(par);
		}
		optionsAdded=new ArrayList<Parameter>();
	}

	public void change_type(int option){
		print("change to type '%i'\n",option);
		reset_options();
		get_parameter("type").val=option;
		switch(option){
			case(Type.TRAN):
				Parameter step=add_parameter("step",0.02,Parameter.WidgetStyle.ENTRY,Parameter.WidgetStyle.ENTRY);
				Parameter stop=add_parameter("stop",1,Parameter.WidgetStyle.ENTRY,Parameter.WidgetStyle.ENTRY);
				Parameter start=add_parameter("start",1,Parameter.WidgetStyle.ENTRY,Parameter.WidgetStyle.ENTRY);
				optionsAdded.add(step);
				optionsAdded.add(stop);
				optionsAdded.add(start);
				break;
			case(Type.OP):
				break;
			case(Type.DC):
				break;
			case(Type.AC):
				ArrayList<string> variations=new ArrayList<string>();
				variations.add("decade");
				variations.add("octave");
				variations.add("lineair");
				Parameter variation=add_parameter("variation",0,Parameter.WidgetStyle.OPTIONS,Parameter.WidgetStyle.OPTIONS,variations);
				Parameter points=add_parameter("points",100,Parameter.WidgetStyle.ENTRY,Parameter.WidgetStyle.ENTRY);
				Parameter start=add_parameter("start frequency",1,Parameter.WidgetStyle.ENTRY,Parameter.WidgetStyle.ENTRY);
				Parameter stop=add_parameter("stop frequency",100,Parameter.WidgetStyle.ENTRY,Parameter.WidgetStyle.ENTRY);
				optionsAdded.add(variation);
				optionsAdded.add(points);
				optionsAdded.add(start);
				optionsAdded.add(stop);
				break;
		}
		set_mode(ComponentList.Mode.EDIT);
		show_all();
	}
	public override Component clone(){
			Simulation newc=new Simulation((int)get_parameter("type").val);
				foreach(Parameter par in parameters){
					newc.get_parameter(par.name).val=par.val;
				}
			newc.componentType=Component.ComponentType.SIMULATION;
			return newc;
	}
	
	public override void snap(int range,int x ,int y){
	}

	public override string get_netlist_line(){
		string line;
		line="";
		switch((int)get_parameter("type").val){
			case(Type.TRAN):
				line+="tran "+get_parameter("step").val.to_string()+" "+get_parameter("stop").val.to_string()+" "+get_parameter("start").val.to_string();
				break;
			case(Type.OP):
				line+="op";
				break;
			case(Type.DC):
				line+="dc";
				break;
			case(Type.AC):
				line+="ac ";
					switch((int)get_parameter("variation").val){
							case(AcVariation.DECADE):
									line+="dec ";
									break;
							case(AcVariation.OCTAVE):
									line+="oct ";
									break;
							case(AcVariation.LINEAIR):
									line+="lin ";
									break;
					}
				line+=get_parameter("points").val.to_string()+" "+get_parameter("start frequency").val.to_string()+" "+get_parameter("stop frequency").val.to_string();
				break;
		}
		return line;
	}
}
}

