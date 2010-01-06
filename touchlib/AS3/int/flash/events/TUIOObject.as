﻿package flash.events 
{
	import flash.display.DisplayObject;	
	import flash.geom.Point;

	public class TUIOObject 
	{		
		
		//FIXME: NAMES SHOULD NOT BE ALL CAPS UNLESS STATIC OR CONST
		private var NEW:Boolean;	
		private var EVENT_ARRAY:Array;			
		
		internal var TUIO_ALIVE:Boolean;		
		internal var TUIO_TYPE:String;		
		internal var TUIO_CURSOR:TUIOCursor;		
		internal var TUIO_OBJECT:DisplayObject;
		
		//------FIX ME: NO PUBLIC
		public var x:Number;
		public var y:Number;
		//-----------------------
		internal var oldX:Number;
		internal var oldY:Number;		
		internal var dX:Number;
		internal var dY:Number;					
		internal var ID:int;
		internal var sID:int;
		internal var area:Number = 0;	
		internal var width:Number = 0;
		internal var height:Number = 0;		
		internal var angle:Number;		
		internal var pressure:Number;		
		internal var startTime:Number;
		internal var lastModifiedTime:Number;		
		
		internal var downX:Number;
		internal var downY:Number;	

//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// CONSTRUCTOR
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		public function TUIOObject ($type:String, $id:int, $px:Number, $py:Number, $dx:Number, $dy:Number, $sid:int = -1, $angle:Number = 0, $height:Number=0.0, $width:Number=0.0, $TUIO_OBJECT:DisplayObject = null)
		{
			trace("yooooooooooooooooooooo");
			
			EVENT_ARRAY = new Array();
			TUIO_TYPE = $type;
			ID = $id;
			x = $px;
			y = $py;
			oldX = $px;
			oldY = $py;
			dX = $dx;
			dY = $dy;
			sID = $sid;
			angle = $angle;			
			width = $width;
			height = $height;
			area = $width * $height;
			
			TUIO_ALIVE = true;					
			TUIO_CURSOR = new TUIOCursor(ID,0xFFFFFF, int(area), int($width), int($height));		
			TUIO_CURSOR.x = x;
			TUIO_CURSOR.y = y;  		
			
			try {
 	 			TUIO_OBJECT = $TUIO_OBJECT;
			} catch (e:Error)
			{
				TUIO_OBJECT = null;
			}
			
			NEW = true;
			
			var d:Date = new Date();
			startTime = d.time;
			lastModifiedTime = startTime;
			//trace(startTime);
		}
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// PUBLIC METHODS
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		// FIXME: we could use this function to replace a bunch of the stuff above.. 
		public function getTouchEvent(event:String):TouchEvent
		{
			var localPoint:Point;
			
			if(TUIO_OBJECT && TUIO_OBJECT.parent)
			{
				localPoint = TUIO_OBJECT.parent.globalToLocal(new Point(x, y));							
			} else {
				localPoint = new Point(x, y);
			}
			return new TouchEvent(event, true, false, x, y, localPoint.x, localPoint.y, dX, dY, oldX, oldY, TUIO_OBJECT, false,false,false, true, 0, TUIO_TYPE, ID, sID, angle);
		}
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// INTERNAL METHODS
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		internal function notifyCreated():void
		{
			if(TUIO_OBJECT)
			{
				try
				{
					var localPoint:Point = TUIO_OBJECT.parent.globalToLocal(new Point(x, y));				
					TUIO_OBJECT.dispatchEvent(new TouchEvent(TouchEvent.MOUSE_DOWN, true, false, x, y, localPoint.x, localPoint.y, dX, dY, oldX, oldY, TUIO_OBJECT, false,false,false, true, 0, TUIO_TYPE, ID, sID, angle));									
					TUIO_OBJECT.dispatchEvent(new TouchEvent(TouchEvent.MOUSE_OVER, true, false, x, y, localPoint.x, localPoint.y, dX, dY, oldX, oldY, TUIO_OBJECT, false,false,false, true, 0, TUIO_TYPE, ID, sID, angle));																		
				
					downX = x;
					downY = y;
				
				} catch (e:Error)
				{
					trace("Failed : " + e);
					TUIO_OBJECT = null;
				}
			}			
		}
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------		
		internal function notifyMoved():void
		{
			//var d:Date = new Date();
			//lastModifiedTime = d.time;
			
			var localPoint:Point;
			for(var i:int=0; i<EVENT_ARRAY.length; i++)
			{
				localPoint = EVENT_ARRAY[i].parent.globalToLocal(new Point(x, y));			
				//trace("Notify moved"+ localPoint);
				EVENT_ARRAY[i].dispatchEvent(new TouchEvent(TouchEvent.MOUSE_MOVE, true, false, x, y, localPoint.x, localPoint.y, dX, dY, oldX, oldY, EVENT_ARRAY[i], false,false,false, true, 0, TUIO_TYPE, ID, sID, angle));	
			}			
		}
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		internal function notifyRemoved():void
		{
			TUIO_ALIVE = false;
			var localPoint:Point;			
			if(TUIO_OBJECT && TUIO_OBJECT.parent)
			{				
				localPoint = TUIO_OBJECT.parent.globalToLocal(new Point(x, y));				
				TUIO_OBJECT.dispatchEvent(new TouchEvent(TouchEvent.MOUSE_OUT, true, false, x, y, localPoint.x, localPoint.y, dX, dY, oldX, oldY, TUIO_OBJECT, false,false,false, true, 0, TUIO_TYPE, ID, sID, angle));				
				TUIO_OBJECT.dispatchEvent(new TouchEvent(TouchEvent.MOUSE_UP, true, false, x, y, localPoint.x, localPoint.y, dX, dY, oldX, oldY, TUIO_OBJECT, false,false,false, true, 0, TUIO_TYPE, ID, sID, angle));									
			
				var dist, dx, dy:Number;
			    dx = x - downX;
			    dy = y - downY;
			    dist = Math.sqrt(dx*dx + dy*dy);	
				
				trace(dist);
						
			    if(dist < 20){
				 
					TUIO_OBJECT.dispatchEvent(new TouchEvent(TouchEvent.CLICK, true, false, x, y, localPoint.x, localPoint.y, dX, dY, oldX, oldY, TUIO_OBJECT, false,false,false, true, 0, TUIO_TYPE, ID, sID, angle));									
			    }			
			}			
			for(var i:int=0; i<EVENT_ARRAY.length; i++)
			{
				if(EVENT_ARRAY[i] != TUIO_OBJECT)
				{
					localPoint = EVENT_ARRAY[i].parent.globalToLocal(new Point(x, y));				
					EVENT_ARRAY[i].dispatchEvent(new TouchEvent(TouchEvent.MOUSE_UP, true, false, x, y, localPoint.x, localPoint.y, dX, dY, oldX, oldY, EVENT_ARRAY[i], false,false,false, true, 0, TUIO_TYPE, ID, sID, angle));								
				}
			}
			
			EVENT_ARRAY = new Array();			
			TUIO_OBJECT = null;		
		}
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		internal function setObjOver(o:DisplayObject):void
		{	
			var localPoint:Point;	
			try {
				
				if(TUIO_OBJECT == null)
				{
					TUIO_OBJECT = o;				
					if(TUIO_OBJECT) 
					{
						localPoint = TUIO_OBJECT.parent.globalToLocal(new Point(x, y));				
						TUIO_OBJECT.dispatchEvent(new TouchEvent(TouchEvent.MOUSE_OVER, true, false, x, y, localPoint.x, localPoint.y, dX, dY, oldX, oldY, TUIO_OBJECT, false,false,false, true, 0, TUIO_TYPE, ID, sID, angle));					
					}
				} else if(TUIO_OBJECT != o) 
				{

					localPoint = TUIO_OBJECT.parent.globalToLocal(new Point(x, y));
					TUIO_OBJECT.dispatchEvent(new TouchEvent(TouchEvent.MOUSE_OUT, true, false, x, y, localPoint.x, localPoint.y, dX, dY, oldX, oldY, TUIO_OBJECT, false,false,false, true, 0, TUIO_TYPE, ID, sID, angle));
					if(o)
					{
						localPoint = TUIO_OBJECT.parent.globalToLocal(new Point(x, y));
						o.dispatchEvent(new TouchEvent(TouchEvent.MOUSE_OVER, true, false, x, y, localPoint.x, localPoint.y, dX, dY, oldX, oldY, TUIO_OBJECT, false,false,false, true, 0, TUIO_TYPE, ID, sID, angle));
					}
					TUIO_OBJECT = o;
				}
			} catch (e:Error)
			{
			//trace("ERROR " + e);
			}
		}
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		internal function addListener(reciever:Object):void
		{
			for(var i:int = 0; i<EVENT_ARRAY.length; i++)
			{
				if(EVENT_ARRAY[i] == reciever)			
					return;
			}
			EVENT_ARRAY.push(reciever);
		}
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		internal function removeListener(reciever:Object):void
		{
			for(var i:int = 0; i<EVENT_ARRAY.length; i++)
			{
				if(EVENT_ARRAY[i] == reciever)
					EVENT_ARRAY.splice(i, 1);
			}
		}
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	} 
}