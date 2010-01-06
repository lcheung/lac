package app.core.object {	
	import flash.display.Shape;		
	import flash.display.Loader;		
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.geom.Point;			
	
	import app.core.action.RotatableScalable;
	
	public class SWFObject extends RotatableScalable 
	{
		private var clickgrabber:Shape = new Shape();		
		private var photoLoader:Loader = null;		
		private var velX:Number = 0.0;
		private var velY:Number = 0.0;				
		private var velAng:Number = 0.0;		
		private var friction:Number = 0.05;
		private var angFriction:Number = 0.05;	
		private var setscaleXY:int;
		
		public function SWFObject (url:String, insetX:int, insetY:int, insetscaleXY:int)
		{
			noSelection="true";
			//noRotate="true";
			
			this.x = insetX ;
			this.y = insetY ;	
			
			setscaleXY = insetscaleXY;
			
			this.x = 1400 * Math.random() - 1000;
			this.y = 1400 * Math.random() - 1000;			
		
			photoLoader = new Loader();
			photoLoader.contentLoaderInfo.addEventListener( Event.COMPLETE, arrange );					
			clickgrabber.graphics.beginFill(0xffffff, 0.01);
			clickgrabber.graphics.drawRect(0,0, 1,1);
			clickgrabber.graphics.endFill();			
			var request:URLRequest = new URLRequest( url );						
			photoLoader.unload();
			photoLoader.load( request );		
            addChild( clickgrabber );					
			addChild( photoLoader );	
					
			//this.addEventListener(Event.ENTER_FRAME, slide);
		}
		
		private function arrange( event:Event = null ):void 
		{
			photoLoader.x = -photoLoader.width/2;
			photoLoader.y = -photoLoader.height/2;			
			photoLoader.scaleX = 1.0;
			photoLoader.scaleY = 1.0;			
			
			clickgrabber.scaleX = photoLoader.width+20;
			clickgrabber.scaleY = photoLoader.height;			
			clickgrabber.x = -photoLoader.width/2-20;
			clickgrabber.y = -photoLoader.height/2-15;				
			
			//this.scaleX = (Math.random()*0.4) + 0.3;
			//this.scaleX = 0.2;
			//this.scaleX = 1;
			//this.scaleY = this.scaleX;
			//this.alpha = 1.0;
			//this.rotation = Math.random()*180 - 90;
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

