/* -*- Mode: vala; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/*
 * component.vala
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

namespace ElektroSim{

public struct DataPair{
	string dataName;
	string dataValue;
}

public class Point{
	public int x{get;set;default=0;}
	public int y{get;set;default=0;}
	public int net{get;set;default=1000;}

	public Point(int x,int y){
		this.x=x;
		this.y=y;
	}
	
	public Point.with_net(int x, int y,int net){
		this.x=x;
		this.y=y;
		this.net=net;
	}
	
	public bool pointNearby(int range, List<Component> items){
		foreach(Component component in items){
			foreach(Point snapPoint in component.connections){
				if((x>snapPoint.x-range)&&(x<snapPoint.x+range)&&(y>snapPoint.y-range)&&(y<snapPoint.y+range)){
					this.x=snapPoint.x;
					this.y=snapPoint.y;
					if(this.net==0){
					snapPoint.net=0;
					}else{
					this.net=snapPoint.net;
					}
					return true;
				}
			}
		}
		return false;
	}

	public int checkNetName(int netCount){
				print("net from point %i,%i : %i %i\n",x,y,net,netCount);
				if(net==1000){
					net=netCount;
					return netCount+1;
				}
			return netCount;
	}
	
}

public enum Activity {
	UNKNOWN,INACTIVE, SUBACTIVE, ACTIVE, OVERACTIVE;
}
public enum Zone {
	UNKNOWN,SUBOPTIMAL, OPTIMAL, OUTOFRANGE, DESTRUCTIVE;
}

	public enum Orientation {
		UNKNOWN, LEFT, RIGHT, UP, DOWN;
	}

public abstract class Component : ListBoxRow {

	// Constructor
	public int height {get;set;default=0;}
	public int width {get;set;default=0;}
	
	public double i{get;set;default=0;}
	public double p{get;set;default=0;}	
	public Activity activity{get;set;default=Activity.UNKNOWN;}
	public Zone zone{get;set;default=Zone.UNKNOWN;}
	public Orientation orientation{get;set;default=Orientation.UNKNOWN;}
	private Label label;
	public string name {get;set;}
	public List<Point> connections;
	private Box box;

	public Component(string name){
		this.name=name;
		box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
		label= new Label (name);
		box.add(label);
		(this as ListBoxRow).add(box);
		connections=new List<Point>();

	}
	
	protected void addWidget(Widget widget){
		box.add(widget);
	}
	
	protected void addParameterWidget(string parameter,string parameterValue, out Label label,out Entry entry){
		label= new Label.with_mnemonic (parameter+":");
		addWidget(label);
		entry= new Entry();
		entry.set_text (parameterValue);
		entry.set_width_chars(5);
		addWidget(entry);
	}

	public abstract Component clone(Component component, int x, int y);
	public abstract int snap(List<Component> list,int range,int netAmount);

	public abstract void draw_symbol(Cairo.Context context);
	public abstract string getNetlistLine();
	public abstract void insertSimulationData(string data);


	protected DataPair lineToDataPair(string line){
		DataPair pair;
		pair= DataPair();
		int position,position2,end;
		end=line.char_count ();
		position=line.index_of_char (' ');
		position2=line.last_index_of_char (' ')+1;
		pair.dataValue=line.slice(position2,end);
		pair.dataName=line.slice(0,position);
		return pair;
	}




}

}
