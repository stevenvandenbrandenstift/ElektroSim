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
using Gee;
namespace ElektroSim{

public enum Activity {
	UNKNOWN,INACTIVE, SUBACTIVE, ACTIVE, OVERACTIVE;
}
public enum Zone {
	UNKNOWN,SUBOPTIMAL, OPTIMAL, OUTOFRANGE, DESTRUCTIVE;
}
public enum Orientation{
		NONE,RIGHT,LEFT,DOWN,UP;
}

public abstract class Component : ListBoxRow {

	// Constructor
	public int height {get;set;default=0;}
	public int width {get;set;default=0;}
	public ElektroSim.Orientation orientation{get;set;default=ElektroSim.Orientation.NONE;}
	
	public ArrayList<Parameter> parameters =new ArrayList<Parameter>();
	private Label name_label;
	
	public ArrayList<Point> connections=new ArrayList<Point>();
	private Box grid;
	
	public Cairo.Surface image_surface;
	public Cairo.Context image_context;
	public Cairo.Surface emoticon_surface;
	public Cairo.Context emoticon_context;
	
	public Component(string name){
		parameters.add(new Parameter("i",0));
		parameters.add(new Parameter("p",0));
		parameters.add(new Parameter("activity",Activity.UNKNOWN));
		parameters.add(new Parameter("work_zone",Zone.UNKNOWN));
		
		this.name=name;
	
		grid = new Box (Gtk.Orientation.VERTICAL,0);
		grid.set_can_focus(false);
		
		name_label= new Label (name);
		grid.add(name_label);
		(this as ListBoxRow).add(grid);
	}
	
	public void set_adjustable(){	
		foreach(Parameter par in parameters){
			if(par.editable){
				grid.add(par);	
			}
		}
	}
	
	protected void setup_surface(ElektroSim.Orientation orientation){
		
		switch (orientation){
		
			case ElektroSim.Orientation.RIGHT:
				image_surface = new Cairo.ImageSurface (Cairo.Format.ARGB32, width, height);
				break;
			case ElektroSim.Orientation.LEFT:
				image_surface = new Cairo.ImageSurface (Cairo.Format.ARGB32, width, height);
				break;
			case ElektroSim.Orientation.UP:
				image_surface = new Cairo.ImageSurface (Cairo.Format.ARGB32, height, width);
				break;
			case ElektroSim.Orientation.DOWN:
				image_surface = new Cairo.ImageSurface (Cairo.Format.ARGB32, height, width);
				break;	
			case ElektroSim.Orientation.NONE:
				image_surface = new Cairo.ImageSurface (Cairo.Format.ARGB32, 1,1);
				break;
		}		
		image_context=new Cairo.Context(image_surface);
		image_context.set_source_rgb (3, 3, 3);
		image_context.set_line_width (3);
		image_context.select_font_face ("Adventure", Cairo.FontSlant.NORMAL, Cairo.FontWeight.BOLD);
		
		emoticon_surface = new Cairo.ImageSurface (Cairo.Format.ARGB32, 110, 110);
		emoticon_context=new Cairo.Context(emoticon_surface);
		
		
		
	}
	
	
	protected Parameter? get_parameter(string name){
		//stdout.printf ("searching parameter %s\n",name);
		foreach(Parameter par in parameters){
			//stdout.printf ("parameter %s:%i\n",par.name,par.val);
			if(par.name==name){
				//stdout.printf ("found parameter %s:%i\n",par.name,par.val);
				return par;
			}
		}
		return null;
	}
	

	public abstract Component clone(Component component);
	public abstract void snap(int range,int x, int y);

