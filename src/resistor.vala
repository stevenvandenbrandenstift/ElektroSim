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
public class Resistor : Component {

	public static int counter=0;
	public float resistance{get;set;default=0;}
	public string resistanceUnit{get;set;default="";}
	//extra return values from simulation
	public float ac{get;set;default=0;}
	public float dtemp{get;set;default=0;}  
	public float bv_max{get;set;default=0;}  
	public float noisy{get;set;default=0;}
	public float i{get;set;default=0;}
	public float p{get;set;default=0;}  

	// Constructor
	public Resistor (float restistance) {
		base("resistor");
		this.width=250;
		this.resistance=restistance;
	}

	public override void draw_symbol(Cairo.Context context){
		context.new_path ();
		context.set_source_rgb (3, 3, 3);
		context.rectangle (connections.nth_data(0).x,connections.nth_data(0).y,this.width/5,2);
		context.rectangle (connections.nth_data(0).x+this.width/5,connections.nth_data(0).y-this.width/10,(this.width/5)*3,this.width/5);
		context.rectangle (connections.nth_data(1).x-(this.width/5),connections.nth_data(1).y,this.width/5,2);
		context.stroke ();
		context.close_path ();
	}
	public override Component clone(Component component,int x ,int y){
		Resistor newc=new Resistor((component as Resistor).resistance);
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
	public override void insertSimulationData(string data){
		print("%s\n",data);
		string[] splitData= data.split_set ("\t ");
		foreach(string line in splitData){
			print("%s\n",line);
		}
	}

	public override string getNetlistLine(){
		string line;
		line=name+" "+connections.nth_data(0).net.to_string()+" "+connections.nth_data(1).net.to_string()+" "+resistance.to_string()+resistanceUnit+"\n";
		return line;
	}
}

