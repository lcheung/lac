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
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import app.core.action.RotatableScalable;

	import flash.events.*;
	import app.demo.multiKey.*;
	import flash.display.Sprite;	
	

	public class AddPiano extends RotatableScalable {
		
		private var clickgrabber:Shape = new Shape();
		
		private var velX:Number = 0.0;
		private var velY:Number = 0.0;			
		private var velAng:Number = 0.0;		
		private var friction:Number = 0.85;
		private var angFriction:Number = 0.92;
		
		private var scaleXTween:Tween;	
		private var scaleYTween:Tween;
		private var thisscaleXTween:Tween;	
		private var thisscaleYTween:Tween;
		private var rotationTween:Tween;
		private var xTween:Tween;
		private var yTween:Tween;
		private var thisXTween:Tween;
		private var thisyTween:Tween;
		
		var wholePiano:AssemblePiano;


		public function AddPiano(octaves:int) {
			
			wholePiano = new AssemblePiano(octaves);			
			
			bringToFront = true;
			noScale = true;               //make it not scale
			noRotate = true;              //make it not rotate
			noMove = true;                //make it not move
			wholePiano.noSound = false;   //sound is on
			
	
			moveScalePoints(octaves);
			
			clickgrabber.graphics.beginFill(0xFFFFFF, 0);
			clickgrabber.graphics.drawRect(0, 0, 1,1);
			clickgrabber.graphics.endFill();			

			addChild(wholePiano); 
			addChild(clickgrabber);		
			
			arrange();
			this.setChildIndex(wholePiano, this.numChildren-1);
			this.addEventListener(Event.ENTER_FRAME, slide);			
		}				
		
		
		private function arrange() {

				wholePiano.x = -wholePiano.width/2;
				wholePiano.y = -wholePiano.height/2;
				
				wholePiano.scaleX = 1;
				wholePiano.scaleY = 1;	
				
				clickgrabber.scaleX = wholePiano.width;
				clickgrabber.scaleY = wholePiano.height;
				
				clickgrabber.x = -wholePiano.width/2;
				clickgrabber.y = -wholePiano.height/2;
		}		
		
		
		public override function released(dx:Number, dy:Number, dang:Number) {
			
			velX = dx;			
			velY = dy;					
			velAng = dang;
		}
		
		public override function doubleTap()
		{
			if (!noMove)
			{ 
				scaleXTween = new Tween(parent, "scaleX", Regular.easeOut, parent.scaleX, .9, .5, true);
				scaleYTween = new Tween(parent, "scaleY", Regular.easeOut, parent.scaleY, .9, .5, true);
				thisscaleXTween = new Tween(this, "scaleX", Regular.easeOut, this.scaleX, .22, .5, true);
				thisscaleYTween = new Tween(this, "scaleY", Regular.easeOut, this.scaleY, .22, .5, true);
				thisXTween = new Tween(this, "x", Regular.easeOut, this.x, Math.random() * 500, .5, true);
				thisYTween = new Tween(this, "y", Regular.easeOut, this.y, Math.random() * 500, .5, true);
				rotationTween = new Tween(parent, "rotation", Regular.easeOut, parent.rotation, 0, .5, true);
				xTween = new Tween(parent, "x", Regular.easeOut, parent.x, 0, .5, true);
				yTween = new Tween(parent, "y", Regular.easeOut, parent.y, 0, .5, true);
			}
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
		
		
		
		private function moveScalePoints(octaves:int){
			
			var scalePoints:Sprite = new Sprite();             
			
			if (octaves == 2)
			{			
				var outlineW:Number = -wholePiano.width - 80 ;
				var outlineH:Number = -wholePiano.height - 80;			
			}		
			if (octaves == 1) 
			{
				var outlineW:Number = -920;
				var outlineH:Number = 680;
			}			
			
			scalePoints.graphics.lineStyle(4, 0xffffff, 1);
			scalePoints.graphics.beginFill(0xFFFFFF, .8);
			scalePoints.graphics.moveTo(-outlineW/2, -outlineH/2);
			scalePoints.graphics.lineTo(outlineW/2, -outlineH/2);
			scalePoints.graphics.lineTo(outlineW/2, outlineH/2);
			scalePoints.graphics.lineTo(-outlineW/2, outlineH/2);
			scalePoints.graphics.lineTo(-outlineW/2, -outlineH/2);
			scalePoints.graphics.endFill();	
					
			scalePoints.graphics.lineStyle(15, 0xFFFFFF, 1 );
			scalePoints.graphics.moveTo(-outlineW/2, -outlineH/2);
			scalePoints.graphics.lineTo(-outlineW/2.2, -outlineH/2);
			scalePoints.graphics.moveTo(-outlineW/2, -outlineH/2);
			scalePoints.graphics.lineTo(-outlineW/2, -outlineH/2.5);			
			scalePoints.graphics.moveTo(outlineW/2, -outlineH/2);
			scalePoints.graphics.lineTo(outlineW/2.2, -outlineH/2);
			scalePoints.graphics.moveTo(outlineW/2, -outlineH/2);
			scalePoints.graphics.lineTo(outlineW/2, -outlineH/2.5);			
			scalePoints.graphics.moveTo(-outlineW/2, outlineH/2);
			scalePoints.graphics.lineTo(-outlineW/2, outlineH/2.5);
			scalePoints.graphics.moveTo(-outlineW/2, outlineH/2);
			scalePoints.graphics.lineTo(-outlineW/2.2, outlineH/2);
			scalePoints.graphics.moveTo(outlineW/2, outlineH/2);
			scalePoints.graphics.lineTo(outlineW/2.2, outlineH/2);
			scalePoints.graphics.moveTo(outlineW/2, outlineH/2);
			scalePoints.graphics.lineTo(outlineW/2, outlineH/2.5);
			
			addChild(scalePoints);

			scalePoints.addEventListener(TouchEvent.MOUSE_DOWN, toggleRotateScale);
		}		
		
			
		public function toggleRotateScale(event:TouchEvent):void {
			
				//Move Mode sets all modes
				if (noMove) {
					noMove = false; 
					noScale = false;
					noRotate= false;
					var colorTransform:ColorTransform = transform.colorTransform;
					colorTransform.color = 0xFFFF99;
					event.target.transform.colorTransform = colorTransform;
					trace("move, scale, rotate mode off");
					this.setChildIndex(clickgrabber, this.numChildren-1); //sets clickgrabber to front
				}
				else {
					noMove = true;
					noScale = true;
					noRotate = true;
					var colorTransform:ColorTransform = transform.colorTransform;
					colorTransform.color = 0xFFFFFF;
					event.target.transform.colorTransform = colorTransform;
					trace("move, scale, rotate mode on");
					this.setChildIndex(wholePiano, this.numChildren-1); //sets clickgrabber to back
				}				
				
				//Sound Mode			
				if (wholePiano.noSound) {
					wholePiano.noSound = false; 
					trace("sound is on");
				}
				else {
					wholePiano.noSound = true;
					trace("sound is off");
				}	
		}
	}
}