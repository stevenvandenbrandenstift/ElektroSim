using Gtk;
using Gee;
namespace ElektroSim{
	
public class MainWindow : Window  {
	
	public ComponentList clist;
	public SimulationArea sim_area;
	public XYGraph graph;
	public Grid grid;
	public NGSpiceSimulator gen;

	public static int main (string[] args)
	{
		Gtk.init(ref args);
		MainWindow window = new MainWindow (); 
		window.show_all();
		window.set_decorated(true);
		Gtk.main(); 
		return 0;
	}

	public MainWindow()
	{
		this.title = "ElektroSim";
		clist= new ComponentList();
		grid = new Grid();
		border_width = 1;
        this.set_default_size (1400, 800);
		maximize();	
		window_position = WindowPosition.CENTER;
		this.destroy.connect(Gtk.main_quit);


 		Gtk.HeaderBar header_bar= new HeaderBar();

		add(grid);

		header_bar.set_halign (Align.FILL);
		header_bar.show_close_button=true;
		header_bar.set_visible(true);
		
		sim_area=new SimulationArea();
		clist.fill_templates();	

		graph= new XYGraph();

		clist.request_redraw.connect(sim_area.redraw_canvas);
		clist.selected_values_description_changed.connect(graph.set_name);
		clist.request_graph_redraw.connect(graph.redraw);		
				

		sim_area.new_component.connect (clist.add_component);
		sim_area.request_selected_component.connect (clist.get_selected_component);
		sim_area.request_components.connect (clist.get_components);
		
		graph.request_selected_component_values.connect(clist.get_selected_values);
		graph.request_time_values.connect(clist.get_time_values);
		
		
		gen= new NGSpiceSimulator();
		gen.request_components.connect (clist.get_components);
		
		Button design_button=new Button.with_label ("Design") ;
		//design_button.clicked.connect(sim_area.init);
		header_bar.add(design_button);

		Button sim_button=new Button.with_label ("Simulation") ;
		clist.request_simulation.connect(gen.run_simulation);
		sim_button.clicked.connect(clist.set_mode_simulation);
		header_bar.add(sim_button); 

		Button clear_button=new Button.with_label ("Clear") ;
		clear_button.clicked.connect(clist.clear);
		header_bar.add(clear_button); 
		
		Gtk.ScrolledWindow scrolled = new Gtk.ScrolledWindow (null, null);
		scrolled.set_min_content_width(300);
		scrolled.set_hexpand(false);

		scrolled.add(clist.list);
		grid.attach(scrolled,0,0,1,4);
		grid.attach_next_to (sim_area, scrolled, Gtk.PositionType.RIGHT, 4, 3);
		grid.attach_next_to (graph, sim_area, Gtk.PositionType.BOTTOM, 4, 1);
		
		grid.set_column_homogeneous(false);

		set_titlebar (header_bar);
	}


}
	private void debug(string line){
		bool debug=false;
		if(debug)	
			print(line+"\n");
	}
}