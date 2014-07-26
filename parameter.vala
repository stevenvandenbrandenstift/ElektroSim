/* -*- Mode: vala; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/*
 * Parameter.vala
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

 


public class Parameter : Box{

	public enum WidgetStyle {
		NONE,LABEL,ENTRY,OPTIONS,SLIDER;
	}
		
	public enum Suffix {	
		FEMTO=-15,PICO=-12,NANO=-9,MICRO=-6,MILLI=-3,BASE=0,KILO=3,MEGA=6,GIGA=9,TERA=12;
		
		public string get_string ()
        {
                return ((EnumClass)typeof (Suffix).class_ref ()).get_value(this).value.to_string();
        }
	}

	public double val{get;set;}
	private double valBase;
	private int suffix;
	public string unit;
	public ArrayList<double?> values{get;set;}
	private ArrayList<Widget> edit{get;set;}
	private ArrayList<Widget> simulation{get;set;}
	private ArrayList<Widget> all{get;set;}
	private Label label;
	public ArrayList<string> options{get;set;}

	public string name{get;set;default="";}
	public bool invalidate_values{get;set;}

	public signal void updated();
	public signal void edited();

	public delegate void OptionsMethod(int option);
	private Mutex mutex;
	private Adjustment sliderValue;
	public OptionsMethod optionsMethod{get;set;}
	
	public Parameter(string name , double val,string unit=""){
		options=new ArrayList<string>();
		values=new ArrayList<double?>();
		edit=new ArrayList<Widget>();
		simulation=new ArrayList<Widget>();
		all=new ArrayList<Widget>();
		invalidate_values=false;
		mutex = new Mutex ();
		
		this.name=name;
		this.val=val;
		this.unit=unit;
		this.suffix=0;
		convert_val_to_base();
		//set_can_focus(false);	
		set_size_request(-1,-1);
		label= new Label (name);
		label.set_can_focus(false);
		label.width_chars=10;
		label.selectable=false;
		}
	
	public string to_string(){
		string line;
		line=name+": value "+val.to_string()+" \n values: \n";
		/*foreach(double val in values)
			line+=val.to_string()+" - ";
		line+="\n widgets in all:\n";
		foreach(Widget widget in all)
			line+=widget.name+" - ";
		line+="\n widgets in edit:\n";
		foreach(Widget widget in edit)
			line+=widget.name+" - ";
		line+="\n widgets in simulation:\n";
		foreach(Widget widget in simulation)
			line+=widget.name+" - ";
			line+="\n\n";*/
		return line;
	
	}

	private void convert_base_to_val(){
		val=valBase*Math.pow10((double)suffix);
	}
	private void convert_val_to_base(){
		debug("suffix:"+suffix.to_string());
		debug("baseval:"+valBase.to_string());
		debug("val:"+val.to_string());
		double exponent=0;
		double fraction=0;
		if(val!=0){
		exponent=Math.logb(val);
		fraction=val/(Math.pow10(exponent));
		}
		debug("fraction:"+fraction.to_string());
		debug("exponent:"+exponent.to_string());
		int residu=(int)Math.fmod(exponent,(double)3);
		debug("residu:"+exponent.to_string());
		if(residu!=0){
			//not dividable by 3
			if(exponent>0){
				exponent=exponent-residu;
				fraction*=Math.pow10((double)residu);
			}
			else{
				exponent+=residu;
				fraction*=Math.pow10(-(double)residu);
			}
		}
		suffix=(int)exponent;
		valBase=fraction;
		debug("suffix:"+suffix.to_string());
			debug("baseval:"+valBase.to_string());
			debug("val:"+val.to_string());
	}

	public void set_mode(ComponentList.Mode mode){

		switch(mode){
		
		case ComponentList.Mode.EDIT:
				fill_box(edit);
			break;
		
		case  ComponentList.Mode.SIMULATION:
				fill_box(simulation);
			break;
		}
	}

	private void clear_box(){
		GLib.List<weak Widget> widgets =this.get_children();
			foreach(Widget widget in widgets){
					this.remove(widget);
			}
	}

	private void fill_box(ArrayList<Widget> widgets){
		clear_box();
		foreach(Widget widget in widgets){
			this.add(widget);
		}
	}

	private void set_widgets_value(){
			GLib.List<weak Widget> widgets =this.get_children();
			foreach(Widget widget in widgets){
				if(widget is Label){
					if(!(widget as Label).get_text().contains(name))
						(widget as Label).set_label(val.to_string());
				}else if(widget is Entry)
					(widget as Entry).set_text(val.to_string());
				else if(widget is Scale){
					(widget as Scale).set_value(valBase);
				}
				
			}
	}

	public void set_simulation_array(WidgetStyle style){
			simulation=new ArrayList<Widget>();
			debug("setting simulation array of "+name);
			simulation=get_arraylist(style);
	}

	private ArrayList<Widget> get_arraylist(WidgetStyle style){
		Gee.ArrayList<Widget> temp= new Gee.ArrayList<Widget>();
		if(style!=WidgetStyle.NONE)
		temp.add(label);
		switch(style){

			case WidgetStyle.NONE:
				break;
			case WidgetStyle.LABEL:
				temp.add(get_widget(typeof(Label)));
				break;
			case WidgetStyle.ENTRY:
				temp.add(get_widget(typeof(Entry)));
				break;
			case WidgetStyle.SLIDER:
				temp.add(get_widget(typeof(Scale)));
				temp.add(make_suffix_options());
				break;
			case WidgetStyle.OPTIONS:
				temp.add(get_widget(typeof(ComboBoxText)));
				break;
		}
		return temp;	


	}

	private Widget get_widget(Type type){
			Type test=type;
			//debug("getwidget: type of widget "+type.name());
			//debug("getwidget: type of comboboxtext "+typeof(ComboBoxText).name());
			foreach(Widget widget in all){
				if(Type.from_instance(widget)==test){
					//debug(" found existing widget for "+name+" - val "+val.to_string());
					return widget;
				}
			}
			
			if(test==typeof(Label))
				return make_label();
			else if(test==typeof(Entry))
					return make_entry();
			else if(test==typeof(Scale))
					return make_scale();
			else if(test==typeof(ComboBoxText))
					return make_options();

		return new Label("not supported");
	}


	public void set_edit_array(WidgetStyle style){
			edit=new ArrayList<Widget>();
			//debug("setting edit array of "+name);
			edit=get_arraylist(style);
	}
	

	public void set_value(double temp){
		val=temp;
		set_widgets_value();
		updated();
	}
	
	public void add_value(double temp){
			if(invalidate_values){
				values=new ArrayList<double?>();
				invalidate_values=false;
			}
			values.add(temp);
			//set_widgets_value();
			//updated();
	}


	private Scale make_scale(){
		sliderValue= new Adjustment (valBase,  0.1,  100,  0.1,  0.1, 0);
		Scale scale=new Scale (Gtk.Orientation.HORIZONTAL,sliderValue);
		scale.set_has_origin (false);
		scale.set_hexpand(true);
		scale.set_value(val);
		//scale.set_update_policy(0);
		scale.value_changed.connect (()=>{
					mutex.lock();
					valBase=scale.get_value();
					convert_base_to_val();
					sliderValue.set_step_increment (0.1);
					debug("sliderchanged to value "+scale.get_value().to_string());
					edited();
					mutex.unlock();
		});
		all.add(scale);
		return scale;
	}
	private Entry make_entry(){
		Entry entry=new Entry();
		entry.set_width_chars(20);
		entry.set_hexpand(true);
		entry.set_text(val.to_string());
		entry.key_release_event.connect (()=>{
				val=double.parse(entry.get_text());
				edited();
				return true;
		});
		all.add(entry);
		return entry;
	}


	private Label make_label(){
		Label label= new Label (val.to_string());
		label.set_can_focus(false);
		label.width_chars=15;
		label.selectable=false;
		all.add(label);
		return label;
	}
	
	private ComboBoxText make_suffix_options(){
		ComboBoxText box = new ComboBoxText ();
		box.append(Suffix.GIGA.get_string(),"T"+unit);
		box.append(Suffix.GIGA.get_string(),"G"+unit);
		box.append(Suffix.MEGA.get_string(),"Meg"+unit);
		box.append(Suffix.KILO.get_string(),"K"+unit);
		box.append(Suffix.BASE.get_string(),unit);
		box.append(Suffix.MILLI.get_string(),"m"+unit);
		box.append(Suffix.MICRO.get_string(),"u"+unit);
		box.append(Suffix.NANO.get_string(),"n"+unit);
		box.append(Suffix.PICO.get_string(),"p"+unit);
		box.append(Suffix.FEMTO.get_string(),"f"+unit);
		box.set_active_id(suffix.to_string());
		box.changed.connect (() => {
			suffix = int.parse(box.get_active_id ());
			convert_base_to_val();
			edited();		
		});
		all.add(box);
		return box;
	}

	private ComboBoxText make_options(){
		ComboBoxText box = new ComboBoxText ();
		foreach(string str in options){
				box.append_text (str);
		}
		box.set_active((int)val);
		debug("val="+val.to_string());
		box.changed.connect (() => {
			int id = box.get_active ();
			if(optionsMethod!=null){
			debug("change command id "+id.to_string());
			optionsMethod(id);
			edited();
			}
			
		});
		all.add(box);
		return box;
	}
	
	}	
}
