/* -*- Mode: vala; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/*
 * point.vala
 * Copyright (C) 2014 Steven Vanden Branden <StevenVandenBrandenStift@gmail.com>
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

public class Point{
	public static int net_amount=0;
	public static ArrayList<Point> points=new ArrayList<Point>();
	public int x{get;set;default=0;}
	public int y{get;set;default=0;}
	public int net{get;set;default=1000;}

	private struct Connections{
		Component right;
		Component left;
		Component down;
		Component up;
	}
	
	private Connections connections;


	public Point(int x,int y){
		this.x=x;
		this.y=y;
		connections=Connections();
		connections.left=null;
		connections.right=null;
		connections.up=null;
		connections.down=null;
	}
		
	//searches a nearby point or adds this one to the list of points
	public Point point_nearby(int range){
			foreach(Point snap_point in points){
				if((x>snap_point.x-range)&&(x<snap_point.x+range)&&(y>snap_point.y-range)&&(y<snap_point.y+range)){
					if(connections.right==null||connections.left==null||connections.up==null||connections.left==null){
						return snap_point;
					}
				}
			}
		//point does not yet exist in list
		Point point;
		point=new Point(x,y);
		net_amount++;
		point.net=net_amount;
		points.add(point);
		print("added point %i,%i \n",point.x,point.y);
		return point;
	}
	
	public static void clear(){
		net_amount=0;
		points.clear();
	}
	
	
	public Component.Orientation connect_component(Component component){
		
		if(component.orientation==Component.Orientation.NONE){	// empty list means first point
			if(connections.right==null){
				connections.right=component;
				return Component.Orientation.RIGHT;
			}else if(connections.left==null){
				connections.left=component;
				return Component.Orientation.LEFT;
			}else if(connections.down==null){
				connections.down=component;
				return Component.Orientation.DOWN;
			}else if(connections.up==null){
				connections.up=component;
				return Component.Orientation.UP;
			}
		}else{
			switch (component.orientation){
			case Component.Orientation.RIGHT:
				connections.left=component;
				break;
			case Component.Orientation.LEFT:
				connections.right=component;
				break;
			case Component.Orientation.UP:
				connections.down=component;
				break;
			case Component.Orientation.DOWN:
				connections.up=component;
				break;
			case Component.Orientation.NONE:
				connections.left=component;
				print("error found orientation NONE \n");
				break;
			}	
		}
		
		return component.orientation;
		
	}
	
	
}
}
