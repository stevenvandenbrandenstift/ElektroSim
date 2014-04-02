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

namespace ElektroSim{
public class NGSpiceSimulator : GLib.Object {

	// Constructor
	private FileStream input;
	private string currentComponent;
	public signal void data_ready (string currentComponent, string data);
	public AsyncQueue<string> outputbuffer;

	public NGSpiceSimulator () {
		
		currentComponent="";
		outputbuffer = new AsyncQueue<string> ();
		
	
	
	}
	
	public bool processor (string data) {
		
			string[]dataList = data.split("\n");
			foreach (string line in dataList) {
			line=line.strip ();
            stdout.printf ("%s\n", line);
			if(currentComponent!=null&&currentComponent!=""&&(!line.has_prefix ("device"))){
				data_ready(currentComponent,line);
			}
			else if(line.has_prefix ("device")){
				int position,end;
				end=line.char_count ();
				position=line.last_index_of_char (' ')+1;
				line=line.slice(position,end);
				stdout.printf ("deviceline: '%s'\n", line); //debug line
				currentComponent=line;
			}
			}
		return true;
	}
	

	public string generate_file(List<Component> items){
		try {
		File file = File.new_for_path ("/home/steven/test/netlist.txt");
		if (file.query_exists ()) {
			file.delete ();
		}
		var dos = new DataOutputStream (file.create (FileCreateFlags.REPLACE_DESTINATION));
		dos.put_string ("netlist by ElektroSim2\n");
		foreach(Component component in items){
			dos.put_string (component.getNetlistLine());
			print("%s" ,component.getNetlistLine());
		}
		dos.put_string (".control\n");
		dos.put_string ("OP\n");
			foreach(Component component in items){
			if(component.name!="ground"){
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
	

	private bool send_to_ngspice(string command){
	stdout.printf ("write to ngpspice %s\n",command); //debug line
		input.write (command.data);
		return true;
	}

	public void run_simulation(List<Component> items){
	
		//send_to_ngspice("source /home/steven/test/netlist.txt\n");
		//send_to_ngspice("run\n");
		
		string[] spawn_args = {"/usr/local/bin/ngspice","-a","-p","./netlist.txt"};
		string[] spawn_env = Environ.get ();
		Pid child_pid;
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
		stdout.printf ("output= %s\n",standard_output); //debug line
		//data_ready(standard_output);	                 
       	processor(standard_output);
       	}
		catch (Error e) {
			stdout.printf ("Error: %s\n", e.message);
		}
		
	}

}
}
