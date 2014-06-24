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
			parameters =new ArrayList<Parameter>();
			add_parameter_string("algorithm",sim_alg,Group.ADJUSTABLE_STRING);
			add_parameter("time",0,Group.OPTIONAL_PARAMETER);
			this.width=100;
			this.height=50;
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

