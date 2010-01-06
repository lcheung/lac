package app.demo.multiKey {
	
	import flash.display.Shape;		
	import flash.events.Event;
	import flash.geom.Point;
	import flash.events.*;
	import app.demo.multiKey.*;
	
	public class PianoSurface extends RotatableScalable {
		
		private var clickgrabber:Shape = new Shape();				
		private var sizeX:int = 6000;
		private var sizeY:int = 6000;
		
		private var velX:Number = 0.0;
		private var velY:Number = 0.0;				
		private var velAng:Number = 0.0;
		
		private var friction:Number = 0.85;
		private var angFriction:Number = 0.92;
		
		private var octaves1:int;   //how many octaves on first keyboard
		private var octaves2:int;   //how many octaves on second keyboard
		//private var octaves3:int; //how many octaves on third keyboard
		//private var octaves4:int; //how many octaves on thirdfourth keyboard
		
		
		function PianoSurface() {
			
			bringToFront = false;			
			noScale = false;
			noRotate = false;
			noMove = false;
			
			clickgrabber.graphics.beginFill(0xffffff, 0.0);
			clickgrabber.graphics.drawRect(-sizeX/2,-sizeY/2,sizeX,sizeY);
			clickgrabber.graphics.endFill();			
			
			this.addChild( clickgrabber );		
			this.addEventListener(Event.ENTER_FRAME, slide);				
		}
		
		public override function released(dx:Number, dy:Number, dang:Number) {
			
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
			}			
		}				
		
		public function addKeyboard(octaves:int)		
		{		
			//This function doesn't get called anywhere, is it needed?

			/*
			var fullPiano2 = new AddPiano(octaves);
			addChild(keyboard2);
			
				fullPiano2.x = fullPiano2.width/3.6;
				fullPiano2.y = fullPiano2.height/2;			
				fullPiano2.scaleX = .42;
				fullPiano2.scaleY = .42;
				fullPiano2.rotation = 60;				
				
			//first keyboard	
			var fullPiano = new AddPiano(octaves);
			addChild(keyboard);			
			
			if (octaves1 == 1) {
				fullPiano.scaleX = .8;
				fullPiano.scaleY = .8;
				fullPiano.x = fullPiano.width/1.6;
				fullPiano.y = fullPiano.height/1.6;			
			}			
			if (octaves1 == 2){
				fullPiano.x = fullPiano.width/3.6;
				fullPiano.y = fullPiano.height/2;			
				fullPiano.scaleX = .42;
				fullPiano.scaleY = .42;
				
			}	
			*/
		}		
	}
}