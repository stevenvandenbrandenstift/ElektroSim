
using Gtk;
using Gdk;


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

			Component test=new Component("testing this");
			list.prepend(test);
			test=new Component("testing1");
			list.prepend(test);
			this.show ();
		}

		private void setup_layout(){
			Gtk.HeaderBar headerBar= new HeaderBar();
			list = new Gtk.ListBox();

			list.set_selection_mode (SelectionMode.SINGLE);
			Button button = new Button.with_label ("Components");

			headerBar.set_halign (Align.FILL);
			headerBar.add(button);
			headerBar.add(new Button.with_label ("Design"));
			headerBar.add(new Button.with_label ("Simulation")); 
			Grid grid = new Grid();
			simArea=new SimulationArea();
			grid.add(list);
			grid.add (simArea);
			add(grid);
			this.set_titlebar (headerBar);

		}

		public void clear_history ()
		{
		}

		public void messagebox_show(string title, string message)
		{
			var dialog = new Gtk.MessageDialog(
			                                   null,
			                                   Gtk.DialogFlags.MODAL,
			                                   Gtk.MessageType.INFO,
			                                   Gtk.ButtonsType.OK,
			                                   message);

			dialog.set_title(title);
			dialog.run();
			dialog.destroy();
		}
	}
