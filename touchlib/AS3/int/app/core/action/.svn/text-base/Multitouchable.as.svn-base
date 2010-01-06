// This will be a low level class that handles the basics of tracking multiple blob id's that may affect this Sprite. This includes touching this Sprite,
// moving over this sprite. It handles keeping a list of blob id's that are alive and firing off event handler functions. When you extend this class
// you just implement the event handler funcs. This class will be used to greatly simplify the paint canvas and could also be used to simplify 'RotatableScalable'.

package app.core.action
{
	import flash.display.*;		
	import flash.events.*;
	import flash.events.*;		
	import flash.geom.Point;
	import app.core.utl.*
	
	public class Multitouchable extends MovieClip
	{
		protected var blobs:Array;		// blobs we are currently interacting with			
//---------------------------------------------------------------------------------------------------------------------------------------------
// CONSTRUCTOR
//---------------------------------------------------------------------------------------------------------------------------------------------
		public function Multitouchable()
		{
			blobs = new Array();
			// MOUSE
			this.addEventListener(TouchEvent.MOUSE_MOVE, this.moveHandler, false, 0, true);			
			this.addEventListener(TouchEvent.MOUSE_DOWN, this.downHandler, false, 0, true);						
			this.addEventListener(TouchEvent.MOUSE_UP, this.upHandler, false, 0, true);									
			this.addEventListener(TouchEvent.MOUSE_OVER, this.rollOverHandler, false, 0, true);									
			this.addEventListener(TouchEvent.MOUSE_OUT, this.rollOutHandler, false, 0, true);		
			// TOUCH
			this.addEventListener(MouseEvent.MOUSE_MOVE, this.mouseMoveHandler, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownHandler, false, 0, true);			
			this.addEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler, false, 0, true);
			//this.addEventListener(MouseEvent.MOUSE_OVER, this.mouserollOverHandler, false, 0, true);									
			//this.addEventListener(MouseEvent.MOUSE_OUT, this.mouserollOutHandler, false, 0, true);
			this.addEventListener(Event.ADDED_TO_STAGE, this.mtAddedToStage, false, 0, true);			
			this.addEventListener(Event.REMOVED_FROM_STAGE, this.mtRemovedFromStage, false, 0, true);						
		}
//---------------------------------------------------------------------------------------------------------------------------------------------
// PUBLIC METHODS
//---------------------------------------------------------------------------------------------------------------------------------------------
		public function getBlobInfo(id:int):Object
		{
			for(var i:int=0; i<blobs.length; i++)
			{
				if(blobs[i].id == id)
					return blobs[i];
			}			
			
			return null;
		}
//---------------------------------------------------------------------------------------------------------------------------------------------
// PRIVATE METHODS
//---------------------------------------------------------------------------------------------------------------------------------------------
		private function mtAddedToStage(e:Event):void
		{
			if(this.stage)
			{
				this.stage.addEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler, false, 0, true);
				
				this.stage.addEventListener(MouseEvent.MOUSE_MOVE, this.stageMouseMoveHandler, false, 0, true);				
				
				this.stage.addEventListener(KeyboardEvent.KEY_DOWN, this.mtKeyPressed, false, 0, true);				
			}
		}
//---------------------------------------------------------------------------------------------------------------------------------------------
		private function mtRemovedFromStage(e:Event):void
		{
			if(this.stage)
			{
				this.stage.removeEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
				
				this.stage.addEventListener(MouseEvent.MOUSE_MOVE, this.stageMouseMoveHandler);				
				
				this.stage.addEventListener(KeyboardEvent.KEY_DOWN, this.mtKeyPressed);				
			}
		}		
//---------------------------------------------------------------------------------------------------------------------------------------------
		private function mtKeyPressed(k:KeyboardEvent):void
		{
			//trace(k.keyCode);
			var ts:TUIOSimulator;
			var pt:Point;
			
			if(k.keyCode == 32)
			{
				trace('rotate');
				pt = new Point(mouseX, mouseY);
				pt = this.localToGlobal(pt);
				if(!this.hitTestPoint(pt.x, pt.y))
					return;			
				ts = new TUIOSimulator(this, "2", pt.x, pt.y, 2, 100);
			}
			if(k.keyCode == 17)
			{
				pt = new Point(mouseX, mouseY);
				pt = this.localToGlobal(pt);
				if(!this.hitTestPoint(pt.x, pt.y))
					return;			
				ts = new TUIOSimulator(this, "1", pt.x, pt.y, 2, 100);
			}			
			
			if(k.keyCode == 16)
			{
				pt = new Point(mouseX, mouseY);
				pt = this.localToGlobal(pt);
				if(!this.hitTestPoint(pt.x, pt.y))
					return;			
				ts = new TUIOSimulator(this, "0", pt.x, pt.y, 2, 100);
			}			
		}
