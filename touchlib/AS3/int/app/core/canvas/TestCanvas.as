package app.core.canvas {
	import flash.events.*;	
	import app.core.action.RotatableScalable;	
	import app.core.object.TextObject;	
	import app.core.object.KeyboardObject;
	import app.core.object.ImageObject;
	
	import flash.display.*;		
	import flash.events.*;
	import flash.net.*;	
	import flash.geom.*;		
	import flash.text.*;
	
	public class TestCanvas extends RotatableScalable
	{

		
		private var clickgrabber:Shape = new Shape();				
		private var sizeX:int = 10000;
		private var sizeY:int = 10000;
		
		private var velX:Number = 0.0;
		private var velY:Number = 0.0;		
		
		private var velAng:Number = 0.0;
		
		private var friction:Number = 0.85;
		private var angFriction:Number = 0.92;
		
		private var labels:TextObject; 
		
		
		
		function TestCanvas()
		{
			bringToFront = false;			
			//noScale = true;
			//noRotate = true;
			
			clickgrabber.graphics.beginFill(0xffffff, 0.0);
			clickgrabber.graphics.drawRect(-sizeX/2,-sizeY/2,sizeX,sizeY);
			clickgrabber.graphics.endFill();						
			
			this.addChild( clickgrabber );		
			this.addEventListener(Event.ENTER_FRAME, slide, false, 0, true);			
			
			/*
			var exitButton:Loader = new Loader();
			exitButton.load(new URLRequest("closeButton.png"));
			exitButton.x = 0;
			exitButton.y = 0;
			exitButton.scaleX = 1.0;
			exitButton.scaleY = 1.0;
			exitButton.alpha = 1.0;
			exitButton.addEventListener(TouchEvent.MOUSE_DOWN, this.exit);
			
			this.addChild(exitButton);
			*/
			labels = new TextObject();
			labels.name = 'labels';

			this.addChild(labels);
			
			this.addChild(new KeyboardObject());
		}
		function exit(e:Event) {
			//var subobj = new mTouchSurface();
			//subobj.name = "SurfaceHolder";
			//parent.addChild(subobj);
			//parent.removeChild(parent.getChildByName("PhotoSurface"));
		}
		
		public override function released(dx:Number, dy:Number, dang:Number)
		{
			velX = dx;
			velY = dy;
			
			//trace(velX+':'+velY);
			
			velAng = dang / 2;
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
			}
		}		
		
		public function addPhoto(sz:String)
		{
			var photo:ImageObject = new ImageObject( sz );
			this.addChild(photo);
		}
		
		
	}
}