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
using Gee;
namespace ElektroSim{
	
public class PowerSource : Component {

	public static int counter;
	private ArrayList<Parameter> optionsAdded;
	private ArrayList<Parameter> randomOptionsAdded;

	public enum Type{
		DC,DCAC,SINUS,PULSE,EXPO,SFFM,AM,RANDOM,TRANSNOISE,PWLINEAR;
		//TRANSNOISE is still experimental
		//PWLINEAR is only usefull if we can import the data, manual entering would be too much off a hastle
	}
	
	public enum RandomType{
		UNIFORM,GAUSSIAN,EXPONENTIAL,POISSON;
	}

	public PowerSource (int option) {
			base("PowerSource");
			this.width=100;
			this.height=50;
			ArrayList<string> temp=new ArrayList<string>();
			temp.add("dc");
			temp.add("dc/ac");
			temp.add("sinus");
			temp.add("pulse");
			temp.add("expo");
			temp.add("1 freq FM");
			temp.add("amplitude modulation");
			temp.add("random");
			Parameter type=add_parameter("type",option,Parameter.WidgetStyle.OPTIONS,Parameter.WidgetStyle.OPTIONS,temp);
			type.optionsMethod=change_type;
			optionsAdded=new ArrayList<Parameter>();
			randomOptionsAdded=new ArrayList<Parameter>();
			change_type(option);
	}
	
		public override void draw_image(Cairo.Context cr){
		
		int p1_x = connections[0].x;
		int p1_y = connections[0].y;

		cr.new_path ();
		cr.move_to (p1_x, p1_y);
		if(orientation==Component.Orientation.RIGHT){
		cr.rel_line_to (width,0);
		}else if(orientation==Component.Orientation.LEFT){
		cr.rel_line_to (-width,0);
		}else if(orientation==Component.Orientation.UP){
		cr.rel_line_to (0,-width);
		}else{
		cr.rel_line_to (0,width);
		}
		cr.close_path ();
		cr.stroke ();
		
		cr.new_path ();
		cr.set_font_size (height*0.4);
		
		if(orientation==Component.Orientation.RIGHT){
		cr.move_to (p1_x+width*0.65,p1_y-5);
		}else if(orientation==Component.Orientation.LEFT){
		cr.move_to (p1_x-width,p1_y-5);
		}else if(orientation==Component.Orientation.UP){
		cr.move_to (p1_x+5,p1_y-width*0.8);
		}else if(orientation==Component.Orientation.DOWN){
		cr.move_to (p1_x+5,p1_y+width*0.9);
		}
		
		cr.text_path (name);
		cr.fill();
		cr.close_path ();
	
	}
	
	public void reset_options(){
		foreach(Parameter par in optionsAdded){
			grid.remove((par as Widget));
			parameters.remove(par);
		}
		optionsAdded=new ArrayList<Parameter>();
		reset_random_options();
	}

	public void reset_random_options(){
		foreach(Parameter par in randomOptionsAdded){
			grid.remove((par as Widget));
			parameters.remove(par);
		}
		randomOptionsAdded=new ArrayList<Parameter>();
	}

	public void change_random_type(int option){
		print("change to subtype '%i'\n",option);
		reset_random_options();
		get_parameter("random type").val=option;

	switch(option){
		case(RandomType.UNIFORM):
				Parameter range=add_parameter("range",1,Parameter.WidgetStyle.ENTRY,Parameter.WidgetStyle.ENTRY);
				Parameter offset=add_parameter("offset",0,Parameter.WidgetStyle.ENTRY,Parameter.WidgetStyle.ENTRY);
				randomOptionsAdded.add(range);
				randomOptionsAdded.add(offset);
				break;
		case(RandomType.GAUSSIAN):
			Parameter standardDev=add_parameter("standard dev",1,Parameter.WidgetStyle.ENTRY,Parameter.WidgetStyle.ENTRY);
				Parameter mean=add_parameter("mean",0,Parameter.WidgetStyle.ENTRY,Parameter.WidgetStyle.ENTRY);
				randomOptionsAdded.add(standardDev);
				randomOptionsAdded.add(mean);
				break;
		case(RandomType.EXPONENTIAL):
				Parameter mean=add_parameter("mean",1,Parameter.WidgetStyle.ENTRY,Parameter.WidgetStyle.ENTRY);
				Parameter offset=add_parameter("offset",0,Parameter.WidgetStyle.ENTRY,Parameter.WidgetStyle.ENTRY);
				randomOptionsAdded.add(mean);
				randomOptionsAdded.add(offset);
				break;
		case(RandomType.POISSON):
				Parameter lambda=add_parameter("lambda",1,Parameter.WidgetStyle.ENTRY,Parameter.WidgetStyle.ENTRY);
				Parameter offset=add_parameter("offset",0,Parameter.WidgetStyle.ENTRY,Parameter.WidgetStyle.ENTRY);
				randomOptionsAdded.add(lambda);
				randomOptionsAdded.add(offset);
				break;

		}
		set_mode(ComponentList.Mode.EDIT);
		show_all();
	}   

