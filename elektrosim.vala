using Gtk;
using Gee;
namespace ElektroSim{
	
public class MainWindow : Window  {
	
	public ListBox list;
	public SimulationArea sim_area;
	public XYGraph graph;
	public Grid grid{get;set;}

	public static int main (string[] args)
	{
		Gtk.init(ref args);  //Gtk intialization

		MainWindow window = new MainWindow (); //Create a window
		window.destroy.connect (Gtk.main_quit); //Quit app after window is closed
		window.show_all (); //Makes all widgets visible
		window.set_decorated(true);
        //window.set_app_paintable(true);
		Gtk.main(); //Start the main loop
		return 0;
	}

	public MainWindow()
	{
		this.title = "ElektronSim";
		list= new ListBox();
		grid = new Grid();
		this.border_width = 1;
		//this.set_default_size (1400, 800);
		this.maximize();
		this.window_position = WindowPosition.CENTER;
		this.destroy.connect(Gtk.main_quit);
		setup_layout();
		this.show ();
		
	}
	
	private void update_list(ArrayList<Component> new_list){
			GLib.List<Widget> templist=list.get_children();
			foreach(Widget comp in templist){
				list.remove(comp);
			}
			foreach(Component component in new_list){
				component.pack_parameters();
				list.add(component as ListBoxRow);
				component.grid.show_all();
			}
			this.show_all();
			if(new_list==null||new_list.size==0){
				print("NOT OK list was empty\n");
			}
	}
	
	private Component get_selected_row(){
		return (list.get_selected_row() as Component);
	}
	
	private void print_list(){
		int i=0;
		GLib.List<Widget> templist=list.get_children();
			foreach(Widget comp in templist){
				print("list print component %s\n",(comp as Component).name);
				foreach(Parameter par in (comp as Component).parameters)
					print("parameter %s,%f\n",par.name,par.val);
			}
	}
	
	public void graph_clicked(){
		graph.set_values((list.get_selected_row() as Component).get_parameter("i").values);
		GLib.List<Widget> templist=list.get_children();
			foreach(Widget comp in templist){
				if((comp as Component).name=="Simulation"){
					graph.set_timepoints((comp as Component).get_parameter("time").values);
				}
			}
	}
	
	private void setup_layout(){
		Gtk.HeaderBar header_bar= new HeaderBar();
		
		add(grid);
		
		header_bar.set_halign (Align.FILL);
		header_bar.show_close_button=true;
		header_bar.set_visible(true);
		sim_area=new SimulationArea();
		sim_area.list_update.connect (update_list);
		sim_area.get_selected_row.connect (get_selected_row);
		sim_area.list_print.connect (print_list);
		sim_area.init();
		graph= new XYGraph();
		graph.graph_clicked.connect(graph_clicked);		
	
		Button design_button=new Button.with_label ("Design") ;
		design_button.clicked.connect(sim_area.init);
		header_bar.add(design_button);
		Button sim_button=new Button.with_label ("Simulation") ;
		sim_button.clicked.connect(sim_area.simulate_button);
		header_bar.add(sim_button); 
		Button clear_button=new Button.with_label ("Clear") ;
		clear_button.clicked.connect(sim_area.clear);
		header_bar.add(clear_button); 
		
		Gtk.ScrolledWindow scrolled = new Gtk.ScrolledWindow (null, null);
		scrolled.add(list);
		
		grid.attach(scrolled,0,0,1,4);
		grid.attach_next_to (sim_area, scrolled, Gtk.PositionType.RIGHT, 3, 3);
		grid.attach_next_to (graph, sim_area, Gtk.PositionType.BOTTOM, 3, 1);

		this.set_titlebar (header_bar);

	}

}
}
