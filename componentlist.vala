using Gtk;
using Gee;
namespace ElektroSim{
	
public class ComponentList  {

	public ListBox list{get;set;}
	private Visual vis{get;set;default=ElektroSim.Visual.EDITABLE;}
	private ComponentType compType{get;set;default=ElektroSim.ComponentType.TEMPLATE;}
	public signal void list_changed();
		

	public ComponentList()
	{	
		this.list=new ListBox();
	}
	
	public Component get_selected_component(){
		return (list.get_selected_row() as Component);
	}
	
	public void add_component(Component comp){
		comp.pack_parameters();
		comp.set_display_parameter(vis);
		if(comp.componentType==compType)
			comp.set_no_show_all(false);
		else
			comp.set_no_show_all(true);


		this.list.add(comp);
		list.show_all();
	}

	public ArrayList<Component> get_components(ElektroSim.ComponentType type){
			GLib.List<weak Widget> tl =this.list.get_children();
			ArrayList<Component> temp=new ArrayList<Component>();
			foreach(Widget comp in tl){
				if((comp as Component).componentType==type)
					temp.add((Component)comp);
			}
		return temp;
	}
	
	public void print_list(){
		GLib.List<weak Widget> templist=list.get_children();
			foreach(weak Widget comp in templist){
				print("list print component %s\n",(comp as Component).name);
				foreach(Parameter par in (comp as Component).parameters)
					print("parameter %s,%f\n",par.name,par.val);
			}
	}
	/*
	public void graph_clicked(){
		graph.set_values((list.get_selected_row() as Component).get_parameter("i").values);
		GLib.List<Widget> templist=list.get_children();
			foreach(Widget comp in templist){
				if((comp as Component).name=="Simulation"){
					graph.set_timepoints((comp as Component).get_parameter("time").values);
				}
			}
	}*/
	

	public void clear(){
		GLib.List<weak Widget> templist=list.get_children();
			foreach(weak Widget comp in templist){
				if((comp as Component).componentType!=ElektroSim.ComponentType.TEMPLATE)
					this.list.remove(comp);
				else
					(comp as Component).clear_counter();		
			}
		Point.clear();
		list_changed();
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

		set_visable(ElektroSim.ComponentType.TEMPLATE);
	}

	public void set_visable(ElektroSim.ComponentType type){
		GLib.List<weak Widget> templist=list.get_children();
		foreach(weak Widget comp in templist){
				if((comp as Component).componentType==type)
					comp.set_no_show_all(false);
				else
					comp.set_no_show_all(true);							
		}
		this.compType=type;
	}

	
	public void  set_list_visual(Visual vis){
		GLib.List<weak Widget> templist=list.get_children();
		foreach(weak Widget comp in templist){
			(comp as Component).set_display_parameter(vis);
		}
		this.vis=vis;
	}

	public void set_list_visual_simulation(){
		set_list_visual(ElektroSim.Visual.SIMULATION);
	}
}
}
