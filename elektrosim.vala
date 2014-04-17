/*
 * main.c
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
	
public class MainWindow : Window  {
	
	public ListBox list{get;set;}
	public SimulationArea sim_area;
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
		this.set_default_size (1920, 1000);
		this.maximize();
		this.window_position = WindowPosition.CENTER;
		this.destroy.connect(Gtk.main_quit);
		setup_layout();
		this.show ();
		
	}
	
	private void update_list(ArrayList<Component> new_list){
			while(list.get_row_at_index(0)!=null){
				Component old=(Component)list.get_row_at_index(0);
				list.remove(old);
			}
			foreach(Component component in new_list){
				component.pack_parameters();
				list.add(component);
				
				print("list added component %s\n",component.name);
				foreach(Parameter par in component.parameters)
					print("parameter %s,%i\n",par.name,par.val);
				component.grid.show_all();
			}
			this.show_all();
			if(new_list==null||new_list.size==0){
				print("NOT OK list was empty\n");
			}
			print("OKOKOKOKOKOK\n");
	}
	
	private Component get_selected_row(){
		return (list.get_selected_row() as Component);
	}

	private void setup_layout(){
		Gtk.HeaderBar header_bar= new HeaderBar();
		
		add(grid);
		
		header_bar.set_halign (Align.FILL);
		sim_area=new SimulationArea();
		sim_area.list_update.connect (update_list);
		sim_area.get_selected_row.connect (get_selected_row);
		sim_area.init();
		Button design_button=new Button.with_label ("Design") ;
		design_button.clicked.connect(sim_area.init);
		header_bar.add(design_button);
		Button sim_button=new Button.with_label ("Simulation") ;
		sim_button.clicked.connect(sim_area.simulate);
		header_bar.add(sim_button); 
		Button clear_button=new Button.with_label ("Clear") ;
		clear_button.clicked.connect(sim_area.clear);
		header_bar.add(clear_button); 
		grid.add(list);
		grid.add(sim_area);
		this.set_titlebar (header_bar);

	}

}
}
