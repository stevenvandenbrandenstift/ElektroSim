using Gtk;
using Gee;
namespace ElektroSim{
	
public enum Mode{
		UNKNOWN,EDIT,SIMULATION;
}

public class ComponentList  {

	public ListBox list{get;set;}
	private Mode mode{get;set;default=ElektroSim.Mode.EDIT;}
	private ComponentType compType{get;set;default=ElektroSim.ComponentType.TEMPLATE;}
	public signal void list_changed();
	public signal void selected_values_description_changed(string name);
		

	public ComponentList()
	{	
		this.list=new ListBox();
	}
	
	public Component get_selected_component(){
		return (list.get_selected_row() as Component);
	}
	
	public void add_component(Component comp){
		
		comp.set_mode(mode);
		if(comp.componentType==compType){
			comp.set_no_show_all(false);
		}else{
			comp.set_no_show_all(true);
		}
		this.list.add(comp);
		this.list.show_all();
	}

	public ArrayList<Component> get_components(ElektroSim.ComponentType type2){
			
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
				if((comp as Component).componentType!=ElektroSim.ComponentType.TEMPLATE)
					this.list.remove(comp);
				else
					(comp as Component).clear_counter();		
			}
		Point.clear();
		set_visable(ElektroSim.ComponentType.TEMPLATE);
		list_changed();
	}
	
	public ArrayList<double?> get_selected_values(){
		//print_list();
		Parameter par=get_selected_component().get_next_parameter();
		selected_values_description_changed(get_selected_component().name+" : "+par.name);
		return par.values;
	}
	
	public ArrayList<double?> get_time_values(){

		GLib.List<weak Widget> tl =this.list.get_children();
			foreach(Widget comp in tl){
				if((comp as Component).componentType==ElektroSim.ComponentType.SIMULATION)
					return (comp as Component).get_parameter("time").values;
			}
		print("WARN returned 0 time");
		return new ArrayList<double?>();
	}

	public void fill_templates(){
		Resistor resistor=new Resistor(5,1);
		resistor.componentType=ElektroSim.ComponentType.TEMPLATE;
		add_component(resistor);

		PowerSource power_source=new PowerSource("sin(0 1 1 0 0)");
		power_source.componentType=ElektroSim.ComponentType.TEMPLATE;
		add_component(power_source);
		
		
		Ground ground=new Ground();
		ground.componentType=ElektroSim.ComponentType.TEMPLATE;		
		add_component(ground);
		
		Line line= new Line();
		line.componentType=ElektroSim.ComponentType.TEMPLATE;
		add_component(line);
		
		Simulation sim=new Simulation("tran 0.02 1");
		sim.componentType=ElektroSim.ComponentType.TEMPLATE;
		add_component(sim);
	}

	public void set_visable(ElektroSim.ComponentType type2){
		this.compType=type2;
		GLib.List<weak Widget> templist=list.get_children();
		foreach(Widget comp in templist){
				if((comp as Component).componentType==compType){
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

	public void set_list_mode_simulation(){
		set_modus(ElektroSim.Mode.SIMULATION);
		set_visable(ElektroSim.ComponentType.COMPONENT);
		
	}
}
}
