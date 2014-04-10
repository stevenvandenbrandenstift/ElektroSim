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
	
	public double i{get;set;default=0;}
	public double p{get;set;default=0;}	
	public Activity activity{get;set;default=Activity.UNKNOWN;}
	public Zone zone{get;set;default=Zone.UNKNOWN;}
	private Label label;
	public List<Point> connections;
	public Point topLeft;
	private Box grid;
	public Cairo.Surface imageSurface;
	public Cairo.Context imageContext;
	public Cairo.Surface emoticonSurface;
	public Cairo.Context emoticonContext;
	
	public Orientation orientation{get;set;default=ElektroSim.Orientation.NONE;}

	public Component(string name){
		this.name=name;
		grid = new Box (Gtk.Orientation.VERTICAL,0);
		grid.set_can_focus(false);
		label= new Label (name);
		grid.add(label);
		(this as ListBoxRow).add(grid);
		connections=new List<Point>();
		

	}
	
	protected void setupSurface(){
		imageSurface = new Cairo.ImageSurface (Cairo.Format.ARGB32, width, height);
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

	public abstract Component clone(Component component, int x, int y);
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
	public abstract void update_image();
	public abstract void make_image();
	
	public abstract void clearCounter();
	
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
