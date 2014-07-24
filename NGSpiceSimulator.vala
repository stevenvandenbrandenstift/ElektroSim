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

public enum SimulationAlgorithm{
		OP,DC,TRAN,AC;
}

public class NGSpiceSimulator : GLib.Object {

	public static Gee.ArrayList<Component> items;
	public static Component simulation;
	public signal Gee.ArrayList<Component> request_components(Component.ComponentType type2);
	private static Component current_component;
	private static int counter=0;
	private static int req_counter=0;
	private static string current_device;
	private static Mutex mutex;
	private static bool ready=false;
	private static bool time_requested=false;
	public int identificationLibrary;
	public void* userData;

	public NGSpiceSimulator () {
		current_component=null;
		mutex = new Mutex ();
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
				//print ("wrongline , '%s' , \n", test); //debug line
				return false;
		}
		if(test.has_prefix("device")){
				current_device=split_line(line,null);
				//print ("deviceline , '%s'  \n", current_device); //debug line
				mutex.lock ();
				counter--;
				mutex.unlock ();
				return false;
		}
		if(test.has_prefix("Index")){
				current_device="Simulation";
				//print ("deviceline , '%s' \n",current_device); //debug line
				mutex.lock ();
				counter--;
				mutex.unlock ();
				return false;
		}
		if(test.contains("hit return for more")){
				//print ("send enter , '%s' \n",current_device); //debug line
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

						if(current_device=="Simulation")
							parameter="time";
					
							current_component.insert_simulation_data(parameter,val,true);
					}
				}
			}
		
		if(counter==0&&ready){
			if(!time_requested){
				time_requested=true;
				string chars="time";
				VectorInfo info=ngspice.VectorInfo.from_string(chars);
				debug ("vector time length "+info.length.to_string());
				for(int i=0;i<info.length;i++){
					print ("%f --",info.data[i]);
					simulation.insert_simulation_data("time",info.data[i].to_string(),true);
				}
				//print_report();
			}
		}
		return 0;
	}
	
	private static void print_report(){
			print ("==========================================================\nreport:\n" );
						foreach(Component component in items){
							if(component.name!="Ground"&&component.name!="Line"){
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
	}
	public static int receive_simulation_data(string simulation_status,int id, int data){
		print ("simulation status: '%s'\n", simulation_status); //debug line
		if(simulation_status.contains("--ready--")){
			ready=true;
			print ("requested '%i' shows \n", req_counter); //debug line
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
									req_counter++;
									mutex.lock ();
									counter++;
									mutex.unlock ();
									ngspice.send_command("show "+component.name+"\n");
									//print("send command: %s","show "+component.name+"\n");
								}
		}
		
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
	


	public void	 run_simulation(){
		
		
		
		
		string command=null;
		foreach(Component component in request_components(Component.ComponentType.SIMULATION)){
				simulation=component;
				continue;
		}
		if(simulation!=null){
			
			items=request_components(Component.ComponentType.COMPONENT);
			load_netlist();
			req_counter=0;
			counter=0;
			ready=false;
			time_requested=false;
			print ("\n\n====================run simulation======================================\n\n" );
			command=simulation.get_netlist_line();
			print ("send this: '%s' from %s \n", command,simulation.name); //debug line
			ngspice.send_command(command+"\n");
			
		}   
		
			
	}

}
}
