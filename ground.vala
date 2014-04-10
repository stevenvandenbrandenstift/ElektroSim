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
			this.height=50;
			setupSurface();
	}

	
	public override void update_image(){

	}
	
	public override void clearCounter(){
	}
	
	public override void make_image(){
		
		imageContext.new_path ();
		imageContext.move_to (0, height/2);
		imageContext.line_to (width, height/2);
		imageContext.close_path ();
		imageContext.stroke ();
		
		imageContext.new_path ();
		imageContext.set_font_size (height*0.4);
		imageContext.move_to (width*0.2, height/2-5);
		imageContext.text_path ("Ground");
		imageContext.fill();
		imageContext.close_path ();
	
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

