/* -*- Mode: vala; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/*
 * ground.vala
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
using Gee;
namespace ElektroSim{
	
public class PowerSource : Component {

	public static int counter;
	private ArrayList<Parameter> optionsAdded;
	

	public enum Type{
		DC,SINUS,PULSE,EXPO,PWLINEAR,SFFM,AM,TRANSNOISE,RANDOM;
	}

	public PowerSource (int option) {
			base("PowerSource");
			this.width=100;
			this.height=50;
			ArrayList<string> temp=new ArrayList<string>();
			temp.add("dc");
			temp.add("sin");
			temp.add("pulse");
			Parameter type=add_parameter("type",option,Parameter.WidgetStyle.OPTIONS,Parameter.WidgetStyle.OPTIONS,temp);
			type.optionsMethod=change_type;
			change_type(option);
	}
	
		public override void draw_image(Cairo.Context cr){
		
		int p1_x = connections[0].x;
		int p1_y = connections[0].y;

		cr.new_path ();
		cr.move_to (p1_x, p1_y);
		if(orientation==Component.Orientation.RIGHT){
		cr.rel_line_to (width,0);
		}else if(orientation==Component.Orientation.LEFT){
		cr.rel_line_to (-width,0);
		}else if(orientation==Component.Orientation.UP){
		cr.rel_line_to (0,-width);
		}else{
		cr.rel_line_to (0,width);
		}
		cr.close_path ();
		cr.stroke ();
		
		cr.new_path ();
		cr.set_font_size (height*0.4);
		
		if(orientation==Component.Orientation.RIGHT){
		cr.move_to (p1_x+width*0.65,p1_y-5);
		}else if(orientation==Component.Orientation.LEFT){
		cr.move_to (p1_x-width,p1_y-5);
		}else if(orientation==Component.Orientation.UP){
		cr.move_to (p1_x+5,p1_y-width*0.8);
		}else if(orientation==Component.Orientation.DOWN){
		cr.move_to (p1_x+5,p1_y+width*0.9);
		}
		
		cr.text_path (name);
		cr.fill();
		cr.close_path ();
	
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
			case(Type.DC):
				Parameter voltage=add_parameter("voltage",1,Parameter.WidgetStyle.ENTRY,Parameter.WidgetStyle.SLIDER);
				optionsAdded.add(voltage);
				break;
			case(Type.SINUS):
				Parameter step=add_parameter("offset",0,Parameter.WidgetStyle.ENTRY,Parameter.WidgetStyle.ENTRY);
				Parameter amplitude=add_parameter("amplitude",1,Parameter.WidgetStyle.ENTRY,Parameter.WidgetStyle.ENTRY);
				Parameter frequency=add_parameter("frequency",10,Parameter.WidgetStyle.ENTRY,Parameter.WidgetStyle.ENTRY);
				Parameter delay=add_parameter("delay",0,Parameter.WidgetStyle.ENTRY,Parameter.WidgetStyle.ENTRY);
				Parameter damping=add_parameter("damping",0,Parameter.WidgetStyle.ENTRY,Parameter.WidgetStyle.ENTRY);
				optionsAdded.add(step);
				optionsAdded.add(amplitude);
				optionsAdded.add(frequency);
				optionsAdded.add(delay);
				optionsAdded.add(damping);
				break;
			case(Type.PULSE):
				Parameter initial=add_parameter("initial value",-1,Parameter.WidgetStyle.ENTRY,Parameter.WidgetStyle.ENTRY);
				Parameter pulsed=add_parameter("pulsed value",1,Parameter.WidgetStyle.ENTRY,Parameter.WidgetStyle.ENTRY);
				Parameter delay=add_parameter("delay time",double.parse("2e-9"),Parameter.WidgetStyle.ENTRY,Parameter.WidgetStyle.ENTRY);
				Parameter rise=add_parameter("rise time",double.parse("2e-9"),Parameter.WidgetStyle.ENTRY,Parameter.WidgetStyle.ENTRY);
				Parameter fall=add_parameter("fall time",double.parse("2e-9"),Parameter.WidgetStyle.ENTRY,Parameter.WidgetStyle.ENTRY);
				Parameter pulse=add_parameter("pulse width",double.parse("50e-9"),Parameter.WidgetStyle.ENTRY,Parameter.WidgetStyle.ENTRY);
				Parameter period=add_parameter("period",double.parse("100e-9"),Parameter.WidgetStyle.ENTRY,Parameter.WidgetStyle.ENTRY);
				optionsAdded.add(initial);
				optionsAdded.add(pulsed);
				optionsAdded.add(delay);
				optionsAdded.add(rise);
				optionsAdded.add(fall);
				optionsAdded.add(pulse);
				optionsAdded.add(period);
				break;
			
		}
		set_mode(ComponentList.Mode.EDIT);
		show_all();
	}
	
	public override void clear_counter(){
	counter=0;
	}
	
	public override Component clone(){
			PowerSource newc=new PowerSource((int)get_parameter("type").val);
			counter++;
			newc.set_name("v"+counter.to_string());
			newc.componentType=Component.ComponentType.COMPONENT;


			foreach(Parameter par in parameters){
				newc.get_parameter(par.name).val=par.val;
						}
			return newc;
	}

	public override void snap(int range,int x, int y){
		Point point;
		point=new Point(x,y);
		point=point.point_nearby(range);
		orientation=point.connect_component(this);
		connections.add(point);
	}

	public override string get_netlist_line(){
		string line;
		line=name+" "+connections[0].net.to_string()+" 0 ";
		switch((int)get_parameter("type").val){
			case(Type.DC):
				line+="dc "+get_parameter("voltage").val.to_string();
				break;
			case(Type.SINUS):
				line+="sin("+get_parameter("offset").val.to_string()+" "+get_parameter("amplitude").val.to_string()+" "+get_parameter("frequency").val.to_string()+" "+get_parameter("delay").val.to_string()+" "+get_parameter("damping").val.to_string()+")";
				break;
			case(Type.PULSE):
				line+="pulse( "+get_parameter("initial value").val.to_string()+" "+get_parameter("pulsed value").val.to_string()+" "+get_parameter("delay time").val.to_string()+" "+get_parameter("rise time").val.to_string()+" "+get_parameter("fall time").val.to_string()+" "+get_parameter("pulse width").val.to_string()+" "+get_parameter("period").val.to_string()+")";
				break;
		}
		line+="\n";
		return line;
	}

}
}
