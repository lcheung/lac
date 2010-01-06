package app.core.canvas {	
	import flash.display.Shape;		
	import flash.events.Event;
	import flash.geom.Point;		
	import app.core.action.RotateScale;
	
	public class nCanvas extends RotateScale
	{	
		private var clickgrabber:Shape = new Shape();				
		private var velX:Number = 0;
		private var velY:Number = 0;				
		private var velAng:Number = 0;		
		private var friction:Number = 0;
		private var angFriction:Number = 0;			
		
		function nCanvas(setID, setShapi, setColor, setAlpha, setBlend, setWidth, setHeight, setX, setY)
		{
			clickgrabber.blendMode=setBlend;
			bringToFront = true;			
			noScale = false;
			noRotate = false;			
			clickgrabber.graphics.beginFill(setColor, setAlpha);
			if(setShapi == "square")
			{
				clickgrabber.graphics.drawRoundRect(0,0,setWidth,setHeight,10);
				clickgrabber.graphics.beginFill(setColor, setAlpha/2);
				clickgrabber.graphics.drawRoundRect(-5,-5,setWidth+10,setHeight+10,10);
			}
			else{clickgrabber.graphics.drawCircle(0,0,setWidth);}			
			clickgrabber.graphics.endFill();						
			this.addChild( clickgrabber );			
			clickgrabber.x = setX;
			clickgrabber.y = setY;
			//this.addEventListener(Event.ENTER_FRAME, slide);			
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