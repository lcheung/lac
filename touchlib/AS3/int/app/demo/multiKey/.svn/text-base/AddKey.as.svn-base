package app.demo.multiKey {

	import flash.display.Shape;		
	import flash.display.Loader;		
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.geom.Point;			
    import flash.filters.BitmapFilter;
    import flash.filters.BitmapFilterQuality;
    import flash.filters.DropShadowFilter; 
	import flash.geom.ColorTransform;

	import flash.events.*;
	import app.createMultiKey.*;
	import app.core.action.RotatableScalable;

	

	public class AddKey extends RotatableScalable {
		
		private var clickgrabber:Shape = new Shape();
		
		private var singleNaturalKey:DrawNaturalKey = new DrawNaturalKey();
		private var singleSharpKey:DrawSharpKey = new DrawSharpKey();		
		
		private var velX:Number = 0.0;
		private var velY:Number = 0.0;		
		
		private var velAng:Number = 0.0;
		
		private var friction:Number = 0.85;
		private var angFriction:Number = 0.92;	


		public function AddKey(type:String) {			
			
			bringToFront = false;
			noScale = true;          //make it not scale
			noRotate = true;         //make it not rotate
			noMove = true;           //make it not move			
			
			clickgrabber.graphics.beginFill(0xffffff, 0);
			clickgrabber.graphics.drawRect(0, 0, 1,1);
			clickgrabber.graphics.endFill();
			
			
			
			if (type == "natural")
			{				
				addChild(singleNaturalKey);
				//this.setChildIndex(singleNaturalKey, this.numChildren-1);

			}
			else
			{
				addChild(singleSharpKey);
				//this.setChildIndex(singleSharpKey, this.numChildren-1);

			}		    
			
			arrange(type);
			//addChild(clickgrabber);			
			this.addEventListener(Event.ENTER_FRAME, slide);					
		
		}	

		
		private function arrange(type:String) {
			
			if (type == "natural")
			{			
				singleNaturalKey.x = -singleNaturalKey.width/2;
				singleNaturalKey.y = -singleNaturalKey.height/2;			
				singleNaturalKey.scaleX = 1.0;
				singleNaturalKey.scaleY = 1.0;			
				
				clickgrabber.scaleX = singleNaturalKey.width;
				clickgrabber.scaleY = singleNaturalKey.height;			
				clickgrabber.x = -singleNaturalKey.width/2;
				clickgrabber.y = -singleNaturalKey.height/2;	
		     }
			 else
			 {
			 	singleSharpKey.x = -singleSharpKey.width/2;
				singleSharpKey.y = -singleSharpKey.height/2;			
				singleSharpKey.scaleX = 1.0;
				singleSharpKey.scaleY = 1.0;			
				
				clickgrabber.scaleX = singleSharpKey.width;
				clickgrabber.scaleY = singleSharpKey.height;			
				clickgrabber.x = -singleSharpKey.width/2;
				clickgrabber.y = -singleSharpKey.height/2;
			 }			 
		}
		
		
		
		public override function released(dx:Number, dy:Number, dang:Number) {
			
			velX = dx;			
			velY = dy;					
			velAng = dang;
		}
		
		
		private function slide(e:Event):void {
			
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