//---------------------------------------------------------------------------------------------------------------------------------------------
		private function idExists(id:int):Boolean
		{
			for(var i:int=0; i<blobs.length; i++)
			{
				if(blobs[i].id == id)
					return true;
			}
			return false;
		}
//---------------------------------------------------------------------------------------------------------------------------------------------
		private function addBlob(id:int, origX:Number, origY:Number, c:Boolean):void
		{
			if(idExists(id))
				return;

			trace("Creating new blob " + id + " " + origX + " " + origY + " " + c) ;
			blobs.push( {id: id, clicked:c, origX: origX, origY:origY, clicked:c, history:new Array(new Point(origX, origY)), dX:0.0, dY:0.0, x: origX, y:origY} );
			
			handleBlobCreated(id, origX, origY);
		}
//---------------------------------------------------------------------------------------------------------------------------------------------
		private function removeBlob(id:int):void
		{
			for(var i:int=0; i<blobs.length; i++)
			{
				if(blobs[i].id == id) 
				{
					//trace("blob removed " + id);										
					handleBlobRemoved(id);										
					blobs.splice(i, 1);		

					return;
				}
			}
		}	
//---------------------------------------------------------------------------------------------------------------------------------------------
		// One of the blobs changed position
		private function updateBlob(id:int, origX:Number, origY:Number):void
		{
			var i:int = 0;
			for(i=0; i<blobs.length; i++)
			{
				if(blobs[i].id == id) 
				{
					blobs[i].history.push(new Point(origX, origY));
					blobs[i].x = origX;
					blobs[i].y = origY;
					//trace("Update blob " + id + " " + origX + "," + origY);
					
					if(blobs[i].history.length >= 2)
					{
						var len:int = blobs[i].history.length;
						blobs[i].dX = blobs[i].history[len-1].x - blobs[i].history[len-2].x;
						blobs[i].dY = blobs[i].history[len-1].y - blobs[i].history[len-2].y;						

//						trace("X: " + blobs[i].history[len-1].x + "," + blobs[i].history[len-2].x);
						//trace("DELTA : " + blobs[i].dX + "," + blobs[i].dY);
					}
					
//					trace(blobs[i].history.length);
					return;
				}
			}
			

		}
//---------------------------------------------------------------------------------------------------------------------------------------------
		private function downHandler(e:TouchEvent):void
		{
//			trace("tuio down handler");			
			if(e.stageX == 0 && e.stageY == 0)
				return;			
				
			TUIO.addObjectListener(e.ID, this);							
			
			var curPt:Point = this.globalToLocal(new Point(e.stageX, e.stageY));												

			addBlob(e.ID, curPt.x, curPt.y, true);
			
			handleDownEvent(e.ID, curPt.x, curPt.y, e.target);
			e.stopPropagation();			
		}
//---------------------------------------------------------------------------------------------------------------------------------------------
		private function upHandler(e:TouchEvent):void
		{
//			trace("tuio up handler");			
			handleUpEvent(e.ID);
			removeBlob(e.ID);
			e.stopPropagation();
		}		
//---------------------------------------------------------------------------------------------------------------------------------------------
		private function moveHandler(e:TouchEvent):void
		{
//			trace("tuio Move handler");
			if(e.stageX == 0 && e.stageY == 0)
				return;			
			
			var curPt:Point = this.globalToLocal(new Point(e.stageX, e.stageY));															
			
			if(!idExists(e.ID))
			{
				trace("Error, shouldn't this blob already be in the list?");
				//TUIO.addObjectListener(e.ID, this);			
				addBlob(e.ID, curPt.x, curPt.y, false);
			} else {
				updateBlob(e.ID, curPt.x, curPt.y);				
			}
			
			handleMoveEvent(e.ID, curPt.x, curPt.y, e.target);			
			
			e.stopPropagation();						
		}		
