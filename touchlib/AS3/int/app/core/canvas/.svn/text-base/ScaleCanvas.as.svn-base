package app.core.canvas {
	
	import flash.display.Shape;		
	import flash.events.Event;
	import flash.display.Sprite;
	import com.touchlib.*;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	
	public class ScaleCanvas extends Sprite
	{	
		private var clickgrabber:Shape = new Shape();				
		public var clickgrabber_center:Shape = new Shape();				

		private var sizeX:int = 10000;
		private var sizeY:int = 10000;
				
		private var scaleXTween:Tween;	
		private var scaleYTween:Tween;
		private var rotationTween:Tween;
		private var xTween:Tween;
		private var yTween:Tween;
		
		function ScaleCanvas()
		{		
			clickgrabber.graphics.lineStyle();
			clickgrabber.graphics.beginFill(0xFF, 0.0);
			clickgrabber.graphics.drawRect(-sizeX/2,-sizeY/2,sizeX,sizeY);
			clickgrabber.graphics.endFill();						
			
			clickgrabber_center.graphics.lineStyle(1,0xFF,0.0);
			clickgrabber_center.graphics.beginFill(0xFF0000, 0.45);
			clickgrabber_center.graphics.drawCircle(0,0,25);
			clickgrabber_center.graphics.drawRect(0,0,3,45);
			clickgrabber_center.graphics.endFill();
			
			this.addChild( clickgrabber );	
			this.addChild( clickgrabber_center );			
		}
		
	/*	public override function doubleTap()
		{
			scaleXTween = new Tween(this, "scaleX", Regular.easeOut, this.scaleX, .9, .5, true);
			scaleYTween = new Tween(this, "scaleY", Regular.easeOut, this.scaleY, .9, .5, true);
			rotationTween = new Tween(this, "rotation", Regular.easeOut, this.rotation, 0, .5, true);
			xTween = new Tween(this, "x", Regular.easeOut, this.x, 0, .5, true);
			yTween = new Tween(this, "y", Regular.easeOut, this.y, 0, .5, true);
		}
	*/
	}
}