package app.core.action{
	import flash.display.Sprite;
	import flash.events.*;
	import flash.geom.Point;

	public dynamic class RotateScale extends Touchable implements ITouch
	{
		private var blob1:Object;
		private var blob2:Object;	
		
		private var curScale:Number;
		private var curAngle:Number;
		private var curPosition:Point = new Point(0,0);
		private var basePos1:Point = new Point(0,0);		
		private var basePos2:Point = new Point(0,0);				

		// NO PUBLICS
		//	get/set state & properties
		public var state:String;
		public var toFront:Boolean = true;
		public var noScale:Boolean = false;
		public var noRotate:Boolean = false;		
		public var noMove:Boolean = false;
		//get/set vel
		public var dX:Number;
		public var dY:Number;		
		public var dAng:Number;
		public var dcoef:Number = 0.5;
			
		public function RotateScale()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, this.added, false, 0, true);			
			this.addEventListener(Event.REMOVED_FROM_STAGE, this.removed, false, 0, true);	
			//this.addEventListener(Event.ENTER_FRAME, this.update, false, 0, true);		
		}	
//----------------------------------------------------------------------------------------------------------- STAGE EVENTS			
		private function added(e)
		{
			state = "none";
			dX = 0;
			dY = 0;
			dAng = 0;		
		}
		private function removed(e)
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, this.added);	
			this.removeEventListener(Event.REMOVED_FROM_STAGE, this.removed);	
			//this.removeEventListener(Event.ENTER_FRAME, this.update, false, 0, true);	
		}
				
//----------------------------------------------------------------------------------------------------------- OVERRIDE FROM TOUCHABLE
		public override function handleBlobCreated(id:int, mx:Number, my:Number)
		{
			trace('blob added');
		}
		
		public override function handleBlobRemoved(id:int)
		{
			trace('blob removed')
		}		
		
		public override function handleDownEvent(id:int, mx:Number, my:Number, targetObj)
		{
			trace('blob down');		
			if(blobs.length == 1)
			{				
				state = "dragging";
				trace("Drag :"+this);					
				curScale = this.scaleX;
				curAngle = this.rotation;					
				curPosition.x = x;
				curPosition.y = y;				
				blob1 = blobs[0];
			} 
			else if(blobs.length == 2)
			{
				state = "rotatescale";
				trace("Scale : "+this+" :"+this.scaleX);		
				trace("Rotate : "+this+" :"+this.rotation);				
				curScale = this.scaleX;
				curAngle = this.rotation;					
				curPosition.x = x;
				curPosition.y = y;		
				
				blob1 = blobs[0];								
				blob2 = blobs[1];		
				
				var curPt1:Point = parent.globalToLocal(new Point(blob1.x, blob1.y));									
				blob1.origX = curPt1.x;
				blob1.origY = curPt1.y;
			}	
				
			if(toFront)
			this.parent.setChildIndex(this, this.parent.numChildren-1);			
		}
		
		public override function handleMoveEvent(id:int, mx:Number, my:Number, targetObj)
		{
			trace('blob move')
			if(state == "dragging")
			{
				var tuioobj:TUIOObject = TUIO.getObjectById(blob1.id);		
				if(!tuioobj)
				{
					handleBlobRemoved(blob1.id);
					return;
				}		
				var curPt:Point = parent.globalToLocal(new Point(tuioobj.x, tuioobj.y));			
				var oldX:Number, oldY:Number;
				oldX = x;
				oldY = y;
				
				if(!noMove)
				{
					x = curPosition.x + (curPt.x - (blob1.origX ));		
					y = curPosition.y + (curPt.y - (blob1.origY ));
				}
				dX *= dcoef;
				dY *= dcoef;						
				dAng *= dcoef;
				dX += x - oldX;
				dY += y - oldY;						
			} 
		else if(state == "rotatescale")
			{
				
				var tuioobj1 = TUIO.getObjectById(blob1.id);
				
		
				if(!tuioobj1)
				{
					handleBlobRemoved(blob1.id);
					return;
				}				
				
				var curPt1:Point = parent.globalToLocal(new Point(tuioobj1.x, tuioobj1.y));								
				
				var tuioobj2 = TUIO.getObjectById(blob2.id);
				
		
				if(!tuioobj2)
				{
					handleBlobRemoved(blob2.id);
					return;
				}								
				
				var curPt2:Point = parent.globalToLocal(new Point(tuioobj2.x, tuioobj2.y));				
				var curCenter:Point = Point.interpolate(curPt1, curPt2, 0.5);				
	

				var origPt1:Point = new Point(blob1.origX, blob1.origY);
				var origPt2:Point = new Point(blob2.origX, blob2.origY);
				var centerOrig:Point = Point.interpolate(origPt1, origPt2, 0.5);
				
				var offs:Point = curCenter.subtract(centerOrig);
				
				var len1:Number = Point.distance(origPt1, origPt2);
				var len2:Number = Point.distance(curPt1, curPt2);					
				var len3:Number = Point.distance(origPt1, new Point(0,0));
				
				
				var newscale:Number = curScale * len2 / len1;			
				
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
				{		
					rotation = curAngle + (ang2 - ang1);	
				}

				var oldX:Number, oldY:Number;
				oldX = x;
				oldY = y;
			
				if(!noMove)
				{	
					x = curPosition.x + (curCenter.x - centerOrig.x);	
					y = curPosition.y + (curCenter.y - centerOrig.y);	
				}				
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
		public override function handleUpEvent(id:int, mx:Number, my:Number, targetObj)
		{
			trace('blob up');		
			handleBlobRemoved(id);
			return;		
		}
		
		public override function handleRollOverEvent(id:int, mx:Number, my:Number, targetObj)
		{
			//trace('blob over');
		}
		
		public override function handleRollOutEvent(id:int, mx:Number, my:Number, targetObj)
		{
			//trace('blob out');		
			handleBlobRemoved(id);
			return;		
		}			
//-----------------------------------------------------------------------------------------------------------		
		private function getAngleTrig(X:Number, Y:Number): Number
		{		
			var GRAD_PI:Number = 180.0 / 3.14159;
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
//-----------------------------------------------------------------------------------------------------------			
		public function released(dx:Number, dy:Number, dang:Number)
		{
		}	
	}
}

