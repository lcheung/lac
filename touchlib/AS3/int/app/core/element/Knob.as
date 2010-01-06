// A basic knob that listens to both TUIO events and regular MouseEvents.
// TODO: add ability to dispatch events when the value changes.. 

package app.core.element
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import flash.display.Sprite;		
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import flash.events.*;
		
	import flash.geom.Point;			

	public class Knob extends Sprite
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
		
		

		public function Knob(diam:Number)
		{
			//var knob_Shadow : DropShadowFilter = new DropShadowFilter(4,30,0,.5,10,10);
			
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
			

			
			this.graphics.beginFill(0x373737, 1);
			this.graphics.drawCircle(gfxRadius, gfxRadius, gfxRadius);
			
			var tf:TextFormat = new TextFormat();
			tf.color = 0xffffff;
			tf.align = "center";
			tf.font = "Arial";
			tf.size = "10";
			indicatorText = new TextField();
			indicatorText.x = 0;
			indicatorText.y = gfxRadius*2+5;
			indicatorText.width = gfxRadius*2;
			indicatorText.height = 14;	
			indicatorText.selectable = false;
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
			indicatorText.text = Math.round((knobValue) * 360);
			
			
			indicatorText.text = knobValue;
		}

		function knobStartDrag()
		{
			isActive = true;
			//gfxActiveGlow.visible = true;	
			gfxActiveIndicator.visible = true;
		}
		
		public function setMinValue(v:Number = 0)
		{
			if(v < 0)
				return;
				
			minValue = v;
		}
		
		public function setMaxValue(v:Number = 1.0)
		{
			if(maxValue > 1.0)
				return;
			maxValue = v;
		}		
		
		public function hideLabel()
		{
			indicatorText.visible = false;
		}
		public function showLabel()
		{
			indicatorText.visible = true;
		}		
		
		function knobStopDrag()
		{
			if(isActive)
			{
				isActive = false;
			//	gfxActiveGlow.visible = false;	
				gfxActiveIndicator.visible = false;
			}
			mouseActive = false;					
		}		
		
		public function setValue(f:Number)
		{
			if(f < minValue)
				f = minValue;
			if(f > maxValue)
				f = maxValue;
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