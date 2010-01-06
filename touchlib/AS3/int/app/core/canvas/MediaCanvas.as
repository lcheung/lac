//Generally, this should be used along with ScaleCanvas. 
//This should be the child of ScaleCanvas, but
//all the photos, applications, and any other things will
//be added to this canvas as usual.


package app.core.canvas{
	import app.core.object.ImageObject;
	import app.core.action.Scalable;
	import flash.display.Shape;		
	import flash.events.Event;	
	
	import caurina.transitions.Tweener;
	
	import flash.geom.Point;	      
	import app.core.utl.ColorUtil;
	import app.core.object.TextObject;	

	
	public class MediaCanvas extends Phyiscal
	{		
		private var clickgrabber:Shape = new Shape();	
		private var clickgrabber_center:Shape = new Shape();				
		private var sizeX:int = 10000;
		private var sizeY:int = 10000;
		
		private var velX:Number = 0.0;
		private var velY:Number = 0.0;		
		
		private var velAng:Number = 0.0;
		
		private var friction:Number = 0.85;
		private var angFriction:Number = 0.92;		
	
		private var _canvasName:String;			
		private var TextObject_0:TextObject;			
		public var color:int;	
		
		
		function MediaCanvas(canvasName:String)
		{	
			_canvasName=canvasName;
			bringToFront = false;			
			noScale = false;
			noRotate = false;
			
			color = ColorUtil.random(100,0,0);						
			clickgrabber.graphics.lineStyle(20,color,1.0);
			clickgrabber.graphics.beginFill(0xFF, 0.0);
			clickgrabber.graphics.drawRect(-sizeX/2,-sizeY/2,sizeX,sizeY);
			clickgrabber.graphics.endFill();						
/*			
			clickgrabber_center.graphics.lineStyle(1,0xFF,0.0);
			clickgrabber_center.graphics.beginFill(0xFF0000, 0.45);
			clickgrabber_center.graphics.drawCircle(0,0,25);
			clickgrabber_center.graphics.drawRect(0,0,3,45);
			clickgrabber_center.graphics.endFill();
			
			this.addChild( clickgrabber_center );
*/
			this.addChild( clickgrabber );	
						
			
			
			TextObject_0 = new TextObject(_canvasName, false);	
			TextObject_0.noMove=true;
			TextObject_0.visible=false;
			this.addChild(TextObject_0);	
			
			TextObject_0.visible=true;
			TextObject_0.scaleX = 2.5;
			TextObject_0.scaleY = 2.5;	
			TextObject_0.x=-clickgrabber.width/2+900;	
			TextObject_0.y=-clickgrabber.height/2+100;	
		}
		
		public override function released(dx:Number, dy:Number, dang:Number)
		{
			velX = dx;
			velY = dy;				
			velAng = dang;
		}	
		
		public override function doubleTap()
		{
	   
	    if(parent.scaleX>0.25)
			Tweener.addTween(this, {rotation: 0, x:400*0.5, y:300*0.5,time:0.25, transition:"easeinoutquad"});	
		else
			Tweener.addTween(this, {rotation: 0, x:400*0.5, y:300*0.5,time:0.25, transition:"easeinoutquad"});		
		if(parent.scaleX>0.25)
			Tweener.addTween(parent, {scaleX: 0.25, scaleY: 0.25,time:0.25, transition:"easeinoutquad"});	
		else
			Tweener.addTween(parent, {scaleX: 1, scaleY: 1,time:0.25, transition:"easeinoutquad"});				
		
		}					
	}
}