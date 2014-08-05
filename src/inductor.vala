/* -*- Mode: vala; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/*
 * inductor.vala
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
using Gee;
namespace ElektroSim{
	
public class Inductor : Component {
	public static int counter=0;
	
	// Constructor
	public Inductor (double inductance) {
		base("Inductor");
		this.width=250;
		this.height=50;
		add_parameter("L",inductance,"H");
	}
	
	public override void draw_image(Cairo.Context cr){
		int p1_x = connections[0].x;
		int p1_y = connections[0].y;
		int p2_x = connections[1].x;
		int p2_y = connections[1].y;
		int x,y;
		if(orientation==Component.Orientation.RIGHT||orientation==Component.Orientation.LEFT){	
			if(p1_x>p2_x){
				int temp=p2_x;
				p2_x=p1_x;
				p1_x=temp;
			}
			cr.new_path ();	
			cr.move_to (p1_x, p1_y);
			cr.rel_line_to (width/6, 0);

            cr.arc ( p1_x+3*width/12, p1_y,width/12, 180.0 * (Math.PI/180.0),0);
            cr.arc ( p1_x+5*width/12, p1_y,width/12, 180.0 * (Math.PI/180.0),0);
            cr.arc ( p1_x+7*width/12, p1_y,width/12, 180.0 * (Math.PI/180.0),0);
            cr.arc ( p1_x+9*width/12, p1_y,width/12, 180.0 * (Math.PI/180.0),0);

			cr.move_to (p2_x-width/6-2,p2_y);
			cr.rel_line_to (width/6+2, 0);
			cr.close_path ();
			cr.stroke ();
		    
			cr.new_path ();
			cr.set_font_size (height*0.5);
			cr.move_to (p1_x+width/20,p1_y-height/3);
			cr.text_path (name);
			cr.close_path();
			cr.fill();
			x=p1_x+100;
			y=p1_y-120;
		}else{
			if(p1_y>p2_y){
				int temp=p2_y;
				p2_y=p1_y;
				p1_y=temp;
			}
			cr.new_path ();	
			cr.move_to (p1_x, p1_y);
			cr.rel_line_to (0,width/6);

            cr.arc ( p1_x,p1_y+3*width/12,width/12, 270.0 * (Math.PI/180.0),90.0 * (Math.PI/180.0));
            cr.arc ( p1_x,p1_y+5*width/12,width/12, 270.0 * (Math.PI/180.0),90.0 * (Math.PI/180.0));
            cr.arc ( p1_x,p1_y+7*width/12,width/12, 270.0 * (Math.PI/180.0),90.0 * (Math.PI/180.0));
            cr.arc ( p1_x,p1_y+9*width/12,width/12, 270.0 * (Math.PI/180.0),90.0 * (Math.PI/180.0));

			cr.move_to (p2_x, p2_y-width/6-2);
			cr.rel_line_to (0,width/6+2);
			cr.close_path ();
			cr.stroke ();
		
			cr.new_path ();
			cr.set_font_size (height*0.5);
			cr.move_to (p1_x+height/4,p1_y+width/10);
			cr.text_path (name);
			cr.close_path();
			cr.fill();
			y=p1_y+80;
			x=p1_x+40;
		}
        
		draw_emoticon(cr,100,-120);
	}
	
	public override void clear_counter(){
		counter=0;
	}
	
	public override Component clone(){
		Inductor newc=new Inductor(get_parameter("L").val);
		if(this.get_parameter("L")==null)
			print("error no parameter to copy from!");
		counter++;
		newc.set_name("l"+counter.to_string());
		newc.componentType=Component.ComponentType.COMPONENT;
		return newc;
	}

	public override void snap(int range,int x, int y){
		Point point,point2;
		point=new Point(x,y);
		point=point.point_nearby(range);
		connections.add(point);
		orientation=point.connect_component(this);
		if(orientation==Component.Orientation.RIGHT){
			point2=new Point(point.x+width,point.y);
		} else if (orientation==Component.Orientation.LEFT){
		 	point2=new Point(point.x-width,point.y);
		}else if(orientation==Component.Orientation.UP){
			point2=new Point(point.x,point.y-width);
		}else if(orientation==Component.Orientation.DOWN){
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
		line=name+" "+connections[0].net.to_string()+" "+connections[1].net.to_string()+" "+get_parameter("L").val.to_string()+"\n";
		return line;
	}
}

}