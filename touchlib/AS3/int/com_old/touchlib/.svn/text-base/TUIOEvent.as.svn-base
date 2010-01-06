//Rename to look like this:
//closeButton.addEventListener(TouchEvent.MOUSE_OVER, confirmAdd);

package com.touchlib {
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;	
	
	public class TUIOEvent extends Event
	{
		public var TUIOClass:String;
		public var sID:int;
		public var ID:int;
		public var angle:Number;
		public var stageX:Number;
		public var stageY:Number;
		public var localX:Number;
		public var localY:Number;
		public var oldX:Number;
		public var oldY:Number;
		public var buttonDown:Boolean;
		public var relatedObject:DisplayObject;

		public static const TUIO_MOVE:String = "flash.events.TUIOEvent.TUIO_MOVE";
		public static const TUIO_DOWN:String = "flash.events.TUIOEvent.TUIO_DOWN";				
		//public static const CLICK:String = "com.nui.TUIOEvent.CLICK"; //
		public static const TUIO_UP:String = "flash.events.TUIOEvent.TUIO_UP";				
		public static const TUIO_OVER:String = "flash.events.TUIOEvent.TUIO_OVER";						
		public static const TUIO_OUT:String = "flash.events.TUIOEvent.TUIO_OUT";		
			
		public function TUIOEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, stageX:Number = 0, stageY:Number = 0, localX:Number = 0, localY:Number = 0, oldX:Number = 0, oldY:Number = 0, relatedObject:DisplayObject = null, ctrlKey:Boolean = false, altKey:Boolean = false, shiftKey:Boolean = false, buttonDown:Boolean = false, delta:int = 0, TUIOClass:String = "2Dcur", ID:int = -1, sID:int = -1, angle:Number = 0.0)
		{
			this.TUIOClass = TUIOClass;
			this.sID = sID;
			this.ID = ID;
			this.angle = angle;
			this.stageX = stageX;
			this.stageY = stageY;
			this.localX = localX;
			this.localY = localY;			
			this.oldX = oldX;
			this.oldY = oldY;
			this.buttonDown = buttonDown;
			this.relatedObject = relatedObject;			
			super(type, bubbles, cancelable);			
			//super(type, bubbles, cancelable, localX, localY, relatedObject, ctrlKey, altKey, shiftKey, buttonDown, delta);	
		}
	}
}