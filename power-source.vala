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
namespace ElektroSim{
	
public class PowerSource : Component {

	public static int counter;

	public PowerSource (float voltage) {
			base("PowerSource");
			this.width=100;
			this.height=50;
			add_parameter("V",voltage,Group.ADJUSTABLE);
			
	}
	
			public override void draw_image(Cairo.Context cr){
		
		int p1_x = connections[0].x;
		int p1_y = connections[0].y;

		cr.new_path ();
		cr.move_to (p1_x, p1_y);
		if(orientation==ElektroSim.Orientation.RIGHT){
		cr.rel_line_to (width,0);
		}else if(orientation==ElektroSim.Orientation.LEFT){
		cr.rel_line_to (-width,0);
		}else if(orientation==ElektroSim.Orientation.UP){
		cr.rel_line_to (0,-width);
		}else{
		cr.rel_line_to (0,width);
		}
		cr.close_path ();
		cr.stroke ();
		
		cr.new_path ();
		cr.set_font_size (height*0.4);
		
		if(orientation==ElektroSim.Orientation.RIGHT){
		cr.move_to (p1_x+width*0.65,p1_y-5);
		}else if(orientation==ElektroSim.Orientation.LEFT){
		cr.move_to (p1_x-width,p1_y-5);
		}else if(orientation==ElektroSim.Orientation.UP){
		cr.move_to (p1_x+5,p1_y-width*0.8);
		}else if(orientation==ElektroSim.Orientation.DOWN){
		cr.move_to (p1_x+5,p1_y+width*0.9);
		}
		
		cr.text_path (name);
		cr.fill();
		cr.close_path ();
	
	}
	
	
	public override void clear_counter(){
	counter=0;
	}
	
	public override Component clone(){
			PowerSource newc=new PowerSource(get_parameter("V").val);
			counter++;
			newc.set_name("v"+counter.to_string());
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
		line=name+" "+connections[0].net.to_string()+" 0 "+get_parameter("V").val.to_string()+"\n";
		return line;
	}

}
}
