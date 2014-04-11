/* -*- Mode: vala; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/*
 * resistor.vala
 * Copyright (C) 2014 Steven Vanden Branden <StevenVandenBrandenstift@gmail.com>
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
namespace ElektroSim{
	
public class Resistor : Component {

	public static int counter=0;
	
	// Constructor
	public Resistor (int resistance,int max_power) {
		base("Resistor");
		this.width=250;
		this.height=50;
		parameters.add(new Parameter.adjustable("R",resistance));
		parameters.add(new Parameter.adjustable("Max Power",max_power));
		
		
		//parameters returned from simulation
		parameters.add(new Parameter("ac",0));
		parameters.add(new Parameter("dtemp",0));
		parameters.add(new Parameter("bv_max",0));
		parameters.add(new Parameter("noisy",0));
	}
	
	public override void make_image(){
		
		setup_surface(orientation);
		
		image_context.new_path ();	
		image_context.move_to (0, height/2);
		image_context.line_to (width/5, height/2);
		image_context.rectangle (width/5,0,width/5*3,height);
		image_context.close_path ();
		image_context.stroke ();
		
		image_context.new_path ();
		image_context.move_to (width*4/5, height/2);
		image_context.line_to (width, height/2);
		image_context.close_path ();
		image_context.stroke ();
		
		image_context.new_path ();
		image_context.set_font_size (height*0.9);
		image_context.move_to (width/5+5,height/1.2);
		image_context.text_path (name);
		image_context.close_path();
		image_context.fill();

	}
	
	public override void clear_counter(){
		counter=0;
	}
	
	public override Component clone(Component component){
		Resistor newc=new Resistor(get_parameter("R").get_input(),get_parameter("Max Power").get_input());
		counter++;
		newc.name="r"+counter.to_string();
		return newc;
	}

	public override void snap(int range,int x, int y){
		Point point,point2;
		point=new Point(x,y);
		point=point.point_nearby(range);
		connections.add(point);
		orientation=point.connect_component(this);
		if(orientation==ElektroSim.Orientation.RIGHT){
			point2=new Point(point.x+width,point.y);
		} else if (orientation==ElektroSim.Orientation.LEFT){
		 	point2=new Point(point.x-width,point.y);
		}else{
		point2=new Point(point.x-width,point.y);
		}
		point2=point2.point_nearby(range);
		connections.add(point2);
		point2.connect_component(this);
		
	}

	public override string get_netlist_line(){
		string line;
		line=name+" "+connections[0].net.to_string()+" "+connections[1].net.to_string()+" "+get_parameter("R").val.to_string()+" max_power="+get_parameter("Max Power").val.to_string()+"\n";
		return line;
	}
}

}
