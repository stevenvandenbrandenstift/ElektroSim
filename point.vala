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

public enum Orientation{
		NONE,RIGHT,LEFT,DOWN,UP;
}

public class Point{
	public static int netAmount=0;
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
	public Point pointNearby(int range){
			foreach(Point snapPoint in points){
				if((x>snapPoint.x-range)&&(x<snapPoint.x+range)&&(y>snapPoint.y-range)&&(y<snapPoint.y+range)){
					if(connections.right==null||connections.left==null||connections.up==null||connections.left==null){
					return snapPoint;
					}
				}
			}
		points.add(this);
		print("added point %i,%i \n",this.x,this.y);
		return this;
	}
	
	public static void clear(){
		netAmount=0;
		points.clear();
	}
	
	public Orientation GetComponentConnection(Component component){
		if(component==connections.right){
			return Orientation.RIGHT;
		}else if(component==connections.left){
			return Orientation.LEFT;
		}else if(component==connections.up){
			return Orientation.UP;
		}else if(component==connections.down){
			return Orientation.DOWN;
		}else{
			return Orientation.NONE;
		}
		
	}

	public int checkNetName(int netCount){
				print("net from point %i,%i : %i %i\n",x,y,net,netCount);
				if(net==1000){
					net=netCount;
					return netCount+1;
				}
			return netCount;
	}
	
	public void connectComponent(Component component){
		
		if(component.connections.is_empty){
		if(connections.right==null){
			connections.right=component;
			//print("connected %s on right of point",component.name);
		}else if(connections.left==null){
			connections.left=component;
			//print("connected %s on left of point",component.name);
		}else if(connections.down==null){
			connections.down=component;
			//print("connected %s on down of point",component.name);
		}else if(connections.up==null){
			connections.up=component;
			//print("connected %s on up of point",component.name);
		}
		}else{
			switch (component.connections[0].GetComponentConnection(component)){
			case ElektroSim.Orientation.RIGHT:
				connections.left=component;
				break;
			case ElektroSim.Orientation.LEFT:
				connections.right=component;
				break;
			case ElektroSim.Orientation.UP:
				connections.down=component;
				break;
			case ElektroSim.Orientation.DOWN:
				connections.up=component;
				break;
			case ElektroSim.Orientation.NONE:
				connections.left=component;
				break;
			}	
		}
		
		
	}
	
	
}
}
