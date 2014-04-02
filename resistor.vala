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
 //using Rsvg;
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
		base("resistor");
		addParameterWidget("R","5",out resLabel,out resEntry);
		addParameterWidget("Max Power","1",out maxPowerLabel, out maxPowerEntry);
		this.width=250;
		this.resistance=resistance;
		this.maxPower=maxPower;
	}

	public override void draw_symbol(Cairo.Context context){
		context.save();
		context.new_path ();
		context.set_source_rgb (3, 3, 3);
		context.rectangle (connections.nth_data(0).x,connections.nth_data(0).y,this.width/5,2);
		context.rectangle (connections.nth_data(0).x+this.width/5,connections.nth_data(0).y-this.width/10,(this.width/5)*3,this.width/5);
		context.rectangle (connections.nth_data(1).x-(this.width/5),connections.nth_data(1).y,this.width/5,2);
		
		
		context.close_path ();
		context.stroke ();
		
		context.new_path ();
		context.set_source_rgb (3, 3, 3);
		context.select_font_face ("Adventure", Cairo.FontSlant.NORMAL, Cairo.FontWeight.BOLD);
		context.set_font_size (20);
		context.move_to (connections.nth_data(0).x+this.width/5+5,connections.nth_data(0).y);
		context.text_path (name);
		context.close_path();
		context.fill();
		
		/*
		contect.new_patch();
		Handle handle;
        try {
            handle = new Handle.from_file("./svg.svg");
        } catch( Error e ) {
            stderr.printf( "can not open svg file\n" );
            return;
        }
        
        handle.render_cairo( context );
        context.close_path();
    	*/
		
	}
	public override Component clone(Component component,int x ,int y){
		Resistor newc=new Resistor(double.parse(resEntry.get_text ()),double.parse(maxPowerEntry.get_text ()));
		counter++;
		newc.name="r"+counter.to_string();
		newc.connections.append (new Point(x,y));
		newc.connections.append(new Point(x+width,y));
		return newc;
	}

	public override int snap(List<Component> list,int range,int netCount){
		if(connections.nth_data(0).pointNearby(range,list)){
			connections.nth_data(1).x=connections.nth_data (0).x+width;
			connections.nth_data(1).y=connections.nth_data(0).y;
			netCount=connections.nth_data(1).checkNetName(netCount);
			return netCount;
		}
		else{
			netCount=connections.nth_data(0).checkNetName(netCount);
			netCount=connections.nth_data(1).checkNetName(netCount);
			return netCount;
		}


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
			stdout.printf ("inserted i= '%f'\n", p);
		}
		

		
	}

	public override string getNetlistLine(){
		string line;
		line=name+" "+connections.nth_data(0).net.to_string()+" "+connections.nth_data(1).net.to_string()+" "+resistance.to_string()+resistanceUnit+" max_power="+maxPower.to_string()+"\n";
		return line;
	}
}

}
