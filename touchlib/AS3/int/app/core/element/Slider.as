// A basic Slider that listens to both TUIO events and regular MouseEvents.
// TODO: add ability to dispatch events when the value changes.. 

package app.core.element{
	
	import flash.display.*;		
	import flash.events.*;
	import flash.net.*;
	import flash.events.*;
	import flash.geom.*;			
    import flash.filters.*;


	public class Slider extends MovieClip
	{
		private var gfxSliderGrip:Sprite;
		private var gfxActiveGlow:Sprite;
		private var sliderValue:Number = 0.0;
		private var isActive:Boolean = false;
		private var gfxWidth:Number = 0;
		private var gfxHeight:Number = 0;
		private var scrollableHeight:Number;
		private var borderPixels:Number = 4;
		private var roundnessPixels:Number = 16;
		
		private var activeX:Number;
		private var activeY:Number;		
		
		private var mouseActive:Boolean;

		public function Slider(wd:Number, ht:Number)
		{
			mouseActive = false;
			gfxWidth = wd;
			gfxHeight = ht;
			gfxSliderGrip = new Sprite();
			gfxSliderGrip.graphics.beginFill(0xFFFFFF, 0.5);
			gfxSliderGrip.graphics.drawRoundRect(-(wd/2) + borderPixels, -20, wd-borderPixels*2, 40, roundnessPixels, roundnessPixels);
			addChild(gfxSliderGrip);
			
			var blurfx:BlurFilter = new BlurFilter(10, 10, 1);
			
			gfxActiveGlow = new Sprite();
			gfxActiveGlow.graphics.beginFill(0xFFFFFF, 0.7);
			gfxActiveGlow.graphics.drawCircle(0,0,20);
			gfxActiveGlow.visible = false;
			gfxActiveGlow.filters = [blurfx];
			addChild(gfxActiveGlow);			
			
			scrollableHeight = gfxHeight - 40 - borderPixels*2;
			
			this.graphics.beginFill(0xFFFFFF, 0.5);
			this.graphics.drawRoundRect(0, 0, wd, ht, roundnessPixels, roundnessPixels);
			

			this.addEventListener(TouchEvent.MOUSE_MOVE, this.tuioMoveHandler, false, 0, true);			
			this.addEventListener(TouchEvent.MOUSE_DOWN, this.tuioDownEvent, false, 0, true);						
			this.addEventListener(TouchEvent.MOUSE_UP, this.tuioUpEvent, false, 0, true);									
			this.addEventListener(TouchEvent.MOUSE_OVER, this.tuioRollOverHandler, false, 0, true);									
			this.addEventListener(TouchEvent.MOUSE_OUT, this.tuioRollOutHandler, false, 0, true);
			
			this.addEventListener(MouseEvent.MOUSE_MOVE, this.mouseMoveHandler, false, 0, true);									
			this.addEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownEvent, false, 0, true);															
			this.addEventListener(MouseEvent.MOUSE_UP, this.mouseUpEvent, false, 0, true);	
			this.addEventListener(MouseEvent.ROLL_OVER, this.mouseRollOverHandler, false, 0, true);
			this.addEventListener(MouseEvent.ROLL_OUT, this.mouseRollOutHandler, false, 0, true);
			
			this.addEventListener(Event.ENTER_FRAME, this.frameUpdate, false, 0, true);			
			
			updateGraphics();
		}
		
		function updateGraphics()
		{

			gfxSliderGrip.x = 25;
			gfxSliderGrip.y = gfxHeight - 20 - borderPixels - (scrollableHeight*sliderValue);
		
		}
		
		function sliderStartDrag()
		{
			isActive = true;
			gfxActiveGlow.visible = true;			
		}
		
		
		function sliderStopDrag()
		{
			if(isActive)
			{
				isActive = false;
				gfxActiveGlow.visible = false;			
			}
			mouseActive = false;					
		}		
		
		public function setValue(f:Number)
		{
			if(f < 0)
				f = 0.0;
			if(f > 1.0)
				f = 1.0;
			sliderValue = f;
			
			updateGraphics();
			
		}
		
		public function getValue():Number	
		{
			return sliderValue;
		}
		
		public function getActive():Boolean
		{
			return isActive;
		}
		
		function frameUpdate(e:Event)
		{
			if(isActive)
			{
				if(mouseActive)
				{
					activeX = this.mouseX;
					activeY = this.mouseY;
				}
				gfxActiveGlow.x = activeX;
				gfxActiveGlow.y = activeY;
			}
		}

		
		public function tuioDownEvent(e:TouchEvent)
		{		

			TUIO.addObjectListener(e.ID, this);
			sliderStartDrag();			
			e.stopPropagation();
		}

		public function tuioUpEvent(e:TouchEvent)
		{		
			sliderStopDrag();		
			e.stopPropagation();
		}		

		public function tuioMoveHandler(e:TouchEvent)
		{
			if(isActive)
			{
				var tuioobj:TUIOObject = TUIO.getObjectById(e.ID);							
				
				var localPt:Point = globalToLocal(new Point(tuioobj.x, tuioobj.y));														
				activeX = localPt.x;
				activeY = localPt.y;
				setValue(1.0 - ((localPt.y-20-borderPixels) / scrollableHeight));
			}			

			e.stopPropagation();			
		}
		
		public function tuioRollOverHandler(e:TouchEvent)
		{
			
		}
		
		public function tuioRollOutHandler(e:TouchEvent)
		{
			e.stopPropagation();			
		
		}			
		
		public function mouseDownEvent(e:MouseEvent)
		{		

			mouseActive = true;
			sliderStartDrag();
		}
		
		public function mouseUpEvent(e:MouseEvent)
		{		

			sliderStopDrag();

		}		

		public function mouseMoveHandler(e:MouseEvent)
		{
			if(isActive)
			{
				activeX = this.mouseX;
				activeY = this.mouseY;
				setValue(1.0 - ((this.mouseY-20-borderPixels) / scrollableHeight));
			}
		}
		
		public function mouseRollOverHandler(e:MouseEvent)
		{
		}
		
		public function mouseRollOutHandler(e:MouseEvent)
		{
//			sliderStopDrag();			
		
		}					
	}
}