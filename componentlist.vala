using Gtk;
using Gee;
namespace ElektroSim{
	


public class ComponentList  {
	
	public enum Mode{
		UNKNOWN,EDIT,SIMULATION;
	}

	public ListBox list{get;set;}
	private Mode mode{get;set;default=Mode.EDIT;}
	private Component.ComponentType compType{get;set;default=Component.ComponentType.TEMPLATE;}
	public signal void selected_values_description_changed(string name);
	public signal void request_simulation();
	public signal void request_redraw();
	public signal void request_graph_redraw();	
	private Timer timer ;
	private bool timer_running;
	private uint timerID;

	public ComponentList()
	{	
		this.list=new ListBox();
		timer=new Timer();
		list.width_request=50;
		timer_running=false;
	}
	
	public Component get_selected_component(){
		return (list.get_selected_row() as Component);
	}
	
	public void invalidate_values(){
		GLib.List<weak Widget> tl =this.list.get_children();
		foreach(Widget comp in tl){
				(comp as Component).invalidate_values();
			}
	}

	public bool timer_delay(){
		Source.remove (timerID);
		invalidate_values();
		request_simulation();
		timer_running=false;
		return true;
	}
	public void add_component(Component comp){
		
		comp.set_mode(mode);
		if(comp.componentType==compType){
			comp.set_no_show_all(false);
		}else{
			comp.set_no_show_all(true);
			comp.hide();
		}
		comp.request_redraw.connect (() => {
   					request_redraw();
			});
		comp.request_simulate.connect (() => {
					if(timerID!=0)
					Source.remove (timerID);
					timerID = Timeout.add (3000, timer_delay);
			});
		comp.request_graph_redraw.connect (() => {
   					request_graph_redraw();
			});
		this.list.add(comp);
		this.list.show_all();
	}

	public ArrayList<Component> get_components(Component.ComponentType type2){
			
			GLib.List<weak Widget> tl =this.list.get_children();
			ArrayList<Component> temp=new ArrayList<Component>();
			foreach(Widget comp in tl){
				if((comp as Component).componentType==type2)
					temp.add((Component)comp);
			}
		return temp;
	}
	
	public void print_list(){
		GLib.List<weak Widget> templist=list.get_children();
			foreach(weak Widget comp in templist){
				print("list print component %s\n",(comp as Component).name);
				foreach(Parameter par in (comp as Component).parameters){
					if(par.values!=null&&par.values.size!=0){
						print("parameter %s: \n",par.name);
						foreach(double val in par.values){
							print("%f\t",val);
						}
					}else{
						print("parameter %s,%f\n",par.name,par.val);
					}				
				}
			}
	}
	

	public void clear(){
		GLib.List<weak Widget> templist=list.get_children();
			foreach(weak Widget comp in templist){
				if((comp as Component).componentType!=Component.ComponentType.TEMPLATE)
					this.list.remove(comp);
				else
					(comp as Component).clear_counter();		
			}
		Point.clear();
		set_visable(Component.ComponentType.TEMPLATE);
		set_modus(mode.EDIT);
		request_redraw();
	}
	
	public ArrayList<double?> get_selected_values(bool next){
		//print_list();
		Parameter par;
		if(get_selected_component()!=null){
			if(next)
			par=get_selected_component().get_next_parameter();
			else
			par=get_selected_component().get_selected_parameter();
			if(par!=null&&par.name!=null){
			selected_values_description_changed(get_selected_component().name+" : "+par.name);
			return par.values;
			}
		}
		return null;
	}
	
	public ArrayList<double?> get_time_values(){

		GLib.List<weak Widget> tl =this.list.get_children();
			foreach(Widget comp in tl){
				if((comp as Component).componentType==Component.ComponentType.SIMULATION)
					return (comp as Component).get_parameter("time").values;
			}
		print("WARN returned 0 time");
		return new ArrayList<double?>();
	}

	public void fill_templates(){
		Resistor resistor=new Resistor(5,1);
		resistor.componentType=Component.ComponentType.TEMPLATE;
		add_component(resistor);

		PowerSource power_source=new PowerSource(PowerSource.Type.DC);
		power_source.componentType=Component.ComponentType.TEMPLATE;
		add_component(power_source);
		
		
		Ground ground=new Ground();
		ground.componentType=Component.ComponentType.TEMPLATE;		
		add_component(ground);
		
		Line line= new Line();
		line.componentType=Component.ComponentType.TEMPLATE;
		add_component(line);
		
		Simulation sim=new Simulation(Simulation.Type.TRAN);
		sim.componentType=Component.ComponentType.TEMPLATE;
		add_component(sim);
        
	}

	public void set_visable(Component.ComponentType type2){
		this.compType=type2;
		GLib.List<weak Widget> templist=list.get_children();
		foreach(Widget comp in templist){
				if((comp as Component).componentType==compType||(comp as Component).componentType==Component.ComponentType.SIMULATION){
					comp.set_no_show_all(false);
				  }
				else{
					comp.set_no_show_all(true);
					comp.hide();		
				}					
		}
		this.list.show_all();
	}

	
	public void  set_modus(Mode modus){
		this.mode=modus;
		GLib.List<weak Widget> templist=list.get_children();
		foreach( Widget comp in templist){
			(comp as Component).set_mode(mode);	
		}
	}

	public void set_mode_simulation(){
		set_modus(Mode.SIMULATION);
		set_visable(Component.ComponentType.COMPONENT);
		request_simulation();
	}
}
}