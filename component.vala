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





public abstract class Component : ListBoxRow {
	
	public enum Activity {
	UNKNOWN,INACTIVE, SUBACTIVE, ACTIVE, OVERACTIVE;
	}
	public enum Zone {
		UNKNOWN,SUBOPTIMAL, OPTIMAL, OUTOFRANGE, DESTRUCTIVE;
	}
	public enum Orientation{
			NONE,RIGHT,LEFT,DOWN,UP;
	}

	public enum ComponentType{
			COMPONENT,TEMPLATE,SIMULATION;
	}
	// Constructor
	public signal void request_simulate();
	public signal void request_redraw();
	public int height {get;set;default=0;}
	public int width {get;set;default=0;}
	public ComponentType componentType {get;set;default=ComponentType.COMPONENT;}
	public Orientation orientation{get;set;default=Orientation.NONE;}
	
	public ArrayList<Parameter> parameters =new ArrayList<Parameter>();
	
	public ArrayList<Point> connections=new ArrayList<Point>();
	public Box grid{get;set;}
	private string emoticons;
	private Label label;
	public Cairo.Surface image_surface;
	public Cairo.Context image_context;
	public Cairo.Surface emoticon_surface;
	public Cairo.Context emoticon_context;
	private int selected_parameter;

	public Component(string name){
		init(name);
		add_parameter("i",0,Parameter.WidgetStyle.LABEL);
		add_parameter("p",0,Parameter.WidgetStyle.LABEL);
		add_parameter("activity",(double)Activity.UNKNOWN,Parameter.WidgetStyle.LABEL);
		add_parameter("work_zone",(double)Zone.UNKNOWN,Parameter.WidgetStyle.LABEL);
		selected_parameter=-1;

	}
	
	public  string to_string(){
		string line;
		line=name+":\n parameters in parameters:\n";
		foreach(Parameter par in parameters)
			line+=par.to_string();
		line+="\n parameters in grid:\n";
		GLib.List<weak Widget> tl =this.grid.get_children(); 
			foreach(Widget parameter in tl)
				line+=(parameter as Parameter).to_string();
		line+="\n\n";
		return line;
	}
	public void init(string name){
		emoticons="./emoticons/";
		grid= new Box(Gtk.Orientation.VERTICAL,0);
		label=new Label(name);
		grid.add(label);
		set_name(name);
		(this as ListBoxRow).add(grid);
	}

	public void clear_parameters(){
		GLib.List<weak Widget> tl =this.grid.get_children();
			foreach(Widget parameter in tl){
				if(parameter.get_type()!=typeof (Label))
					grid.remove(parameter);
			}
		parameters =new ArrayList<Parameter>();
	}
	
	public void set_mode(ComponentList.Mode mode){
		foreach(Parameter par in parameters){
			par.set_mode(mode);
		}
	}
	
	public void set_name(string new_name){
		GLib.List<weak Widget> tl =this.grid.get_children();
			foreach(Widget parameter in tl){
				if(parameter.get_type()==typeof (Label)){
					(parameter as Label).label=new_name;
					}
			}
		name=new_name;
	}
	
	public void invalidate_values(){
		foreach(Parameter par in parameters)
			par.invalidate_values=true;
	}

	public Parameter? add_parameter(string name, double val,Parameter.WidgetStyle simulation = Parameter.WidgetStyle.NONE,Parameter.WidgetStyle edit= Parameter.WidgetStyle.NONE, ArrayList<string> options = new ArrayList<string>()){
		Parameter par=get_parameter(name);
		if(par!=null){  //parameter exists -- update
			par.val=val;
			par.set_edit_array(edit);
			par.set_simulation_array(simulation);
		}else{  //does not exist add
			par=new Parameter(name,val);
			parameters.add(par);
			par.edited.connect (() => {
   					request_simulate();
			});
			if(par.name=="activity"||par.name=="work_zone"){
			par.updated.connect (() => {
   					request_redraw();
			});
			}
			foreach(string str in options){
				par.options.add(str);
			}
			par.set_edit_array(edit);
			par.set_simulation_array(simulation);
			grid.add(par);
		}
		return par;
	}
	
	public Parameter? get_next_parameter(){
		if(parameters!=null){
		selected_parameter++;
		if(selected_parameter>=parameters.size)
			selected_parameter=0;

		while(parameters[selected_parameter].values==null||parameters[selected_parameter].values.size==0){
			selected_parameter++;
			if(selected_parameter>=parameters.size)
			selected_parameter=0;
		}
		return parameters[selected_parameter];
		}
		return null;
	}

