/* -*- Mode: vala; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/*
 * ground.vala
 * Copyright (C) 2014 Steven Vanden Branden <Stevenvandenbrandenstift@gmail.com>
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
	
public class PowerSource : Component {

	public static int counter;
	public double voltage{get;set;default=0;}
	public string voltageUnit{get;set;default="";}
	private Label voltageLabel;
	private Entry voltageEntry;

	public PowerSource (double voltage) {
			base("PowerSource");
			addParameterWidget("V","10",out voltageLabel,out voltageEntry);
			this.width=100;
			this.height=50;
			this.voltage=voltage;

	}

	public override void update_image(){
		
	}
	
	public override void make_image(){
		
		orientation=connections[0].GetComponentConnection(this);
		setupSurface(orientation);
		
		imageContext.new_path ();
		imageContext.move_to (0, height/2);
		imageContext.line_to (width, height/2);
		imageContext.close_path ();
		imageContext.stroke ();
		
		imageContext.new_path ();
		imageContext.set_font_size (height*0.4);
		imageContext.move_to (0, height/2-5);
		imageContext.text_path (name);
		imageContext.fill();
		imageContext.close_path ();
	}
	
	public override void clearCounter(){
	counter=0;
	}
	
	public override Component clone(Component component,int x,int y){
			PowerSource newc=new PowerSource(double.parse(voltageEntry.get_text ()));
			counter++;
			newc.name="v"+counter.to_string();
			return newc;
	}

	public override void snap(int range,int x, int y){
		Point point;
		point=new Point(x,y);
		point=point.pointNearby(range);
		point.connectComponent(this);
		connections.add(point);
	}

	public override void insertSimulationData(string dataLine){
		DataPair pair=lineToDataPair(dataLine);
		string name=pair.dataName;
		string data=pair.dataValue;
		if(name=="i"){
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
		line=name+" "+connections[0].net.to_string()+" 0 "+voltage.to_string()+voltageUnit+"\n";
		return line;
	}

}
}
