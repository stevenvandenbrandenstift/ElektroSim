/*
 * server.vale
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

namespace Server{
	
class Server {
	
	private string id;

	public static int main (string[] args)
	{
		Server server = new Server (args[1]); 
		server.run();
		return 0;
	}

	public Server(string id)
	{
		this.id=id;

	}
	
	private void run(){
		//make_folder();
		start_server();
		GLib.Thread.usleep (100000);
		print("launching elektrosim \n");
		start_elektroSim();
	}

	private void make_folder(){
		string[] spawn_args = {"/usr/bin/mkdir","./user"+id};
		string[] spawn_env = Environ.get ();
		string standard_output;
		string standard_error;
		
		try{
		Process.spawn_sync ("/home/steven/public_html/users/",
			                                spawn_args,
			                                spawn_env,
			                                SpawnFlags.SEARCH_PATH,
			                                null,
			                                out standard_output,
			                                out standard_error,
			                                null); 
		spawn_args = {"/usr/bin/cp","-r","./emoticons","./users/user"+id};	                                
		Process.spawn_sync ("/home/steven/public_html/",
			                                spawn_args,
			                                spawn_env,
			                                SpawnFlags.SEARCH_PATH,
			                                null,
			                                out standard_output,
			                                out standard_error,
			                                null);                 
       	}
		catch (Error e) {
			print ("Error: %s\n", e.message);
		}
	}
	private void start_server(){
		string[] spawn_args = {"/usr/bin/broadwayd",":"+id};
		string[] spawn_env = Environ.get ();
		Pid child_pid;
		
		try{
		Process.spawn_async ("/home/steven/public_html/users/",
			                                spawn_args,
			                                spawn_env,
			                                SpawnFlags.SEARCH_PATH,
			                                null,
			                                out child_pid
			                                );                 
       	}
		catch (Error e) {
			print ("Error: %s\n", e.message);
		}
	}


	private void start_elektroSim(){
		string[] spawn_args = {"/home/steven/public_html/elektrosim"};
		string[] spawn_env=Environ.get ();
		spawn_env+="GDK_BACKEND=broadway";
		spawn_env+="BROADWAY_DISPLAY=:"+id;
		
		Pid child_pid;

		try{
		Process.spawn_async ("/home/steven/public_html/users",
			                                spawn_args,
			                                spawn_env,
			                                SpawnFlags.SEARCH_PATH,
			                                null,
											out child_pid
			                                );                 
       	}
		catch (Error e) {
			print ("Error: %s\n", e.message);
		}
	}

}
}