	public void change_type(int option){
		print("change to type '%i'\n",option);
		reset_options();
		get_parameter("type").val=option;

		switch(option){
			case(Type.DC):
				Parameter voltage=add_parameter("voltage",1,Parameter.WidgetStyle.ENTRY,Parameter.WidgetStyle.SLIDER);
				optionsAdded.add(voltage);
				break;
			case(Type.DCAC):
				Parameter dcVoltage=add_parameter("dc voltage",1,Parameter.WidgetStyle.ENTRY,Parameter.WidgetStyle.SLIDER);
				Parameter acVoltage=add_parameter("ac voltage",1,Parameter.WidgetStyle.ENTRY,Parameter.WidgetStyle.SLIDER);
				optionsAdded.add(dcVoltage);
				optionsAdded.add(acVoltage);
				break;
			case(Type.SINUS):
				Parameter step=add_parameter("offset",0,Parameter.WidgetStyle.ENTRY,Parameter.WidgetStyle.ENTRY);
				Parameter amplitude=add_parameter("amplitude",1,Parameter.WidgetStyle.ENTRY,Parameter.WidgetStyle.ENTRY);
				Parameter frequency=add_parameter("frequency",10,Parameter.WidgetStyle.ENTRY,Parameter.WidgetStyle.ENTRY);
				Parameter delay=add_parameter("delay",0,Parameter.WidgetStyle.ENTRY,Parameter.WidgetStyle.ENTRY);
				Parameter damping=add_parameter("damping",0,Parameter.WidgetStyle.ENTRY,Parameter.WidgetStyle.ENTRY);
				optionsAdded.add(step);
				optionsAdded.add(amplitude);
				optionsAdded.add(frequency);
				optionsAdded.add(delay);
				optionsAdded.add(damping);
				break;
			case(Type.PULSE):
				Parameter initial=add_parameter("initial value",-1,Parameter.WidgetStyle.ENTRY,Parameter.WidgetStyle.ENTRY);
				Parameter pulsed=add_parameter("pulsed value",1,Parameter.WidgetStyle.ENTRY,Parameter.WidgetStyle.ENTRY);
				Parameter delay=add_parameter("delay time",double.parse("2e-9"),Parameter.WidgetStyle.ENTRY,Parameter.WidgetStyle.ENTRY);
				Parameter rise=add_parameter("rise time",double.parse("2e-9"),Parameter.WidgetStyle.ENTRY,Parameter.WidgetStyle.ENTRY);
				Parameter fall=add_parameter("fall time",double.parse("2e-9"),Parameter.WidgetStyle.ENTRY,Parameter.WidgetStyle.ENTRY);
				Parameter pulse=add_parameter("pulse width",double.parse("50e-9"),Parameter.WidgetStyle.ENTRY,Parameter.WidgetStyle.ENTRY);
				Parameter period=add_parameter("period",double.parse("100e-9"),Parameter.WidgetStyle.ENTRY,Parameter.WidgetStyle.ENTRY);
				optionsAdded.add(initial);
				optionsAdded.add(pulsed);
				optionsAdded.add(delay);
				optionsAdded.add(rise);
				optionsAdded.add(fall);
				optionsAdded.add(pulse);
				optionsAdded.add(period);
				break;
			case(Type.EXPO):
				Parameter initial=add_parameter("initial value",-4,Parameter.WidgetStyle.ENTRY,Parameter.WidgetStyle.ENTRY);
				Parameter pulsed=add_parameter("pulsed value",-1,Parameter.WidgetStyle.ENTRY,Parameter.WidgetStyle.ENTRY);
				Parameter riseDelay=add_parameter("rise delay time",double.parse("2e-9"),Parameter.WidgetStyle.ENTRY,Parameter.WidgetStyle.ENTRY);
				Parameter riseConstant=add_parameter("rise time",double.parse("30e-9"),Parameter.WidgetStyle.ENTRY,Parameter.WidgetStyle.ENTRY);
				Parameter fallDelay=add_parameter("fall delay time",double.parse("60e-9"),Parameter.WidgetStyle.ENTRY,Parameter.WidgetStyle.ENTRY);
				Parameter fallConstant=add_parameter("fall time",double.parse("40e-9"),Parameter.WidgetStyle.ENTRY,Parameter.WidgetStyle.ENTRY);
				optionsAdded.add(initial);
				optionsAdded.add(pulsed);
				optionsAdded.add(riseDelay);
				optionsAdded.add(riseConstant);
				optionsAdded.add(fallDelay);
				optionsAdded.add(fallConstant);
				break;
			case(Type.SFFM):
				Parameter offset=add_parameter("offset",0,Parameter.WidgetStyle.ENTRY,Parameter.WidgetStyle.ENTRY);
				Parameter amplitude=add_parameter("amplitude",double.parse("1e6"),Parameter.WidgetStyle.ENTRY,Parameter.WidgetStyle.ENTRY);
				Parameter carrierFreq=add_parameter("carrier frequency",double.parse("20e3"),Parameter.WidgetStyle.ENTRY,Parameter.WidgetStyle.ENTRY);
				Parameter modulationIndex=add_parameter("modulation index",double.parse("5"),Parameter.WidgetStyle.ENTRY,Parameter.WidgetStyle.ENTRY);
				Parameter signalFreq=add_parameter("signal frequency",double.parse("1e3"),Parameter.WidgetStyle.ENTRY,Parameter.WidgetStyle.ENTRY);
				optionsAdded.add(offset);
				optionsAdded.add(amplitude);
				optionsAdded.add(carrierFreq);
				optionsAdded.add(modulationIndex);
				optionsAdded.add(signalFreq);
				break;
			case(Type.AM):
				Parameter amplitude=add_parameter("amplitude",0.5,Parameter.WidgetStyle.ENTRY,Parameter.WidgetStyle.ENTRY);
				Parameter offset=add_parameter("offset",1,Parameter.WidgetStyle.ENTRY,Parameter.WidgetStyle.ENTRY);
				Parameter modulatingFreq=add_parameter("modulating frequency",double.parse("20e3"),Parameter.WidgetStyle.ENTRY,Parameter.WidgetStyle.ENTRY);
				Parameter carrierFreq=add_parameter("carrier frequency",double.parse("1e9"),Parameter.WidgetStyle.ENTRY,Parameter.WidgetStyle.ENTRY);
				Parameter signalDelay=add_parameter("signal delay",double.parse("1e-3"),Parameter.WidgetStyle.ENTRY,Parameter.WidgetStyle.ENTRY);
				optionsAdded.add(amplitude);
				optionsAdded.add(offset);
				optionsAdded.add(modulatingFreq);
				optionsAdded.add(carrierFreq);
				optionsAdded.add(signalDelay);
				break;
			case(Type.RANDOM):
				ArrayList<string> types=new ArrayList<string>();
				types.add("uniform");
				types.add("gaussian");
				types.add("exponential");
				types.add("poisson");
				Parameter randomType=add_parameter("random type",0,Parameter.WidgetStyle.OPTIONS,Parameter.WidgetStyle.OPTIONS,types);
				Parameter duration=add_parameter("duration",double.parse("10e-3"),Parameter.WidgetStyle.ENTRY,Parameter.WidgetStyle.ENTRY);
				Parameter timeDelay=add_parameter("time delay",double.parse("0"),Parameter.WidgetStyle.ENTRY,Parameter.WidgetStyle.ENTRY);
				optionsAdded.add(randomType);
				optionsAdded.add(duration);
				optionsAdded.add(timeDelay);
				randomType.optionsMethod=change_random_type;
				change_random_type(RandomType.UNIFORM);
				break;
		}
		set_mode(ComponentList.Mode.EDIT);
		show_all();
	}
	
