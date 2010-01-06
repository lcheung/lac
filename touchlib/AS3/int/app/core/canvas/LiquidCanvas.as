package app.core.canvas{
	import app.core.object.ImageObject;
	import app.core.action.RotatableScalable;
	import flash.display.Shape;		
	import flash.events.Event;
	import flash.geom.Point;	      
	import app.core.utl.ColorUtil;
	
	public class LiquidCanvas extends RotatableScalable
	{		
		private var clickgrabber:Shape = new Shape();				
		private var sizeX:int = 1200;
		private var sizeY:int = 1000;
			
		function LiquidCanvas()
		{
			bringToFront = false;			
			noScale = false;
			noRotate = false;
			noMove = false;
			
			clickgrabber.graphics.lineStyle(5,0xFF0000,0.35);
			clickgrabber.graphics.beginFill(0xFF, 0.0);
			clickgrabber.graphics.drawRect(-sizeX/2,-sizeY/2,sizeX,sizeY);
			clickgrabber.graphics.endFill();					
			this.addChild( clickgrabber );		
		
		}		
	}
}