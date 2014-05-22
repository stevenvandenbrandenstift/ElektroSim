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

	public bool second_point{get;set;default=false;}
	
	public Line () {
			base("Line");
			parameters =new ArrayList<Parameter>();
			this.width=100;
			this.height=50;
	}
	
	public override void make_image(){
		
		setup_image_surface(ElektroSim.Orientation.NONE);
		
		if(second_point){
		width=-1;
		
		setup_image_surface(orientation);
		image_context.new_path ();
		image_context.move_to (0, 0);
		image_context.line_to (connections[1].x-connections[0].x, 0);
		image_context.close_path ();
		image_context.stroke ();
		
		image_context.new_path ();
		image_context.move_to (connections[1].x-connections[0].x, 0);
		image_context.line_to (connections[1].x-connections[0].x, connections[1].y-connections[0].y);
		image_context.close_path ();
		image_context.stroke ();
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
		orientation=point.connect_component(this);
		if(connections.is_empty){
			second_point=true;
		}
		connections.add(point);
	}
}
}

