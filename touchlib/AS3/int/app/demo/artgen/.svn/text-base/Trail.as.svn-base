package app.demo.artgen
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;	
	import flash.utils.*;
	import flash.net.*;
	import flash.events.Event;
	
	public class Trail extends Sprite
	{
		private var ldr:Loader;
		private var startTimeMS:int;
		private var lifeTime:int;
		private var scaleDecay:Number;
		private var alphaDecay:Number;
		
		function Trail(info:XMLList, bytes:ByteArray)
		{
			ldr = new Loader();
			addChild(ldr);
			ldr.loadBytes(bytes);
			
			lifeTime = info.lifeTime;
			
			var d:Date=  new Date();
			startTimeMS = d.time;

			scaleDecay = info.scaleDecay;
			alphaDecay = info.alphaDecay;
			
			this.addEventListener(Event.ENTER_FRAME, frameUpdate, false, 0, true);
			this.addEventListener(Event.ADDED, addedHandler, false, 0, true);
		}
		
		function addedHandler(e:Event)
		{
			parent.addEventListener("freeze", freezeHandler, false, 0, true);
			parent.addEventListener("clear", clearHandler, false, 0, true);						
		}
		
		function kill()
		{
			ldr.unload();
			removeEventListener(Event.ENTER_FRAME, frameUpdate);
			removeEventListener(Event.ADDED, addedHandler);
			parent.removeEventListener("freeze", freezeHandler);
			this.parent.removeChild(this);
			removeChild(ldr);
			ldr = null;

			delete this;			
		}
		
		function clearHandler(e:Event)
		{
			kill();
		}
		
		function freezeHandler(e:Event)
		{
			removeEventListener(Event.ENTER_FRAME, frameUpdate);			
		}
		
		
		function frameUpdate(e:Event)
		{
			if(scaleDecay < 0 && scaleX < -scaleDecay)
			{
				scaleX = 0;
				scaleY = 0;
				kill();
				return;
			} else {
				this.scaleX += scaleDecay;
				this.scaleY += scaleDecay;
			}
				
			if(scaleDecay < 0 && alpha < -alphaDecay)
			{
				alpha = 0;
				kill();
				return;				
			} else
				alpha += alphaDecay;

			var d:Date = new Date();
			var curTime:int = d.time;			
			
			// fixme: add frame by frame modulations..

			if(curTime - startTimeMS > lifeTime)
			{
//				this.visible = false;
				kill();
			}
			
		}
	}
}