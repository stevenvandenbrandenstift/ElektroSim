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

public class NGSpiceSimulator : GLib.Object {

	// Constructor
	private int standard_input;
	private int standard_output;
	private int standard_error;
	private FileStream input;
	private string builder;

	public NGSpiceSimulator () {
		builder="";
		try{
			string[] spawn_args = {"/usr/bin/ngspice","-i","-p"};
			string[] spawn_env = Environ.get ();
			Pid child_pid;
			



			Process.spawn_async_with_pipes ("/home/steven/test/",
			                                spawn_args,
			                                spawn_env,
			                                SpawnFlags.SEARCH_PATH | SpawnFlags.DO_NOT_REAP_CHILD,
			                                null,
			                                out child_pid,
			                                out standard_input,
			                                out standard_output,
			                                out standard_error);

			IOChannel output = new IOChannel.unix_new (standard_output);
			output.add_watch (IOCondition.IN | IOCondition.HUP, (channel, condition) => {
				return process_line (channel, condition, "stdout");
			});

			IOChannel error = new IOChannel.unix_new (standard_error);
			error.add_watch (IOCondition.IN | IOCondition.HUP, (channel, condition) => {
				return process_line (channel, condition, "stderr");
			});

			try{
				input = FileStream.fdopen (standard_input, "w");
			}catch
				(Error e) {
					stdout.printf ("Error: %s\n", e.message);
				}


		} catch (Error e) {
			stdout.printf ("Error: %s\n", e.message);
		}


	}

	private bool process_line (IOChannel channel, IOCondition condition, string stream_name) {
		if (condition == IOCondition.HUP) {
			stdout.printf ("%s: The fd has been closed.\n", stream_name);
			return false;
		}

		try {
			string line;
			channel.read_line (out line, null, null);
			stdout.printf ("%s: %s", stream_name, line);
			builder=line;
		} catch (IOChannelError e) {
			stdout.printf ("%s: IOChannelError: %s\n", stream_name, e.message);
			return false;
		} catch (ConvertError e) {
			stdout.printf ("%s: ConvertError: %s\n", stream_name, e.message);
			return false;
		}

		return true;
	}

	public string generate_file(List<Component> components){
		File file = File.new_for_path ("/home/steven/test/netlist.txt");
		if (file.query_exists ()) {
			file.delete ();
		}
		var dos = new DataOutputStream (file.create (FileCreateFlags.REPLACE_DESTINATION));
		dos.put_string (" netlist by ElektroSim\n");
		foreach(Component component in components){
			dos.put_string (component.getNetlistLine());
			print("%s" ,component.getNetlistLine());
		}
		dos.put_string (".OP\n");
		dos.put_string (".END");;
		return "ok";
	}

	private bool send_to_ngspice(string command){
		
		try{
		//builder="";
		input. write (command.data);
		}catch(Error e){
			print("error: %s\n",e.message);
		}
		return true;
	}

	public void run_simulation(List<Component> components){

		send_to_ngspice("source netlist.txt\n");
		send_to_ngspice("run\n");

		foreach(Component component in components){
			string command= "show "+component.name+"\n";
			send_to_ngspice(command);
			//print(builder);
			component.insertSimulationData(builder);
		}
	}

}

