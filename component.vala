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

public struct DataPair{
	string dataName;
	string dataValue;
}

public enum Activity {
	UNKNOWN,INACTIVE, SUBACTIVE, ACTIVE, OVERACTIVE;
}
public enum Zone {
	UNKNOWN,SUBOPTIMAL, OPTIMAL, OUTOFRANGE, DESTRUCTIVE;
}

public abstract class Component : ListBoxRow {

	// Constructor
	public int height {get;set;default=0;}
	public int width {get;set;default=0;}
	public ElektroSim.Orientation orientation{get;set;default=ElektroSim.Orientation.NONE;}
	
	public double i{get;set;default=0;}
	public double p{get;set;default=0;}	
	public Activity activity{get;set;default=Activity.UNKNOWN;}
	public Zone zone{get;set;default=Zone.UNKNOWN;}
	private Label label;
	public ArrayList<Point> connections=new ArrayList<Point>();
	public Point topLeft;
	private Box grid;
	public Cairo.Surface imageSurface;
	public Cairo.Context imageContext;
	public Cairo.Surface emoticonSurface;
	public Cairo.Context emoticonContext;
	
	public Component(string name){
		this.name=name;
		grid = new Box (Gtk.Orientation.VERTICAL,0);
		grid.set_can_focus(false);
		label= new Label (name);
		grid.add(label);
		(this as ListBoxRow).add(grid);
	}
	
	protected void setupSurface(ElektroSim.Orientation orientation){
		
		switch (orientation){
		
			case ElektroSim.Orientation.RIGHT:
				imageSurface = new Cairo.ImageSurface (Cairo.Format.ARGB32, width, height);
				break;
			case ElektroSim.Orientation.LEFT:
				imageSurface = new Cairo.ImageSurface (Cairo.Format.ARGB32, width, height);
				break;
			case ElektroSim.Orientation.UP:
				imageSurface = new Cairo.ImageSurface (Cairo.Format.ARGB32, height, width);
				break;
			case ElektroSim.Orientation.DOWN:
				imageSurface = new Cairo.ImageSurface (Cairo.Format.ARGB32, height, width);
				break;	
			case ElektroSim.Orientation.NONE:
				imageSurface = new Cairo.ImageSurface (Cairo.Format.ARGB32, 1,1);
				break;
		}		
		imageContext=new Cairo.Context(imageSurface);
		imageContext.set_source_rgb (3, 3, 3);
		imageContext.set_line_width (3);
		imageContext.select_font_face ("Adventure", Cairo.FontSlant.NORMAL, Cairo.FontWeight.BOLD);
		
		emoticonSurface = new Cairo.ImageSurface (Cairo.Format.ARGB32, 110, 110);
		emoticonContext=new Cairo.Context(emoticonSurface);
		
	}
	
	protected void addParameterWidget(string parameter,string parameterValue, out Label label,out Entry entry){
		Box box;
		box= new Box(Gtk.Orientation.HORIZONTAL,0);
		box.set_can_focus(false);
		label= new Label.with_mnemonic (parameter+":");
		label.set_can_focus(false);
		label.selectable=false;
		box.add(label);
		entry= new Entry();
		entry.set_text (parameterValue);
		entry.set_width_chars(5);
		box.add(entry);
		grid.add(box);
	}

	public virtual Component clone(Component component){
			return component;
	}
	
	public abstract void snap(int range,int x, int y);

	public void update_emoticon(){
		
		emoticonContext=new Cairo.Context(emoticonSurface);
		
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
        	emoticonContext.new_path ();
        	emoticonContext.scale (1.5, 1.5);
        	handle.render_cairo( emoticonContext );
        	emoticonContext.close_path();
        	
        	}
		}
	}
	public virtual void update_image(){
	}
	public virtual void make_image(){
	
	}
	
	public virtual void clearCounter(){
	}
	
	public virtual string getNetlistLine(){
		return "";
	}
	
	public virtual void insertSimulationData(DataPair pair){
		if(pair.dataName=="i"){
			i=double.parse(pair.dataValue);
			stdout.printf ("inserted i= '%f'\n", i);
		}
		else if(pair.dataName=="p"){
			p=double.parse(pair.dataValue);
			stdout.printf ("inserted p= '%f'\n", p);
		}
		
	}


	
}

}
