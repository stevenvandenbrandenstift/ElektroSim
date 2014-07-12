/* -*- Mode: vala; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/*
 * simulation.vala
 * Copyright (C) 2014 Steven Vanden Branden <Stevenvandenbrandenstift@gmail.com>
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



public class Simulation : Component {
	
	public Simulation (string sim_alg) {
			base("Simulation");
			clear_parameters();
			add_parameter_string("algorithm",sim_alg);
			Parameter time=add_parameter("time",0);
			time.set_simulation_array(time.arraylist_label_label());

			this.width=100;
			this.height=50;
			this.componentType=ElektroSim.ComponentType.SIMULATION;
	}
	
	public override void draw_image(Cairo.Context cr){
	
	}
	
	public override Component clone(){
			Simulation newc=new Simulation(get_parameter("algorithm").val_string);
			return newc;
	}
	
	public override void snap(int range,int x ,int y){
	}
}
}

