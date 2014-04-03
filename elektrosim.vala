/* -*- Mode: C; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
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
namespace ElektroSim{
	
class MainWindow : Window  {

	private ListBox list;
	private SimulationArea simArea;
	

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
		this.border_width = 10;
		this.maximize ();
		this.window_position = WindowPosition.CENTER;
		this.destroy.connect(Gtk.main_quit);


		setup_layout();
		
		Resistor test=new Resistor(5,1);
		list.prepend(test);
		Ground test2=new Ground();
		list.add(test2);
		PowerSource powerSource=new PowerSource(10);
		list.add(powerSource);

		this.show ();
	}

	private void setup_layout(){
		Gtk.HeaderBar headerBar= new HeaderBar();
		list = new Gtk.ListBox();

		list.set_selection_mode (SelectionMode.SINGLE);

		headerBar.set_halign (Align.FILL);
		headerBar.add(new Button.with_label ("Design"));
		simArea=new SimulationArea(list);
		Button sim_button=new Button.with_label ("Simulation") ;
		sim_button.clicked.connect(simArea.simulate);
		headerBar.add(sim_button); 
		Grid grid = new Grid();
		
		grid.add(list);
		grid.add (simArea);
		add(grid);
		this.set_titlebar (headerBar);

	}

}
}
