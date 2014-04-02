/* -*- Mode: vala; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/*
 * ground.vala
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

namespace ElektroSim{
	
public class Ground : Component {

		public Ground () {
			base("ground");
			this.width=100;
	}

	public override void draw_symbol(Cairo.Context context){
		context.new_path ();
		context.set_source_rgb (3, 3, 3);
		
		context.rectangle (connections.nth_data(0).x,connections.nth_data(0).y,-this.width,2);
		context.select_font_face ("Adventure", Cairo.FontSlant.NORMAL, Cairo.FontWeight.BOLD);
		context.set_font_size (20);
		context.rel_move_to (-this.width,0);
		context.text_path ("Ground");
		context.fill();
		context.stroke ();
		context.close_path ();
	}
	public override Component clone(Component component,int x, int y){
			Ground newc=new Ground();
			newc.connections.append(new Point.with_net (x,y,0));
			return newc;
	}
		public override void insertSimulationData(string data){
	}

	public override int snap(List<Component> list,int range,int netAmount){
		connections.nth_data(0).pointNearby(range,list);
		int newNetCount=connections.nth_data(0).checkNetName(netAmount);
		return newNetCount;
	}
	public override string getNetlistLine(){
		string line;
		line=name+" "+connections.nth_data(0).net.to_string();
		return "";//line+"\n";
	}
}
}

