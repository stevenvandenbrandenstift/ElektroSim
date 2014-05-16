 /* -*- Mode: vala; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/*
 * netlist-generator.vala
 * Copyright (C) 2014 Steven Vanden Branden <StevenVandenbrandenstift@gmail.com>
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
using Gee;
namespace ElektroSim{
public class NGSpiceSimulator : GLib.Object {

	// Constructor
	private string current_component;
	public signal void data_ready (string current_component, string data);
	//public AsyncQueue<string> outputbuffer;
	public Ngspice.NgspiceShared ngspice;


	public NGSpiceSimulator () {
		current_component="";
		//outputbuffer = new AsyncQueue<string> ();	
	
	}
	
	private bool processor (string data) {
		
			string[]dataList = data.split("\n");
			foreach (string line in dataList) {
			line=line.strip ();
           		stdout.printf ("%s\n", line);
			if(current_component!=null&&current_component!=""&&(!line.has_prefix ("device"))){
				data_ready(current_component,line);
			}
			else if(line.has_prefix ("device")){
				int position,end;
				end=line.char_count ();
				position=line.last_index_of_char (' ')+1;
				line=line.slice(position,end);
				//stdout.printf ("deviceline: '%s'\n", line); //debug line
				current_component=line;
			}
			}
		return true;
	}
	

	public string generate_file(ArrayList<Component> items){
		try {
		File file = File.new_for_path ("./netlist.txt");
		if (file.query_exists ()) {
			file.delete ();
		}
		var dos = new DataOutputStream (file.create (FileCreateFlags.REPLACE_DESTINATION));
		dos.put_string ("netlist by ElektroSim2\n");
		foreach(Component component in items){
			dos.put_string (component.get_netlist_line());
			print("%s" ,component.get_netlist_line());
		}
		dos.put_string (".control\n");
		dos.put_string ("OP\n");
			foreach(Component component in items){
			if(component.name!="Ground"){
			dos.put_string("show "+component.name+"\n");
		}
			}
			dos.put_string ("exit");
		dos.put_string (".endc\n");
		dos.put_string (".END");
		
		
		} catch (Error e) {
			stdout.printf ("Error: %s\n", e.message);
			return "ERROR";
		}
		return "ok";
	}
	


	public void run_simulation(){
	
		//send_to_ngspice("source /home/steven/test/netlist.txt\n");
		//send_to_ngspice("run\n");
		
		string[] spawn_args = {"/usr/local/bin/ngspice","-a","-p","./netlist.txt"};
		string[] spawn_env = Environ.get ();
		string standard_output;
		string standard_error;
		
		try{
		Process.spawn_sync (null,
			                                spawn_args,
			                                spawn_env,
			                                SpawnFlags.SEARCH_PATH,
			                                null,
			                                out standard_output,
			                                out standard_error,
			                                null);
		//stdout.printf ("output= %s\n",standard_output); //debug line
		//data_ready(standard_output);	                 
       	processor(standard_output);
       	}
		catch (Error e) {
			stdout.printf ("Error: %s\n", e.message);
		}
		
	}

}
}