	public Parameter? get_parameter(string name){
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
	

	public abstract Component clone();
	public abstract void snap(int range,int x, int y);

	public void draw_emoticon(Cairo.Context cr,int x,int y){
		
		Parameter act=get_parameter("activity");
		Parameter zon=get_parameter("work_zone");
		int activity=0;
		int zone=0;

		if(act.values==null||act.values.size<1){
		activity= (int)act.val;
		}else{
			foreach(double val in act.values){
				if(activity<val)
					activity=(int)val;
			}
		}

		if(zon.values==null||zon.values.size<1){
		zone= (int)zon.val;
		}else{
			foreach(double val in zon.values){
				if(zone<val)
					zone=(int)val;
			}
		}

		Cairo.ImageSurface temp_surface = new Cairo.ImageSurface (Cairo.Format.ARGB32, 100, 100);
		Cairo.Context emoticon_context = new Cairo.Context (temp_surface);
		
		if(activity!=Activity.UNKNOWN){
		string emoticon;
		if(activity==Activity.INACTIVE){
		emoticon=emoticons+"deepSleepAlien.svg";
		}else if(activity==Activity.SUBACTIVE){
		
			switch(zone){
		
				case Zone.DESTRUCTIVE: 
					emoticon=emoticons+"angstigSleepyAlien.svg";
					break;
				case Zone.OUTOFRANGE:
					emoticon=emoticons+"stressesSleepyAlien.svg";
					break;
				case Zone.OPTIMAL:
					emoticon=emoticons+"sleepyAlien.svg";
					break;
				case Zone.SUBOPTIMAL:
					emoticon=emoticons+"sleepyAlien.svg";
					break;
				default:
					emoticon=emoticons;
					break;
			}
		}
		else if(activity==Activity.ACTIVE){
		
			switch(zone){
		
				case Zone.DESTRUCTIVE: 
					emoticon=emoticons+"stressedAlien.svg";
					break;
				case Zone.OUTOFRANGE:
					emoticon=emoticons+"stressedSadAlien.svg";
					break;
				case Zone.OPTIMAL:
					emoticon=emoticons+"HappyAlien.svg";
					break;
				case Zone.SUBOPTIMAL:
					emoticon=emoticons+"NerveusAlien.svg";
					break;
				default:
					emoticon=emoticons;
					break;
			}
		}else if(activity==Activity.OVERACTIVE){
		
			switch(zone){
		
				case Zone.DESTRUCTIVE: 
					emoticon=emoticons+"ScaredAlien.svg";
					break;
				case Zone.OUTOFRANGE:
					emoticon=emoticons+"depresiveAlien.svg";
						break;
				case Zone.OPTIMAL:
					emoticon=emoticons+"ExcitedAlien.svg";
					break;
				case Zone.SUBOPTIMAL:
					emoticon=emoticons+"FrustratedAlien.svg";
					break;
				default:
					emoticon=emoticons;
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
			cr.save();
        	cr.new_path ();
			emoticon_context.set_operator (Cairo.Operator.OVER);
        	emoticon_context.scale (1.5, 1.5);
        	handle.render_cairo( emoticon_context );
			cr.set_source_surface (emoticon_context.get_target (), x, y);
			cr.paint();
        	cr.close_path();
        	cr.restore();
        	}
		}
	}

	public virtual void draw_image(Cairo.Context cr){
	}
	
	public virtual void clear_counter(){
	}
	
	public virtual string get_netlist_line(){
		return "";
	}
	
	public void insert_simulation_data(string name,string val,bool add){
	
		Parameter par=get_parameter(name);
		
		if(par!=null){
			
			if(name!="activity"&&name!="work_zone"){
				double temp=double.parse(val.replace(",","."));
				//print("%s : %s added %f  from %s\n",this.name,par.name,temp,val);
				par.set_value(temp);
			}else{ //activity and zone
				if(name=="activity"){
					if(val.contains("inactive")){
						par.set_value((double)Activity.INACTIVE);
					}else if(val.contains("subactive")){
						par.set_value((double)Activity.SUBACTIVE);
					}else if(val.contains("overactive")){
						par.set_value((double)Activity.OVERACTIVE);
					}else if(val.contains("active")){
						par.set_value((double)Activity.ACTIVE);
					}else {
						par.set_value((double)Activity.UNKNOWN);
					}
				}else if(name=="work_zone"){
			
					if(val.contains("suboptimal")){
						par.set_value((double)Zone.SUBOPTIMAL);
					}else if(val.contains("optimal")){
						par.set_value((double)Zone.OPTIMAL);
					}else if(val.contains("outofrange")){
						par.set_value((double)Zone.OUTOFRANGE);
					}else if(val.contains("destructive")){
						par.set_value((double)Zone.DESTRUCTIVE);
					}else {
						par.set_value((double)Zone.UNKNOWN);
					}
				}
				
			}

			if(add)
				par.add_value(par.val);
			
		}
	}
	
}

}
