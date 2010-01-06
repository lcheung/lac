package app.demo.musicalSquares {
	
	import flash.display.Shape;		
	import flash.events.Event;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import flash.events.*;
	import app.core.action.RotatableScalable;
	
	public class CollidingCanvas extends RotatableScalable
	{	
		private var clickgrabber:Shape = new Shape();				
		private var border:Shape = new Shape();	
		
		private var scaleXTween:Tween;	
		private var scaleYTween:Tween;
		private var thisscaleXTween:Tween;	
		private var thisscaleYTween:Tween;
		private var rotationTween:Tween;
		private var xTween:Tween;
		private var yTween:Tween;
		
		function CollidingCanvas()
		{
			bringToFront = true;			
			noScale = false;
			noRotate = true;	
			noMove = true;
			
			var collider = new Colliding();
			addChild(collider);
		
		
			clickgrabber.graphics.beginFill(0xFFFFFF, 0);
			clickgrabber.graphics.drawRect(0, 0, 1,1);
			clickgrabber.graphics.endFill();	
			
			border.graphics.lineStyle( 10, 0xFFFFFF, .1, false, "none");
			border.graphics.drawRoundRect(-400, -300, 800,600, 40);
			
			this.addChild( clickgrabber );		
			this.addChild( border );		

			collider.x = -collider.width/2 - 40;
			collider.y = -collider.height/2 - 20;				
			collider.scaleX = 1;
			collider.scaleY = 1;					
			clickgrabber.scaleX = collider.width + 160;
			clickgrabber.scaleY = collider.height + 80;				
			clickgrabber.x = collider.x;
			clickgrabber.y = collider.y;	
			border.x = 40;
			border.y = 25; 
			
			this.setChildIndex(collider, this.numChildren-1);
		}		
		
		
		public override function doubleTap()
		{
			scaleXTween = new Tween(parent, "scaleX", Regular.easeOut, parent.scaleX, .9, .5, true);
			scaleYTween = new Tween(parent, "scaleY", Regular.easeOut, parent.scaleY, .9, .5, true);
			thisscaleXTween = new Tween(this, "scaleX", Regular.easeOut, this.scaleX, .9, .5, true);
			thisscaleYTween = new Tween(this, "scaleY", Regular.easeOut, this.scaleY, .9, .5, true);
			rotationTween = new Tween(parent, "rotation", Regular.easeOut, parent.rotation, 0, .5, true);
			xTween = new Tween(parent, "x", Regular.easeOut, parent.x, 0, .5, true);
			yTween = new Tween(parent, "y", Regular.easeOut, parent.y, 0, .5, true);
		}		
	}
}