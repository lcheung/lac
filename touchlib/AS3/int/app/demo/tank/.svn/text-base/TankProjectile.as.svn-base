package app.demo.tank 
{
	import flash.events.*;
	import flash.geom.*;
	import flash.display.*;
	import flash.events.*;
	import app.demo.tank.*;
	
	dynamic public class TankProjectile extends MovieClip
	{
		private var facingVec:Point;			
		private var lifeCount:int;
		private var game:TankGame;
		public var owner:PlayerTank;

		public function TankProjectile(ang:Number, vel:Number, o:PlayerTank, g:TankGame)
		{
			game = g;
			owner = o;
			lifeCount = 15;
			var upVec:Point = new Point(0,-1);
			
			var m:Matrix = new Matrix();
			m.rotate((ang * Math.PI) / 180.0);
			m.scale(vel, vel);
			facingVec = m.transformPoint(upVec);			
			
			this.rotation = ang;
			
			this.addEventListener(Event.ENTER_FRAME, this.frameUpdate, false, 0, true);
			game.addEventListener(Event.UNLOAD, unloadHandler, false, 0, true);	
		}
		
		function unloadHandler(e:Event)
		{
			removeSelf();
		}
				

		public function frameUpdate(e:Event)
		{
			lifeCount -= 1;
			
			if(lifeCount <= 0)
			{
				removeSelf();
			} else {
				this.x += facingVec.x;
				this.y += facingVec.y;
				
				
				if(this.x > game.arenaWidth)
					this.x = 0.0;
				if(this.x < 0.0)
					this.x = game.arenaWidth;
					
				if(this.y > game.arenaHeight)
					this.y = 0.0;
				if(this.y < 0)
					this.y = game.arenaHeight;				
				
				// Check for collisions?
				game.projectileHandleCollisions(this);
			}
		}
		
		public function removeSelf()
		{
			this.removeEventListener(Event.ENTER_FRAME, this.frameUpdate);			
			parent.removeChild(this);

			delete this;			
		}
	}
}