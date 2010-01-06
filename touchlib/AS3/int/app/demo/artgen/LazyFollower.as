package app.demo.artgen
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	
	public class LazyFollower extends ISwarmMember 
	{

		private var state:int;
		private var lastPos:Point;
		private var lastVel:Point;		
		private var pos:Point;		
	
		private var tmp:Point;
		
		public function LazyFollower() 
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
				
				tmp.x + Math.random()*100;
				tmp.y + Math.random()*100;				
				
				vel.x += tmp.x * 0.1;
				vel.y += tmp.y * 0.1;

				vel.x *= 0.65;
				vel.y *= 0.65;					
				
				if(vel.length > 10)
					vel.normalize(10);
			} else {
//				vel.x *= 0.95
//				vel.y *= 0.95;
			}
			
			this.x += vel.x;
			this.y += vel.y;
		
			lastVel.x = vel.x;
			lastVel.y = vel.y;			
			lastPos.x = this.x;
			lastPos.y = this.y;
		}
		
		override public function setupInfo(data:XMLList)
		{

			
		}		
	}
}