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

namespace ElektroSim{
	
public class Line : Component {

	public bool secondPoint{get;set;default=false;}
	
	public Line () {
			base("Line");
			this.width=100;
			this.height=50;
	}
	
	public override void make_image(){
		
		setupSurface(ElektroSim.Orientation.NONE);
		
		if(secondPoint){
		setupSurface(orientation);
		imageContext.new_path ();
		imageContext.move_to (0, 0);
		imageContext.line_to (connections[1].x-connections[0].x, 0);
		imageContext.close_path ();
		imageContext.stroke ();
		
		imageContext.new_path ();
		imageContext.move_to (connections[1].x-connections[0].x, 0);
		imageContext.line_to (connections[1].x-connections[0].x, connections[1].y-connections[0].y);
		imageContext.close_path ();
		imageContext.stroke ();
		}
	
	}
	
	public override Component clone(Component component){
			Line newc=new Line();
			return newc;
	}
	
	public override void insertSimulationData(DataPair pair){
	}

	public override void snap(int range,int x ,int y){
		Point point;
		point=new Point(x,y);
		point=point.pointNearby(range);
		orientation=point.connectComponent(this);
		if(!connections.is_empty){
			secondPoint=true;
		}
		connections.add(point);
	}
}
}

