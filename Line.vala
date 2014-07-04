/* -*- Mode: vala; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/*
 * line.vala
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
namespace ElektroSim{
	
public class Line : Component {

	public bool second_point_needed{get;set;default=false;}
	
	public Line () {
			base("Line");
			clear_parameters();
			this.width=100;
			this.height=50;
	}
	
	public override void draw_image(Cairo.Context cr){
		
		int p1_x = connections[0].x;
		int p1_y = connections[0].y;
		
		if(!second_point_needed){
		int p2_x = connections[1].x;
		int p2_y = connections[1].y;
		width=100;
		
		cr.new_path ();
		cr.move_to (p1_x, p1_y);
		if(orientation==ElektroSim.Orientation.RIGHT||orientation==ElektroSim.Orientation.LEFT){
			cr.line_to (p2_x, p1_y);
			cr.move_to (p2_x, p1_y);
			cr.line_to (p2_x,p2_y);
		}else{
			cr.line_to (p1_x, p2_y);
			cr.move_to (p1_x, p2_y);
			cr.line_to (p2_x,p2_y);
		}
		cr.close_path ();
		cr.stroke ();

		}else{ //draw tempory dot indicating to click next point
			cr.new_path ();
			cr.arc(p1_x, p1_y, 10.0, 0, 2*Math.PI);
			cr.close_path ();
			cr.fill ();
		}
	}
	
	public override Component clone(){
			Line new_c=new Line();
			return new_c;
	}

	public override void snap(int range,int x ,int y){
		Point point;
		point=new Point(x,y);
		point=point.point_nearby(range);
		
		if(connections.is_empty){
			orientation=point.connect_component(this);
			second_point_needed=true;
		}else{
			second_point_needed=false;
			point.connect_component(this);
			point.net=connections[0].net;
		}
		connections.add(point);
	}
}
}