//---------------------------------------------------------------------------------------------------------------------------------------------
		private function mouseDownHandler(e:MouseEvent):void
		{
			//trace("Mouse down");
			var curPt:Point = this.globalToLocal(new Point(e.stageX, e.stageY));			
			addBlob(0, curPt.x, curPt.y, true);
			
			e.stopPropagation();								
			handleDownEvent(0, curPt.x, curPt.y, e.target);
			

		}
//---------------------------------------------------------------------------------------------------------------------------------------------
		private function mouseMoveHandler(e:MouseEvent):void
		{
			//trace("Mouse move");			
			var curPt:Point = this.globalToLocal(new Point(e.stageX, e.stageY));						
			
			if(!idExists(0))
			{
				e.stopPropagation();				
				return;				
			} else {
				updateBlob(0, curPt.x, curPt.y);				
			}
			e.stopPropagation();			
			handleMoveEvent(0, curPt.x, curPt.y, e.target);
			
		}
//---------------------------------------------------------------------------------------------------------------------------------------------
		private function stageMouseMoveHandler(e:MouseEvent):void
		{
			//trace("Mouse move");			
			var curPt:Point = this.globalToLocal(new Point(e.stageX, e.stageY));						
			
			if(!idExists(0))
			{
				e.stopPropagation();				
				return;				
			} else {
				updateBlob(0, curPt.x, curPt.y);				
			}
			e.stopPropagation();			
			handleMoveEvent(0, curPt.x, curPt.y, e.target);
			
		}		
//---------------------------------------------------------------------------------------------------------------------------------------------
		private function mouseUpHandler(e:MouseEvent):void
		{
			//trace("Mouse up");
			handleUpEvent(0);
			removeBlob(0);			
			e.stopPropagation();	
		}		
//---------------------------------------------------------------------------------------------------------------------------------------------
		private function rollOverHandler(e:TouchEvent):void
		{
			//trace("Rollover");
			if(e.stageX == 0 && e.stageY == 0)
				return;			
			
			var curPt:Point = this.globalToLocal(new Point(e.stageX, e.stageY));																		
			
			if(!idExists(e.ID))
			{
				TUIO.addObjectListener(e.ID, this);			
				addBlob(e.ID, curPt.x, curPt.y, false);
			}
			handleRollOverEvent(e.ID, curPt.x, curPt.y);			
			e.stopPropagation();									
		}
//---------------------------------------------------------------------------------------------------------------------------------------------
		private function rollOutHandler(e:TouchEvent):void
		{
			//trace("Rollout");
			if(e.stageX == 0 && e.stageY == 0)
				return;			
		
		// FIXME: only remove if not clicked?
			var curPt:Point = this.globalToLocal(new Point(e.stageX, e.stageY));												
			handleRollOutEvent(e.ID, curPt.x, curPt.y);			
			
			//if(!getBlobInfo(e.id).clicked)
			//	removeBlob(e.ID);			
			
			e.stopPropagation();									
		}
//---------------------------------------------------------------------------------------------------------------------------------------------
// PUBLIC OVERRIDES 
// TODO: Use "interface" [RotateScale extends Touchable implements ITouch]
// TODO: MAKE ALL IDENTICAL (other than first two)
//---------------------------------------------------------------------------------------------------------------------------------------------
		public function handleBlobCreated(id:int, mx:Number, my:Number):void
		{
		}
		
		public function handleBlobRemoved(id:int):void
		{
		}
		//-------- REST MAKE IDENTICAL ---------------------------------------------------------------------------------------------------
		public function handleDownEvent(id:int, mx:Number, my:Number, targetObj:Object):void
		{
		}
		
		public function handleUpEvent(id:int):void
		{
		}
		
		public function handleRollOverEvent(id:int, mx:Number, my:Number):void
		{
		}
		
		public function handleRollOutEvent(id:int, mx:Number, my:Number):void
		{
		}				

		public function handleMoveEvent(id:int, mx:Number, my:Number, targetObj:Object):void
		{
		}
//---------------------------------------------------------------------------------------------------------------------------------------------
	}
}