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
	public Resistor (float resistance,float max_power) {
		base("Resistor");
		this.width=250;
		this.height=50;
		add_parameter("R",resistance,Group.ADJUSTABLE);
		add_parameter("Max Power",max_power,Group.ADJUSTABLE);
		//parameters returned from simulation
		add_parameter("ac",0,Group.OPTIONAL_PARAMETER);
		add_parameter("dtemp",0,Group.OPTIONAL_PARAMETER);
		add_parameter("bv_max",0,Group.OPTIONAL_PARAMETER);
		add_parameter("noisy",0,Group.OPTIONAL_PARAMETER);
	}
	
	public override void make_image(){
		
		setup_image_surface(orientation);
		
		
		if(orientation==ElektroSim.Orientation.RIGHT||orientation==ElektroSim.Orientation.LEFT){	
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
		}else{
			image_context.new_path ();	
			image_context.move_to (height/2,0);
			image_context.line_to (height/2,width/5);
			image_context.rectangle (0,width/5,height,width/5*3);
			image_context.close_path ();
			image_context.stroke ();
		
			image_context.new_path ();
			image_context.move_to (height/2,width*4/5);
			image_context.line_to (height/2, width);
			image_context.close_path ();
			image_context.stroke ();
		
			image_context.new_path ();
			image_context.set_font_size (height*0.8);
			image_context.move_to (0.2,width/2+5);
			image_context.text_path (name);
			image_context.close_path();
			image_context.fill();
		}

	}
	
	public override void clear_counter(){
		counter=0;
	}
	
	public override Component clone(){
		Resistor newc=new Resistor(get_parameter("R").val,get_parameter("Max Power").val);
		if(this.get_parameter("R")==null)
			print("error no parameter to copy from!");
		counter++;
		newc.set_name("r"+counter.to_string());
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
		}else if(orientation==ElektroSim.Orientation.UP){
			point2=new Point(point.x,point.y-width);
		}else if(orientation==ElektroSim.Orientation.DOWN){
			point2=new Point(point.x,point.y+width);
		}else{
			point2=new Point(point.x+width,point.y); //should not be reached
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
