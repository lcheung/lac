package app.core.action
{
	import flash.events.*;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public dynamic class Scrollable extends MovieClip
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
		public var noScale = true;
		public var noRotate = false;		
		public var noMove = false;
		
		public var dX:Number;
		public var dY:Number;		
		public var dAng:Number;
		public var dcoef:Number = 0.5;
		
		public function Scrollable()
		{
			state = "none";

			blobs = new Array();
			this.addEventListener(TouchEvent.MOUSE_MOVE, this.moveHandler, false, 0, true);			
			this.addEventListener(TouchEvent.MOUSE_DOWN, this.downEvent, false, 0, true);						
			this.addEventListener(TouchEvent.MOUSE_UP, this.upEvent, false, 0, true);									
			//this.addEventListener(TouchEvent.RollOverEvent, this.rollOverHandler, false, 0, true);									
			//this.addEventListener(TouchEvent.RollOutEvent, this.rollOutHandler, false, 0, true);												
			this.addEventListener(Event.ENTER_FRAME, this.update, false, 0, true);			
			
			this.addEventListener(MouseEvent.MOUSE_MOVE, this.mouseMoveHandler);									
			this.addEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownEvent);															
			this.addEventListener(MouseEvent.MOUSE_UP, this.mouseUpEvent);	
			this.addEventListener(MouseEvent.ROLL_OVER, this.mouseRollOverHandler);
			this.addEventListener(MouseEvent.ROLL_OVER, this.mouseRollOutHandler);	
			
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
				trace("Drag : ");
				
				curScale = this.scaleX;
				curAngle = this.rotation;					
				curPosition.x = x;
				curPosition.y = y;
				
				blob1 = blobs[0];
			} else if(blobs.length == 2)
			{
				state = "rotatescale";
				trace("Scale : "+this.scaleX);		
				trace("Rotation : "+this.rotation);				
				curScale = this.scaleX;
				curAngle = this.rotation;					
				curPosition.x = x;
				curPosition.y = y;		
				
				blob1 = blobs[0];								
				blob2 = blobs[1];		
				
				var tuioobj1 = TUIO.getObjectById(blob1.id);
				
				// if not found, then it must have died..
				if(tuioobj1)
				{
					var curPt1:Point = parent.globalToLocal(new Point(tuioobj1.x, tuioobj1.y));									
					
					blob1.origX = curPt1.x;
					blob1.origY = curPt1.y;
				}				
				

			}
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
	
						curScale = this.scaleX;
						curAngle = this.rotation;					
						curPosition.x = x;
						curPosition.y = y;					
						
						blob1 = blobs[0];		
						
						var tuioobj1 = TUIO.getObjectById(blob1.id);
						
						// if not found, then it must have died..
						if(tuioobj1)
						{						
							var curPt1:Point = parent.globalToLocal(new Point(tuioobj1.x, tuioobj1.y));
							
							blob1.origX = curPt1.x;
							blob1.origY = curPt1.y;
						}
						
					}
					if(blobs.length >= 2) {
						state = "rotatescale";
						
						//trace(state);				
						curScale = this.scaleX;
						curAngle = this.rotation;					
						curPosition.x = x;
						curPosition.y = y;				
						
						blob1 = blobs[0];								
						blob2 = blobs[1];		
						
						var tuioobj1 = TUIO.getObjectById(blob1.id);
						
						// if not found, then it must have died..
						if(tuioobj1)
						{
							var curPt1:Point = parent.globalToLocal(new Point(tuioobj1.x, tuioobj1.y));									
							
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
			
			var curPt:Point = parent.globalToLocal(new Point(e.stageX, e.stageY));									
			

			addBlob(e.ID, curPt.x, curPt.y);
			
			if(bringToFront)
				this.parent.setChildIndex(this, this.parent.numChildren-1);
				
			e.stopPropagation();
		}
		
		public function upEvent(e:TouchEvent):void
		{		
							
			removeBlob(e.ID);			
				
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
			//e.stopPropagation();
			
		}
		
		public function mouseDownEvent(e:MouseEvent)
		{
				if(e.stageX == 0 && e.stageY == 0)
				return;	
				this.startDrag();	
				//this.x=0;
				
				if(bringToFront)
				this.parent.setChildIndex(this, this.parent.numChildren-1);
				
				e.stopPropagation();
		}
		
		public function mouseUpEvent(e:MouseEvent)
		{	
			this.stopDrag();	
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
		
		
		
		
		private function update(e:Event):void
		{

			if(!noMove){
			
			if(state == "dragging")
			{
				var tuioobj:TUIOObject = TUIO.getObjectById(blob1.id);
				
				// if not found, then it must have died..
				if(!tuioobj)
				{
					removeBlob(blob1.id);
					return;
				}


				var curPt:Point = parent.globalToLocal(new Point(tuioobj.x, tuioobj.y));					//  this.globalToLocal(
				
//				this.x += tuioobj.dX;
//				this.y += tuioobj.dY;				

//				trace("Moving (" + int(blob1.origX) + "," + int(blob1.origY) + ") - (" + int(curPt.x) + "," + int(curPt.y) + ")");
//				trace(curPt.y + " " + blobs[0].origX);

				var oldX:Number, oldY:Number;
				oldX = x;
				oldY = y;

				//x = curPosition.x + (curPt.x - (blob1.origX ));		
				
				y = curPosition.y + (curPt.y - (blob1.origY ));
				
				dX *= dcoef;
				dY *= dcoef;						
				dAng *= dcoef;
				//dX += x - oldX;
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
				
				var curPt1:Point = parent.globalToLocal(new Point(tuioobj1.x, tuioobj1.y));								
				
				var tuioobj2 = TUIO.getObjectById(blob2.id);
				
				// if not found, then it must have died..
				if(!tuioobj2)
				{
					removeBlob(blob2.id);
					return;
				}								
				
				var curPt2:Point = parent.globalToLocal(new Point(tuioobj2.x, tuioobj2.y));				
				var curCenter:Point = Point.interpolate(curPt1, curPt2, 0.5);				
//				trace(blobs[0].origX + "," + blobs[0].origY);
//				trace(blobs[1].origX + "," + blobs[1].origY);				
				
//				trace(curPt1.x + "," + curPt1.y);
//				trace(curPt2.x + "," + curPt2.y);				

				var origPt1:Point = new Point(blob1.origX, blob1.origY);
				var origPt2:Point = new Point(blob2.origX, blob2.origY);
				var centerOrig:Point = Point.interpolate(origPt1, origPt2, 0.5);
				
				var offs:Point = curCenter.subtract(centerOrig);
				
				var len1:Number = Point.distance(origPt1, origPt2);
				var len2:Number = Point.distance(curPt1, curPt2);				
				
				var len3:Number = Point.distance(origPt1, new Point(0,0));
				
//				trace(len2 + " / " + len1);
				
				var newscale:Number = curScale * len2 / len1;

				if(newscale < 0.1) newscale = 0.1;
				if(newscale < 0.1) newscale = 0.1;

				//Stop ZUI
				//if(newscale > 25.0) newscale = 25.0;
				//if(newscale > 25.0) newscale = 25.0;				
				
				if(!noScale)
				{
					scaleX = newscale;
					scaleY = newscale;				
				}
	
				var origLine:Point = origPt1;
				origLine = origLine.subtract(origPt2);
				
				var ang1:Number = getAngleTrig(origLine.x, origLine.y);
				
				var curLine:Point = curPt1;
				curLine = curLine.subtract(curPt2);
				
				var ang2:int = getAngleTrig(curLine.x, curLine.y);
				var oldAngle:int = rotation;
				if(!noRotate)
					rotation = curAngle + (ang2 - ang1);
				
//				x = curPt1.x - ((curLine.x / len2) * len3 * newscale);
//				y = curPt1.y - ((curLine.y / len2) * len3 * newscale);

				var oldX:Number, oldY:Number;
				oldX = x;
				oldY = y;
				//x = curPosition.x + (curCenter.x - centerOrig.x);
				x = curPosition.x ;
				y = curPosition.y + (curCenter.y - centerOrig.y);				
				
				
				dX *= dcoef;
				dY *= dcoef;		
				dAng *= dcoef;				
				
				dX += x - oldX;
				dY += y - oldY;
				
				dAng += rotation - oldAngle;
				
				
		

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
}

