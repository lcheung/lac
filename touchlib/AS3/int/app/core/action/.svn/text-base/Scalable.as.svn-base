///////////////////////////////////////////////////////////////////////////////////
//This is used for moveable main canvases. 
//This will scale the parent canvas "ScaleCanvas" and move/rotate the child Canvas.
//This allows for the "zoom" to always be centered on the center of the viewing window.
///////////////////////////////////////////////////////////////////////////////////

package app.core.action{
	import flash.events.*;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	
	public dynamic class Scalable extends MovieClip
	{
		public var blobs:Array;		// blobs we are currently interacting with
		private var GRAD_PI:Number = 180.0 / 3.14159;
		public var state:String;
		private var curScale:Number;
		private var curAngle:Number;
		private var curPosition:Point = new Point(0,0);

		private var basePos1:Point = new Point(0,0);		
		private var basePos2:Point = new Point(0,0);				
		
		public var blob1:Object;
		public var blob2:Object;		
		public var bringToFront:Boolean = true;
		public var noScale = false;
		public var noRotate = false;		
		public var noMove = false;
		public var mouseSelection = false;
		
		public var dX:Number;
		public var dY:Number;		
		public var dAng:Number;
		public var dcoef:Number = 0.5;
		
		//DoubleTap variables
		public var xdist:Number;
		public var ydist:Number;
		public var distance:Number;
		private var oldX:Number = 0;
		private var oldY:Number = 0;		
		public var doubleclickDuration:Number = 500;
		public var clickRadius:Number = 50;		
		public var lastClick:Number = 0;
		
		public function Scalable()
		{
			state = "none";

			blobs = new Array();
			this.addEventListener(TouchEvent.MOUSE_MOVE, this.moveHandler, false, 0, true);			
			this.addEventListener(TouchEvent.MOUSE_DOWN, this.downEvent, false, 0, true);						
			this.addEventListener(TouchEvent.MOUSE_UP, this.upEvent, false, 0, true);									
			this.addEventListener(TouchEvent.MOUSE_OVER, this.rollOverHandler, false, 0, true);									
			this.addEventListener(TouchEvent.MOUSE_OUT, this.rollOutHandler, false, 0, true);		
		
			this.addEventListener(MouseEvent.MOUSE_MOVE, this.mouseMoveHandler);									
			this.addEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownEvent);															
			this.addEventListener(MouseEvent.MOUSE_UP, this.mouseUpEvent);	
			//this.addEventListener(MouseEvent.MOUSE_OVER, this.mouseRollOverHandler);
			this.addEventListener(MouseEvent.MOUSE_OUT, this.mouseUpEvent);	
			
			this.addEventListener(MouseEvent.DOUBLE_CLICK, this.doubleTap);										
			
			this.addEventListener(Event.ENTER_FRAME, this.update, false, 0, true);		
		
			
			dX = 0;
			dY = 0;
			
			dAng = 0;
		}
		
		function addBlob(id:Number, origX:Number, origY:Number):void
		{
			for(var i=0; i<blobs.length; i++)
			{
				if(blobs[i].id == id)
					return;
			}
			
			blobs.push( {id: id, origX: origX, origY: origY, myOrigX: x, myOrigY:y} );
			
			if(blobs.length == 1)
			{
				
				state = "dragging";
				trace("Drag :"+this);		
				
				curScale = parent.scaleX;
				curAngle = rotation;					
				curPosition.x = x;
				curPosition.y = y;
				
				blob1 = blobs[0];
			} else if(blobs.length == 2)
			{
				state = "rotatescale";
				trace("Scale : "+this+" :"+parent.scaleX);		
				trace("Rotate : "+this+" :"+rotation);				
				curScale = parent.scaleX;
				curAngle = rotation;					
				curPosition.x = x;
				curPosition.y = y;		
				
				blob1 = blobs[0];								
				blob2 = blobs[1];		
				
				var tuioobj1 = TUIO.getObjectById(blob1.id);
				
				// if not found, then it must have died..
				if(tuioobj1)
				{
					var curPt1:Point = parent.parent.globalToLocal(new Point(tuioobj1.x, tuioobj1.y));									
					
					blob1.origX = curPt1.x;
					blob1.origY = curPt1.y;
				}				

			}
			/* NULLIFY 3rd BLOB... input error correction
			else if(blobs.length == 3)
			{
				return;
			}
			 */
		}
		
		function removeBlob(id:Number):void
		{
			for(var i=0; i<blobs.length; i++)
			{
				if(blobs[i].id == id) 
				{
					blobs.splice(i, 1);
					
					if(blobs.length == 0)
						state = "none";
					if(blobs.length == 1) 
					{
						state = "dragging";					
	
						curScale = parent.scaleX;
						curAngle = rotation;					
						curPosition.x = x;
						curPosition.y = y;					
						
						blob1 = blobs[0];		
						
						var tuioobj1:TUIOObject = TUIO.getObjectById(blob1.id);
						
						// if not found, then it must have died..
						if(tuioobj1)
						{						
							var curPt1:Point = parent.parent.globalToLocal(new Point(tuioobj1.x, tuioobj1.y));
							
							blob1.origX = curPt1.x;
							blob1.origY = curPt1.y;
						}
						
					}
					if(blobs.length >= 2) {
						state = "rotatescale";
						
						//trace(state);				
						curScale = parent.scaleX;
						curAngle = rotation;					
						curPosition.x = x;
						curPosition.y = y;				
						
						blob1 = blobs[0];								
						blob2 = blobs[1];		
						
						tuioobj1 = TUIO.getObjectById(blob1.id);
						
						// if not found, then it must have died..
						if(tuioobj1)
						{
							var curPt1:Point = parent.parent.globalToLocal(new Point(tuioobj1.x, tuioobj1.y));									
							
							blob1.origX = curPt1.x;
							blob1.origY = curPt1.y;
						}									
					}
				
				return;
					
				}
			}			
		}
		
		public function downEvent(e:TouchEvent):void
		{		
			if(e.stageX == 0 && e.stageY == 0)
				return;			
			
			var curPt:Point = parent.parent.globalToLocal(new Point(e.stageX, e.stageY));									
			

			addBlob(e.ID, curPt.x, curPt.y);
			
			if(bringToFront)
				this.parent.setChildIndex(this, this.parent.numChildren-1);
			
				if(mouseSelection)
				{
					//this.alpha=0.5;				
				}
			
			//DoubleTap Gesture
			var tuioobj:TUIOObject = TUIO.getObjectById(e.ID);
			var localPt:Point = globalToLocal(new Point(tuioobj.x, tuioobj.y));
			
			xdist = localPt.x - oldX;
			ydist = localPt.y - oldY;			
			distance = Math.sqrt(xdist*xdist+ydist*ydist);
			oldX = localPt.x;
			oldY = localPt.y;		
			
			//trace(distance);
			
			if (parent.hitTestPoint(localPt.x,localPt.y) && distance <= clickRadius) {

				if (lastClick == 0) {
					lastClick = getTimer();
				} else {
					lastClick = 0;
					trace("Double Tap");
					doubleTap();//perform doubleTap Function
				}
			}//end DoubleTap
				
			e.stopPropagation();
		}
		
		public function upEvent(e:TouchEvent):void
		{		
							
			removeBlob(e.ID);		
			if(mouseSelection)
				{
					//this.alpha=1.0;				
				}				
			e.stopPropagation();				
				
		}		
		
		public function moveHandler(e:TouchEvent):void
		{
//			e.stopPropagation();			
		}
		
		public function rollOverHandler(e:TouchEvent):void
		{
//			e.stopPropagation();			
		}
		
		public function rollOutHandler(e:TouchEvent):void
		{
//			e.stopPropagation();	
		}
		
		public function mouseDownEvent(e:MouseEvent)
		{
				if(e.stageX == 0 && e.stageY == 0)
				return;			
			
			if(!noMove)
				{	this.startDrag();	
				//this.addBlob(1, e.localX, e.localY);
				}
			if(bringToFront)
				this.parent.setChildIndex(this, this.parent.numChildren-1);
				
			if(mouseSelection)
				{	
					//var dropshadow:DropShadowFilter=new DropShadowFilter(0, 45, 0x000000, 0.75, 15, 15);
					//this.filters=new Array(dropshadow);
					//Tweener.addTween(this, {scaleX:1.0, scaleY:1.0, rotation:0, time:0.6, transition:"easeinoutquad"});				
				}
				
			//DoubleTap Gesture			
			xdist = mouseX - oldX;
			ydist = mouseY - oldY;			
			distance = Math.sqrt(xdist*xdist+ydist*ydist);
			oldX = mouseX;
			oldY = mouseY;		
			//trace(distance);
			
			if (parent.hitTestPoint(mouseX,mouseY) && distance <= clickRadius) {

				if (lastClick == 0) {
					lastClick = getTimer();
				} else {
					lastClick = 0;
					trace("Double Tap");
					doubleTap();//perform doubleTap Function
				}
			}//end DoubleTap
			
			e.stopPropagation();
		}
		
		public function mouseUpEvent(e:MouseEvent)
		{	
		if(!noMove)
				{
			this.stopDrag();	
			}
				if(mouseSelection)
				{
					//var targetRotation:int = Math.random()*180 - 90;	
					//var targetScale:Number = (Math.random()*0.4) + 0.3;	
					//this.filters=new Array();
					//Tweener.addTween(this, {scaleX: targetScale, scaleY: targetScale, rotation:targetRotation, time:0.4, transition:"easeinoutquad"});			
				}
			e.stopPropagation();
		}		

		public function mouseMoveHandler(e:MouseEvent)
		{
		//
		}
		
		public function mouseRollOverHandler(e:MouseEvent)
		{
		//
		}
		
		public function mouseRollOutHandler(e:MouseEvent)
		{
			if(!noMove)
			{
			//this.stopDrag();	
			}		
			//e.stopPropagation();
		}	
		
		function getAngleTrig(X:Number, Y:Number): Number
		{
			if (X == 0.0)
			{
				if(Y < 0.0)
					return 270;
				else
					return 90;
			} else if (Y == 0)
			{
				if(X < 0)
					return 180;
				else
					return 0;
			}

			if ( Y > 0.0)
				if (X > 0.0)
					return Math.atan(Y/X) * GRAD_PI;
				else
					return 180.0-Math.atan(Y/-X) * GRAD_PI;
			else
				if (X > 0.0)
					return 360.0-Math.atan(-Y/X) * GRAD_PI;
				else
					return 180.0+Math.atan(-Y/-X) * GRAD_PI;
		} 		
		
		
		
		public function released(dx:Number, dy:Number, dang:Number)
		{
		}
		
		public function doubleTap()
		{
		}		
		
		
		
		private function update(e:Event):void
		{
			//DoubleTap Check
			if (lastClick > 0) {
				if ((getTimer()-lastClick) > doubleclickDuration) {
					lastClick = 0;
					trace("Single Tap");
				}
			}//end DoubleTap Check
			
			
			if(state == "dragging")
			{
				var tuioobj:TUIOObject = TUIO.getObjectById(blob1.id);
				
				// if not found, then it must have died..
				if(!tuioobj)
				{
					removeBlob(blob1.id);
					return;
				}


				var curPt:Point = parent.parent.globalToLocal(new Point(tuioobj.x, tuioobj.y));					//  this.globalToLocal(
				
//				this.x += tuioobj.dX;
//				this.y += tuioobj.dY;				

//				trace("Moving (" + int(blob1.origX) + "," + int(blob1.origY) + ") - (" + int(curPt.x) + "," + int(curPt.y) + ")");
//				trace(curPt.y + " " + blobs[0].origX);

				var oldX:Number, oldY:Number;
				oldX = x;
				oldY = y;
				
				if(!noMove)
				{
					x = curPosition.x + (curPt.x - blob1.origX) / (parent.scaleX);		
					y = curPosition.y + (curPt.y - blob1.origY) / (parent.scaleX);
				}
				
			
				dX *= dcoef;
				dY *= dcoef;						
				dAng *= dcoef;
				dX += x - oldX;
				dY += y - oldY;		
				

				
			} else if(state == "rotatescale")
			{
				
				var tuioobj1 = TUIO.getObjectById(blob1.id);
				
				// if not found, then it must have died..
				if(!tuioobj1)
				{
					removeBlob(blob1.id);
					return;
				}				
				
				var curPt1:Point = parent.parent.globalToLocal(new Point(tuioobj1.x, tuioobj1.y));								
				
				var tuioobj2 = TUIO.getObjectById(blob2.id);
				
				// if not found, then it must have died..
				if(!tuioobj2)
				{
					removeBlob(blob2.id);
					return;
				}								
				
				var curPt2:Point = parent.parent.globalToLocal(new Point(tuioobj2.x, tuioobj2.y));				
				var curCenter:Point = Point.interpolate(curPt1, curPt2, 0.5);				
//				trace(blobs[0].origX + "," + blobs[0].origY);
//				trace(blobs[1].origX + "," + blobs[1].origY);				
				
//				trace(curPt1.x + "," + curPt1.y);
//				trace(curPt2.x + "," + curPt2.y);				

				var origPt1:Point = new Point(blob1.origX, blob1.origY);
				var origPt2:Point = new Point(blob2.origX, blob2.origY);
				var centerOrig:Point = Point.interpolate(origPt1, origPt2, 0.5);
				//trace(parent.parent.stage.stageWidth/2);
				//trace(parent.parent.stage.stageHeight/2);
				//var centerOrig:Point = new Point(parent.parent.stage.stageWidth/2, parent.parent.stage.stageHeight/2);
				
				//var offs:Point = curCenter.subtract(centerOrig);
				
				var len1:Number = Point.distance(origPt1, origPt2);
				var len2:Number = Point.distance(curPt1, curPt2);					
				//var len3:Number = Point.distance(origPt1, new Point(0,0));
				
				
				//trace(tuioobj2.x + " ,  " + tuioobj2.y);
				trace(curPt1 + "    " + curPt2);
				
				var newscale:Number = curScale * len2/len1;

				//Stop ZUI
				//if(newscale < 0.1) newscale = 0.1;
				//if(newscale < 0.1) newscale = 0.1;
		
				//if(newscale > 25.0) newscale = 25.0;
				//if(newscale > 25.0) newscale = 25.0;				
				
				if(!noScale)
				{
					//FIX THE WIGGLE
					//trace(newscale-curScale);
					//if((newscale-curScale)<=1 || (newscale-curScale)>=-1){
					parent.scaleX = newscale;
					parent.scaleY = newscale;
					//trace(newscale);
					//}			
				}
	
				var origLine:Point = origPt1;
				origLine = origLine.subtract(origPt2);
				
				var ang1:Number = getAngleTrig(origLine.x, origLine.y);
				
				var curLine:Point = curPt1;
				curLine = curLine.subtract(curPt2);
				
				var ang2:int = getAngleTrig(curLine.x, curLine.y);
				var oldAngle:int = rotation;
				
				if(!noRotate)	
				{		
					//FIX THE WIGGLE
					//trace(curAngle-oldAngle);	
					//if((curAngle-oldAngle)<=50|| (curAngle-oldAngle)>=-50)
					rotation = curAngle + (ang2 - ang1);			
				}
				
//				x = curPt1.x - ((curLine.x / len2) * len3 * newscale);
//				y = curPt1.y - ((curLine.y / len2) * len3 * newscale);

				var oldX:Number, oldY:Number;
				oldX = x;
				oldY = y;
			
				if(!noMove)
				{
					x = (curPosition.x + (curCenter.x - centerOrig.x));	
					y = (curPosition.y + (curCenter.y - centerOrig.y));	
				}
			
				
				dX *= dcoef;
				dY *= dcoef;		
				dAng *= dcoef;				
				
				dX += x - oldX;
				dY += y - oldY;
				
				dAng += rotation - oldAngle;
				
			
				parent.clickgrabber_center.rotation = rotation;
				
		

			} else {
				if(dX != 0 || dY != 0)
				{
					this.released(dX, dY, dAng);
					dX = 0;
					dY = 0;
					dAng = 0;
				}
			}
			
			}	
				
	}
}

