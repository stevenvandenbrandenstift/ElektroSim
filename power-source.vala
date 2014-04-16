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

	public PowerSource (int voltage) {
			base("PowerSource");
			this.width=100;
			this.height=50;
			parameters.add(new Parameter.adjustable("V",voltage));
			
	}
	
	public override void make_image(){
		
		setup_surface(orientation);
		
		image_context.new_path ();
		image_context.move_to (0, height/2);
		image_context.line_to (width, height/2);
		image_context.close_path ();
		image_context.stroke ();
		
		image_context.new_path ();
		image_context.set_font_size (height*0.4);
		
		
		if(orientation==ElektroSim.Orientation.RIGHT){

		image_context.move_to (width*0.6, height/2-5);
		
		}else if(orientation==ElektroSim.Orientation.LEFT){
		
		image_context.move_to (0, height/2-5);

		}
		image_context.text_path (name);
		image_context.fill();
		image_context.close_path ();
	}
	
	public override void clear_counter(){
	counter=0;
	}
	
	public override Component clone(){
			PowerSource newc=new PowerSource(get_parameter("V").get_input());
			counter++;
			newc.name="v"+counter.to_string();
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
