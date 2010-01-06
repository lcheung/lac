package app.demo.artgen
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	
	public class HoppingBugs extends ISwarmMember 
	{

		private var state:int;
		private var lastPos:Point;
		private var lastVel:Point;		
		private var pos:Point;		
	
		
		private var tmp:Point;
		

		public function HoppingBugs() 
		{
			lastPos = new Point();
			lastVel = new Point();
			pos = new Point();

			
			tmp = new Point();
			
			graphics.beginFill(0xffffff);
			graphics.drawCircle(0,0, 10);
			graphics.endFill();
		}
		
		override public function track(pt:Point)
		{
			if(Math.random() > 0.8)
			{
				tmp = pt.subtract(lastPos);
				
				vel.x += tmp.x * 0.5;
				vel.y += tmp.y * 0.5;

		
			}
			
			vel.x *= 0.25;
			vel.y *= 0.25;			

			this.x += vel.x;
			this.y += vel.y;

			
			lastVel.x = vel.x;
			lastVel.y = vel.y;			
			lastPos.x = this.x;
			lastPos.y = this.y;
			
			this.rotation = Math.atan2(vel.x, vel.y) * 180 / Math.PI;
		}
		
		override public function setupInfo(data:XMLList)
		{

			
		}		
	}
}