	public void update_emoticon(){
		
		emoticon_context=new Cairo.Context(emoticon_surface);
		int activity= get_parameter("activity").val;
		int zone=get_parameter("work_zone").val;
		
		if(activity!=Activity.UNKNOWN){
		string emoticon;
		if(activity==Activity.INACTIVE){
		emoticon="./emoticons/deepSleepAlien.svg";
		}else if(activity==Activity.SUBACTIVE){
		
			switch(zone){
		
				case Zone.DESTRUCTIVE: 
					emoticon="./emoticons/angstigSleepyAlien.svg";
					break;
				case Zone.OUTOFRANGE:
					emoticon="./emoticons/stressesSleepyAlien.svg";
					break;
				case Zone.OPTIMAL:
					emoticon="./emoticons/sleepyAlien.svg";
					break;
				case Zone.SUBOPTIMAL:
					emoticon="./emoticons/sleepyAlien.svg";
					break;
				default:
					emoticon="./";
					break;
			}
		}
		else if(activity==Activity.ACTIVE){
		
			switch(zone){
		
				case Zone.DESTRUCTIVE: 
					emoticon="./emoticons/stressedAlien.svg";
					break;
				case Zone.OUTOFRANGE:
					emoticon="./emoticons/stressedSadAlien.svg";
					break;
				case Zone.OPTIMAL:
					emoticon="./emoticons/HappyAlien.svg";
					break;
				case Zone.SUBOPTIMAL:
					emoticon="./emoticons/NerveusAlien.svg";
					break;
				default:
					emoticon="./";
					break;
			}
		}else if(activity==Activity.OVERACTIVE){
		
			switch(zone){
		
				case Zone.DESTRUCTIVE: 
					emoticon="./emoticons/ScaredAlien.svg";
					break;
				case Zone.OUTOFRANGE:
					emoticon="./emoticons/depresiveAlien.svg";
						break;
				case Zone.OPTIMAL:
					emoticon="./emoticons/ExcitedAlien.svg";
					break;
				case Zone.SUBOPTIMAL:
					emoticon="./emoticons/FrustratedAlien.svg";
					break;
				default:
					emoticon="./";
					break;
			}
		}else{
		emoticon=null;
		}
		
		if(emoticon!=null){
		Rsvg.Handle handle;
			
       	try {
            handle = new Rsvg.Handle.from_file(emoticon);
        	} catch( Error e ) {
            stderr.printf( "can not open svg file\n" );
            handle=null;
        	}
        	emoticon_context.new_path ();
        	emoticon_context.scale (1.5, 1.5);
        	handle.render_cairo( emoticon_context );
        	emoticon_context.close_path();
        	
        	}
		}
	}
	public virtual void update_image(){
	}
	public virtual void make_image(){
	
	}
	
	public virtual void clear_counter(){
	}
	
	public virtual string get_netlist_line(){
		return "";
	}
	
	public void insert_simulation_data(string line){
	
		int position,position2,end;
		end=line.char_count ();
		position=line.index_of_char (' ');
		position2=line.last_index_of_char (' ')+1;
		string val=line.slice(position2,end);
		string name=line.slice(0,position);
		Parameter par=get_parameter(name);
		
		if(par!=null){
			
			if(name!="activity"&&name!="work_zone"){
			par.val=(int)double.parse(val);
			}else{ //activity and zone
				if(name=="activity"){
					if(val.contains("inactive")){
						par.val=Activity.INACTIVE;
					}else if(val.contains("subactive")){
						par.val=Activity.SUBACTIVE;
					}else if(val.contains("overactive")){
						par.val=Activity.OVERACTIVE;
					}else if(val.contains("active")){
						par.val=Activity.ACTIVE;
					}else {
						par.val=Activity.UNKNOWN;
					}
				}else if(name=="work_zone"){
			
					if(val.contains("suboptimal")){
						par.val=Zone.SUBOPTIMAL;
					}else if(val.contains("optimal")){
						par.val=Zone.OPTIMAL;
					}else if(val.contains("outofrange")){
						par.val=Zone.OUTOFRANGE;
					}else if(val.contains("destructive")){
						par.val=Zone.DESTRUCTIVE;
					}else {
						par.val=Zone.UNKNOWN;
					}
				}
				
			}
			stdout.printf ("added %s:%s:%s-%i\n",this.name,name,val,par.val);
			
		}
	}
	
}

}
