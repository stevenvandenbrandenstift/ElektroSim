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
using Gdk;
using Gtk;

enum Target {
	INT32
}
const TargetEntry[] target_list = {
	{ "INTEGER", 0, Target.INT32}
};

const int BYTE_BITS = 8;
const int WORD_BITS = 16;
const int DWORD_BITS = 32;

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
	NONE,INACTIVE, SUBACTIVE, ACTIVE, OVERACTIVE;
}
public enum Zone {
	NONE,SUBOPTIMAL, OPTIMAL, OUTOFRANGE, DESTRUCTIVE;
}

	public enum Orientation {
		UNKNOWN, LEFT, RIGHT, UP, DOWN;
	}

public abstract class Component : ListBoxRow {

	// Constructor
	public int height {get;set;default=0;}
	public int width {get;set;default=0;}

	public Activity activity{get;set;default=Activity.NONE;}
	public Zone zone{get;set;default=Zone.NONE;}
	public Orientation orientation{get;set;default=Orientation.UNKNOWN;}
	private Button label;
	public string name {get;set;}
	public List<Point> connections;

	public Component(string name){
		this.name=name;
		label= new Button.with_label (name);
		(this as ListBoxRow).add(label);

		Gtk.drag_source_set (
		                     label,                      // widget will be drag-able
		                     ModifierType.BUTTON1_MASK, // modifier that will start a drag
		                     target_list,               // lists of target to support
		                     DragAction.COPY            // what to do with data after dropped
		                     );

		label.drag_data_get.connect(on_drag_data_get);
		connections=new List<Point>();

	}

	public abstract Component clone(Component component, int x, int y);
	public abstract int snap(List<Component> list,int range,int netAmount);

	public abstract void draw_symbol(Cairo.Context context);
	public abstract string getNetlistLine();
	public abstract void insertSimulationData(string data);

	private void on_drag_data_get (Widget widget, DragContext context,
	                               SelectionData selection_data,
	                               uint target_type, uint time)
	{

		//print ("%s: on_drag_data_get\n", widget.name);
		//print (" Sending ");

		switch (target_type) {
			// case Target.SOME_OBJECT:
			// Serialize the object and send as a string of bytes.
			// Pixbufs, (UTF-8) text, and URIs have their own convenience
			// setter functions
			case Target.INT32:
				uchar [] buf;
				convert_long_to_bytes(this.get_index(), out buf);
				selection_data.set (
				                    selection_data.get_target(),      // target type
				                    BYTE_BITS,                 // number of bits per 'unit'
				                    buf // pointer to data to be sent
				                    );
				break;
			default:
				// Default to some a safe target instead of fail.
				print ("failed to send");
				assert_not_reached ();
		}

		//print (".\n");
	}


	private void convert_long_to_bytes(long number, out uchar [] buffer) {
		buffer = new uchar[sizeof(long)];
		for (int i=0; i<sizeof(long); i++) {
			buffer[i] = (uchar) (number & 0xFF);
			number = number >> 8;
		}
	}




}

