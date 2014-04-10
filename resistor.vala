/* -*- Mode: vala; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/*
 * resistor.vala
 * Copyright (C) 2014 Steven Vanden Branden <StevenVandenBrandenstift@gmail.com>
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
	
public class Resistor : Component {

	public static int counter=0;
	public double resistance{get;set;default=0;}
	public string resistanceUnit{get;set;default="";}
	public double maxPower{get;set;default=100;}
	//extra return values from simulation
	public double ac{get;set;default=0;}
	public double dtemp{get;set;default=0;}  
	public double bv_max{get;set;default=0;}  
	public double noisy{get;set;default=0;}
	private Label resLabel;
	private Entry resEntry;
	private Label maxPowerLabel;
	private Entry maxPowerEntry;
	
	// Constructor
	public Resistor (double resistance,double maxPower) {
		base("Resistor");
		this.width=250;
		this.height=50;
		addParameterWidget("R","5",out resLabel,out resEntry);
		addParameterWidget("Max Power","1",out maxPowerLabel, out maxPowerEntry);
		this.resistance=resistance;
		this.maxPower=maxPower;

	}
	
	public override void update_image(){
	
	}
	
	public override void make_image(){
		
		setupSurface(orientation);
		
		imageContext.new_path ();	
		imageContext.move_to (0, height/2);
		imageContext.line_to (width/5, height/2);
		imageContext.rectangle (width/5,0,width/5*3,height);
		imageContext.close_path ();
		imageContext.stroke ();
		
		imageContext.new_path ();
		imageContext.move_to (width*4/5, height/2);
		imageContext.line_to (width, height/2);
		imageContext.close_path ();
		imageContext.stroke ();
		
		imageContext.new_path ();
		imageContext.set_font_size (height*0.9);
		imageContext.move_to (width/5+5,height/1.2);
		imageContext.text_path (name);
		imageContext.close_path();
		imageContext.fill();

	}
	
	public override void clearCounter(){
	counter=0;
	}
	
	public override Component clone(Component component,int x ,int y){
		Resistor newc=new Resistor(double.parse(resEntry.get_text ()),double.parse(maxPowerEntry.get_text ()));
		counter++;
		newc.name="r"+counter.to_string();
		return newc;
	}

	public override void snap(int range,int x, int y){
		Point point,point2;
		point=new Point(x,y);
		point=point.pointNearby(range);
		connections.add(point);
		orientation=point.connectComponent(this);
		if(orientation==ElektroSim.Orientation.RIGHT){
			point2=new Point(point.x+width,point.y);
		} else if (orientation==ElektroSim.Orientation.LEFT){
		 	point2=new Point(point.x-width,point.y);
		}else{
		point2=new Point(point.x-width,point.y);
		}
		point2=point2.pointNearby(range);
		connections.add(point2);
		point2.connectComponent(this);
		
	}
	public override void insertSimulationData(string dataLine){
		DataPair pair=lineToDataPair(dataLine);
		string name=pair.dataName;
		string data=pair.dataValue;
		if(name=="activity"){
			if(data.contains("inactive")){
				activity=Activity.INACTIVE;
			}else if(data.contains("subactive")){
				activity=Activity.SUBACTIVE;
			}else if(data.contains("overactive")){
				activity=Activity.OVERACTIVE;
			}else if(data.contains("active")){
				activity=Activity.ACTIVE;
			}else {
				activity=Activity.UNKNOWN;
			}
			stdout.printf ("inserted activity= '%i'\n", activity);
		}else if(name=="work_zone"){
			if(data.contains("suboptimal")){
				zone=Zone.SUBOPTIMAL;
			}else if(data.contains("optimal")){
				zone=Zone.OPTIMAL;
			}else if(data.contains("outofrange")){
				zone=Zone.OUTOFRANGE;
			}else if(data.contains("destructive")){
				zone=Zone.DESTRUCTIVE;
			}else {
				zone=Zone.UNKNOWN;
			}
			stdout.printf ("inserted zone= '%i'\n", zone);
		}else if(name=="i"){
			i=double.parse(data);
			stdout.printf ("inserted i= '%f'\n", i);
		}
		else if(name=="p"){
			p=double.parse(data);
			stdout.printf ("inserted p= '%f'\n", p);
		}
		

		
	}

	public override string getNetlistLine(){
		string line;
		line=name+" "+connections[0].net.to_string()+" "+connections[1].net.to_string()+" "+resistance.to_string()+resistanceUnit+" max_power="+maxPower.to_string()+"\n";
		return line;
	}
}

}
