package app.demo.musicalSquares {
	
	import flash.display.Shape;		
	import flash.events.Event;
	import flash.events.*;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import app.core.action.RotatableScalable;
	
	public class MusicCanvas extends RotatableScalable
	{	
		private var clickgrabber:Shape = new Shape();				
		private var velX:Number = 0;
		private var velY:Number = 0;				
		private var velAng:Number = 0;		
		private var friction:Number = .8;
		private var angFriction:Number = .8;		
		
		private var sizeX:int = 10000;
		private var sizeY:int = 10000;
				
		private var scaleXTween:Tween;	
		private var scaleYTween:Tween;
		private var rotationTween:Tween;
		private var xTween:Tween;
		private var yTween:Tween;
		
		function MusicCanvas()
		{
			bringToFront = true;			
			noScale = false;
			noRotate = false;	
			noMove = false;
		
			clickgrabber.graphics.beginFill(0xFFFFFF, 0);
			//clickgrabber.graphics.lineStyle(1.0,0xFFFFFF,0.5);	
			clickgrabber.graphics.drawRect(-sizeX/2,-sizeY/2,sizeX,sizeY);
			clickgrabber.graphics.endFill();						
			this.addChild( clickgrabber );			
			//clickgrabber.x = -clickgrabber.width/2;;
			//clickgrabber.y = -clickgrabber.height/2			
	
			this.addEventListener(Event.ENTER_FRAME, slide);			
		}
		
		public override function doubleTap()
		{
			scaleXTween = new Tween(this, "scaleX", Regular.easeOut, this.scaleX, .9, .5, true);
			scaleYTween = new Tween(this, "scaleY", Regular.easeOut, this.scaleY, .9, .5, true);
			rotationTween = new Tween(this, "rotation", Regular.easeOut, this.rotation, 0, .5, true);
			xTween = new Tween(this, "x", Regular.easeOut, this.x, 0, .5, true);
			yTween = new Tween(this, "y", Regular.easeOut, this.y, 0, .5, true);
		}
		
		public override function released(dx:Number, dy:Number, dang:Number)
		{
			velX = dx;
			velY = dy;						
			velAng = dang;
		}
		
		private function slide(e:Event)
		{
			if(this.state == "none")
			{		
				if(Math.abs(velX) < 0.001)
					velX = 0;
				else {
					x += velX;
					velX *= friction;										
				}
				if(Math.abs(velY) < 0.001)
					velY = 0;					
				else {
					y += velY;
					velY *= friction;						
				}
				if(Math.abs(velAng) < 0.001)
					velAng = 0;					
				else {
					velAng *= angFriction;				
					this.rotation += velAng;					
				}
			}

		}
		
	}
}