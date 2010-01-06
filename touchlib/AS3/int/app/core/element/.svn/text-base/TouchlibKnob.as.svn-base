// A basic knob that listens to both TUIO events and regular MouseEvents.
// TODO: add ability to dispatch events when the value changes.. 

package app.core.element
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import flash.text.*;
	
	import flash.display.*;		
	import flash.events.*;
	import flash.net.*;
	import flash.events.*;	
	import flash.geom.*;			
	import flash.filters.BlurFilter;
	
    import flash.filters.*;


	public class TouchlibKnob extends MovieClip
	{
		private var gfxIndicator:Sprite;
		private var gfxActiveIndicator:Sprite;
		private var gfxActiveGlow:Sprite;
		public var knobValue:Number = 0.0;
		private var isActive:Boolean = false;
		private var gfxRadius:Number = 0;
		private var mouseActive:Boolean = false;

		
		private var activeX:Number;
		private var activeY:Number;		
		
		private var src:String = "none";
		private var srcID:int = 0;
		
		private var minValue:Number = 0;
		private var maxValue:Number = 1.0;		
		
		private var indicatorText:TextField;
		
		

		public function TouchlibKnob(diam:Number)
		{
			var knob_Shadow : DropShadowFilter = new DropShadowFilter(4,30,0,.5,10,10);
			
			gfxRadius = diam/2;

			gfxIndicator = new Sprite();
			gfxIndicator.graphics.beginFill(0x8C8C8C, 1);
			gfxIndicator.graphics.moveTo(-0.1*gfxRadius, 0);
			gfxIndicator.graphics.lineTo(0, -gfxRadius);			
			gfxIndicator.graphics.lineTo(0.1*gfxRadius, 0);						
			gfxIndicator.graphics.lineTo(-0.1*gfxRadius, 0);			
			gfxIndicator.graphics.endFill();
			gfxIndicator.x = gfxRadius;
			gfxIndicator.y = gfxRadius;	
			gfxIndicator.filters = [knob_Shadow];
			addChild(gfxIndicator);
			
			
			
			
			
			gfxActiveIndicator = new Sprite();
			gfxActiveIndicator.graphics.beginFill(0xFFFFFF, 1);
			gfxActiveIndicator.graphics.moveTo(-0.1*gfxRadius, 0);
			gfxActiveIndicator.graphics.lineTo(0, -gfxRadius);			
			gfxActiveIndicator.graphics.lineTo(0.1*gfxRadius, 0);						
			gfxActiveIndicator.graphics.lineTo(-0.1*gfxRadius, 0);			
			gfxActiveIndicator.graphics.endFill();
			gfxActiveIndicator.x = gfxRadius;
			gfxActiveIndicator.y = gfxRadius;
			gfxActiveIndicator.visible = false;
			addChild(gfxActiveIndicator);
			
			
			var blurfx:BlurFilter = new BlurFilter(5, 5, 0.5);
			
			gfxActiveGlow = new Sprite();
			gfxActiveGlow.graphics.beginFill(0xFFFFFF, 0.7);
			gfxActiveGlow.graphics.drawCircle(0,0,20);
			gfxActiveGlow.visible = false;
			gfxActiveGlow.filters = [blurfx];
			//addChild(gfxActiveGlow);			
			
			
			this.graphics.beginFill(0x373737, 1);
			this.graphics.drawCircle(gfxRadius, gfxRadius, gfxRadius);
			
			var tf:TextFormat = new TextFormat();
			tf.color = 0xffffff;
			tf.align = "center";
			tf.font = "Neo Tech Std";
			tf.size = "10";
			indicatorText = new TextField();
			indicatorText.x = 0;
			indicatorText.y = gfxRadius*2+5;
			indicatorText.width = gfxRadius*2;
			indicatorText.defaultTextFormat  = tf;
			addChild(indicatorText);
			
			
			
			
			

			this.addEventListener(TouchEvent.MOUSE_MOVE, this.tuioMoveHandler);			
			this.addEventListener(TouchEvent.MOUSE_DOWN, this.tuioDownEvent);						
			this.addEventListener(TouchEvent.MOUSE_UP, this.tuioUpEvent);									
			this.addEventListener(TouchEvent.MOUSE_OVER, this.tuioRollOverHandler);									
			this.addEventListener(TouchEvent.MOUSE_OUT, this.tuioRollOutHandler);

			this.addEventListener(MouseEvent.MOUSE_MOVE, this.mouseMoveHandler);									
			this.addEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownEvent);															
			this.addEventListener(MouseEvent.MOUSE_UP, this.mouseUpEvent);	
			this.addEventListener(MouseEvent.ROLL_OVER, this.mouseRollOverHandler);
			this.addEventListener(MouseEvent.ROLL_OUT, this.mouseRollOutHandler);
			
			this.addEventListener(Event.ENTER_FRAME, this.frameUpdate);			
			
			updateGraphics();
		}
		
		function updateGraphics()
		{
			gfxIndicator.rotation = (knobValue+0.5) * 360;
			gfxActiveIndicator.rotation = (knobValue+0.5) * 360;
		//	indicatorText.text = Math.round((knobValue) * 360);
			
			
			//indicatorText.text = knobValue;
		}

		function knobStartDrag()
		{
			isActive = true;
			gfxActiveGlow.visible = true;	
			gfxActiveIndicator.visible = true;
		}
		
		function setMinValue(v:Number)
		{
			// FIXME: add sanity checking
			minValue = v;
		}
		
		function setMaxValue(v:Number)
		{
			maxValue = v;
		}		
		
		
		function knobStopDrag()
		{
			if(isActive)
			{
				isActive = false;
				gfxActiveGlow.visible = false;	
				gfxActiveIndicator.visible = false;
			}
			mouseActive = false;					
		}		
		
		public function setValue(f:Number)
		{
			if(f < 0)
				f = 0.0;
			if(f > 1.0)
				f = 1.0;
			knobValue = f;
			
			updateGraphics();
		}
		
		public function getValue():Number	
		{
			return knobValue;
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
			knobStartDrag();			
			e.stopPropagation();
		}

		public function tuioUpEvent(e:TouchEvent)
		{		
			knobStopDrag();		
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
				var ang:Number = Math.atan2(activeY-gfxRadius, activeX-gfxRadius);
				var val:Number;
				val = 0.25 + (ang / (Math.PI*2));
				val += 0.5;
				val %= 1.0;
				setValue(val);	
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
			knobStartDrag();
		}
		
		public function mouseUpEvent(e:MouseEvent)
		{		

			knobStopDrag();

		}		

		public function mouseMoveHandler(e:MouseEvent)
		{
			if(isActive)
			{
				activeX = this.mouseX;
				activeY = this.mouseY;
				var ang:Number = Math.atan2(activeY-gfxRadius, activeX-gfxRadius);
				var val:Number;
				val = 0.25 + (ang / (Math.PI*2));
				val += 0.5;
				val %= 1.0;
				setValue(val);				
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