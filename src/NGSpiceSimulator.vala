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

	public static Gee.ArrayList<Component> items;
	public static Component simulation;
	public signal Gee.ArrayList<Component> request_components(Component.ComponentType type2);
	private static Component current_component;
	private static string current_device;
	private static bool ready=false;
	public int identificationLibrary;
	public void* userData;

	public NGSpiceSimulator () {
		current_component=null;
		current_device="";
		items=new Gee.ArrayList<Component>();
		ngspice.init<int>(receive_output, receive_simulation_data, controlled_exit, receive_vectors , receive_init_vectors, is_background_thread_running,5);
	}


	private static bool check_string(string line){
		ArrayList<string> wrong;
		wrong=new ArrayList<string>();
		wrong.add("<<NAN, error = 7>>");
		wrong.add("--------------------------------------------------------------------------------");
		string test;
		test=line.strip ();
		foreach(string str in wrong){
			if(test.contains(str))
				return false;
		}
		if(test.has_prefix("device")){
				current_device=split_line(line,null);
				return false;
		}
		if(test.has_prefix("Index")){
				current_device="Simulation";
				return false;
		}
		if(test.contains("hit return for more")){
				ngspice.send_command("c\n");
		}
		return true;
	}
	
	private static string split_line(string line, out string prefix){
			string pros;
			pros=line.strip ();
			pros=pros.replace(",",".");
			int position2,position,end;
			end=line.char_count ();
			position=line.last_index_of_char (' ')+1;
			position2=line.index_of_char (' ');
			prefix=line.slice(0,position2);
			return line.slice(position,end);
	}
	
	private static bool check_device(){
		foreach(Component comp in items){
			if(comp.name==current_device){
				current_component=comp;
				return true;
			}
		}
		return false;
	}

	private static string strip_std(string line){
			int end=line.char_count ();
			int position=line.index_of_char (' ');
			return line.slice(position+1,end);
	}
	
	public static int receive_output(string stdout,int id, int data){
		string[] dataList = stdout.split("\n");
			foreach (string line in dataList) {
				line=strip_std(line);
				if(check_string(line)){
					if(check_device()){	 
						string val,parameter;
						val=split_line(line, out parameter);
						current_component.insert_simulation_data(parameter,val,true);
					}
				}
			}
		return 0;
	}
	
	private static void print_report(){
			print ("==========================================================\nreport:\n" );
						foreach(Component component in items){
								print ("\n%s :\n", component.name );
								foreach(Parameter par in component.parameters){
										if(par.values.size>0&&(par.name=="i"||par.name=="p"||par.name=="activity"||par.name=="work_zone")){
											print("%s (%i) -> ",par.name,par.values.size);
												foreach(double val in par.values){
													print("%f - ",val);
												}
											print("\n");
										}else
											print ("%s -> %f :\n", par.name,par.val );
								}
						}
	}
	public static int receive_simulation_data(string simulation_status,int id, int data){
		if(simulation_status.contains("--ready--")){
			ready=true;
			simulation.get_parameter("status").set_value(1);
			debug("simulation status set to 1");
		}
		return 0;
	}

	public static int controlled_exit(int status, bool unload_immediate, bool exit_on_quit,int id, int	data){
		print ("exit status: '%i'\n", status); //debug line
		return 0;
	}

	public static int receive_vectors(VecValuesAll[] all_vectors , int amount, int id,int data){
		//run afther each datapoint added -- 
		ngspice.send_command("bg_halt");

		foreach(Component component in items){
								if(component.name!="Ground"&&component.name!="Line"&&component.name!="Simulation"){
									ngspice.send_command("show "+component.name+"\n");
								}
								
		}
		string chars="time";
		VectorInfo info=ngspice.VectorInfo.from_string(chars);
		debug ("vector time length "+info.length.to_string());
		simulation.insert_simulation_data("time",info.data[info.length-1].to_string(),true);
		return 0;
	}
		
	public static int receive_init_vectors(VecInfoAll[] vecs, int id,int data){
		print ("init vector received from id: '%i'\n", id); //debug line
		return 0;
	}
	public static int is_background_thread_running(bool running, int id,int data){
		if(running)
		print ("background thread running\n"); //debug line
		else{
		print ("background thread NOT running\n"); //debug line
		}
		return 0;
	}
	
	public void load_netlist(){
		string[] netlist = {"netlist by ElektroSim"};
		foreach(Component component in items){
			netlist+=component.get_netlist_line();
			print("%s" ,component.get_netlist_line());
		}
		netlist+=".END";
		upload_circuit(netlist);
	}


	public string generate_file(ArrayList<Component> comps){
		
		items=comps;
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
		dos.put_string (".END");
		
		
		} catch (Error e) {
			stdout.printf ("Error: %s\n", e.message);
			return "ERROR";
		}

		ngspice.send_command("source ./netlist.txt");
		return "ok";

	
	}
	


	public void run_simulation(){

		string command=null;
		foreach(Component component in request_components(Component.ComponentType.SIMULATION)){
				simulation=component;
				continue;
		}
		if(simulation!=null){
			simulation.get_parameter("status").set_value(0);
			items=request_components(Component.ComponentType.COMPONENT);
			load_netlist();
			ready=false;
			print ("\n\n====================run simulation======================================\n\n" );
			command=simulation.get_netlist_line();
			debug ("send this: '"+command+"' from "+simulation.name);
			ngspice.send_command(command+"\n");
			
		}   
		
			
	}

}
}