	public override void clear_counter(){
	counter=0;
	}
	
	public override Component clone(){
			PowerSource newc=new PowerSource((int)get_parameter("type").val);
			counter++;
			newc.set_name("v"+counter.to_string());
			newc.componentType=Component.ComponentType.COMPONENT;


			foreach(Parameter par in parameters){
				newc.get_parameter(par.name).val=par.val;
						}
			return newc;
	}

	public override void snap(int range,int x, int y){
		Point point;
		point=new Point(x,y);
		point=point.point_nearby(range);
		orientation=point.connect_component(this);
		connections.add(point);
	}

	public override string get_netlist_line(){
		string line;
		line=name+" "+connections[0].net.to_string()+" 0 ";
		switch((int)get_parameter("type").val){
			case(Type.DC):
				line+="dc "+get_parameter("voltage").val.to_string();
				break;
			case(Type.DCAC):
				line+="dc "+get_parameter("dc voltage").val.to_string()+"ac "+get_parameter("ac voltage").val.to_string();
				break;
			case(Type.SINUS):
				line+="sin("+get_parameter("offset").val.to_string()+" "+get_parameter("amplitude").val.to_string()+" "+get_parameter("frequency").val.to_string()+" "+get_parameter("delay").val.to_string()+" "+get_parameter("damping").val.to_string()+")";
				break;
			case(Type.PULSE):
				line+="pulse( "+get_parameter("initial value").val.to_string()+" "+get_parameter("pulsed value").val.to_string()+" "+get_parameter("delay time").val.to_string()+" "+get_parameter("rise time").val.to_string()+" "+get_parameter("fall time").val.to_string()+" "+get_parameter("pulse width").val.to_string()+" "+get_parameter("period").val.to_string()+")";
				break;
			case(Type.EXPO):
				line+="exp( "+get_parameter("initial value").val.to_string()+" "+get_parameter("pulsed value").val.to_string()+" "+get_parameter("rise delay time").val.to_string()+" "+get_parameter("rise time").val.to_string()+" "+get_parameter("fall delay time").val.to_string()+" "+get_parameter("fall time").val.to_string()+" "+get_parameter("period").val.to_string()+")";
				break;
			case(Type.SFFM):
				line+="sffm( "+get_parameter("offset").val.to_string()+" "+get_parameter("amplitude").val.to_string()+" "+get_parameter("carrier frequency").val.to_string()+" "+get_parameter("modulation index").val.to_string()+" "+get_parameter("signal frequency").val.to_string()+")";
				break;
			case(Type.AM):
				line+="am("+get_parameter("amplitude").val.to_string()+" "+get_parameter("offset").val.to_string()+" "+get_parameter("modulating frequency").val.to_string()+" "+get_parameter("carrier frequency").val.to_string()+" "+get_parameter("signal delay").val.to_string()+")";
				break;
			case(Type.RANDOM):
				line+="trrandom("+get_parameter("random type").val.to_string()+" "+get_parameter("duration").val.to_string()+" "+get_parameter("time delay").val.to_string()+" ";
					
					switch((int)get_parameter("random type").val){
							case(RandomType.UNIFORM):
									line+=get_parameter("range").val.to_string()+" "+get_parameter("offset").val.to_string();
									break;
							case(RandomType.GAUSSIAN):
									line+=get_parameter("standard dev").val.to_string()+" "+get_parameter("mean").val.to_string();
									break;
							case(RandomType.EXPONENTIAL):
									line+=get_parameter("mean").val.to_string()+" "+get_parameter("offset").val.to_string();
									break;
							case(RandomType.POISSON):
									line+=get_parameter("lambda").val.to_string()+" "+get_parameter("offset").val.to_string();
									break;
					}
				
				line+=")";
				break;
		}
		line+="\n";
		return line;
	}

}
}
