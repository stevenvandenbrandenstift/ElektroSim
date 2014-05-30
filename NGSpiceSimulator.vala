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
using ngspice;
namespace ElektroSim{
public class NGSpiceSimulator : GLib.Object {

	public static ArrayList<Component> items;
	private static Component current_component;

	public int identificationLibrary;
	public void* userData;

	public NGSpiceSimulator (ArrayList<Component> items) {
		this.items=items;
		current_component=null;
		ngspice.init<int>(receive_output, receive_simulation_data, controlled_exit, receive_vectors , receive_init_vectors, is_background_thread_running,5);
	}

	public static int receive_output(string stdout,int id, int data){
		string[]dataList = stdout.split("\n");
			foreach (string line in dataList) {
			int position2,end2;

			line=line.strip ();
			if(!line.contains("<<NAN, error = 7>>")){
				
				end2=line.char_count ();
				position2=line.index_of_char (' ');
				line=line.slice(position2+1,end2);

				if(current_component!=null&&current_component.name!="Ground"&&(!line.has_prefix ("device"))){
					line=line.replace(",",".");
					print ("insert: '%s'\n", line); //debug line
					current_component.insert_simulation_data(line);
					if(line.has_prefix ("p ")){
						//current_component=new Ground();
					}
				}
				else if(line.has_prefix ("device")){
				
					int position,end;
					end=line.char_count ();
					position=line.last_index_of_char (' ')+1;
					line=line.slice(position,end);
					print ("deviceline: '%s'\n", line); //debug line
					//stdout.printf ("deviceline: '%s'\n", line); //debug line
					foreach(Component comp in items){
						if(comp.name==line){
						current_component=comp;
						}
					}
				}
			}   
			}
		return 0;
	}

	public static int receive_simulation_data(string simulation_status,int id, int data){
		print ("simulation status: '%s'\n", simulation_status); //debug line
		return 0;
	}

	public static int controlled_exit(int status, bool unload_immediate, bool exit_on_quit,int id, int	data){
		print ("exit status: '%i'\n", status); //debug line
		return 0;
	}

	public static int receive_vectors(VecValuesAll[] all_vectors , int amount, int id,int data){
		//print ("vectors amount: '%i'\n", amount); //debug line
			//print ("vecname 1 : '%s'\n", all_vectors[0].actualSetValues[0].name); //debug line  
			//print ("vecname 2: '%s'\n", all_vectors[1].actualSetValues[0].name); //debug line
			//print ("vecname 1: '%s'\n", all_vectors[0].actualSetValues[1].name); //debug line
			//print ("vecname 2: '%s'\n", all_vectors[1].actualSetValues[2].name); //debug line
		
		return 0;
	}
		
	public static int receive_init_vectors(VecInfoAll[] vecs, int id,int data){
		print ("init vector received from id: '%i'\n", id); //debug line
		ngspice.send_command("status");
		return 0;
	}
	public static int is_background_thread_running(bool running, int id,int data){
		if(running)
		print ("background thread running\n"); //debug line
		else
		print ("background thread NOT running\n"); //debug line
		return 0;
	}
	
	public void load_netlist(ArrayList<Component> items){
		string[] netlist = {"netlist by ElektroSim"};
		foreach(Component component in items){
			netlist+=component.get_netlist_line();
			print("%s" ,component.get_netlist_line());
		}
		netlist+=".END";
		upload_circuit(netlist);
	}


	public string generate_file(){

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
		/*dos.put_string (".control\n");
		//dos.put_string ("OP\n");
			foreach(Component component in items){
			if(component.name!="Ground"&&component.name!="Line"){
			dos.put_string("show "+component.name+"\n");
			}
			}
			//dos.put_string ("exit");
		//dos.put_string (".endc\n");
		*/
		dos.put_string (".END");
		
		
		} catch (Error e) {
			stdout.printf ("Error: %s\n", e.message);
			return "ERROR";
		}

		ngspice.send_command("source ./netlist.txt");
		return "ok";

		
	}
	


	public void run_simulation(){
		/*
		ngspice.send_command("stop when time = 1");
		set_breakpoint(0);
		stdout.printf ("tran 1 10 1; \n\n");
		ngspice.send_command("tran 1 10 1");
		Thread.usleep(1000000);
		stdout.printf ("show r1;\n\n");
		ngspice.send_command("show r1");
		Thread.usleep(1000000);
		stdout.printf ("step ;\n\n");
		ngspice.send_command("step");
		Thread.usleep(1000000);
		stdout.printf ("show r1;\n\n");
		ngspice.send_command("show r1");
		Thread.usleep(1000000);
		*/
		
		ngspice.send_command("op");
		foreach(Component component in items){
			if(component.name!="Ground"&&component.name!="Line")
			ngspice.send_command("show "+component.name+"\n");
		}
	}

}
}
