// FIXME: animate tank tread spinning..

package app.demo.appLoader
{
	import flash.events.*;
	import app.demo.appLoader.*;
	
	import flash.events.*;
	import flash.geom.*;
	import flash.display.*;	
	import fl.controls.Button;
	import flash.text.*;
	import flash.net.*;
	
	dynamic public class AppLoaderButton extends Sprite
	{
		var buttonOverlay:MovieClip;
		var buttonImage:Loader;
		var apploader:AppLoader;
		var buttonDown:Boolean;
		var buttonLocked:Boolean;


		var setPosX:Number = 0;
		var setPosY:Number = 0;
		
		public var appName:String;	
		public var appDescription:String;
		
		function AppLoaderButton(app:AppLoader, appname:String, desc:String)
		{			
			apploader = app;
			appName = appname;
			appDescription = desc;
			trace(appName + ":" + appDescription);
			
			buttonOverlay = new ButtonOverlay();
			buttonImage = new Loader();
			buttonImage.x = 12;
			buttonImage.y = 12;
			buttonDown = false;
			buttonLocked = false;
			
			this.buttonMode = true;
			this.useHandCursor = true;			
			
			trace("Loading img " + "www/img/apps/" + appname + ".png");
			buttonImage.load(new URLRequest("www/img/apps/" + appname + ".png"));
			
			addChild(buttonImage);
			addChild(buttonOverlay);
			
			this.addEventListener(TouchEvent.MOUSE_MOVE, this.tuioMoveHandler, false, 0, true);			
			this.addEventListener(TouchEvent.MOUSE_DOWN, this.tuioDownEvent, false, 0, true);						
			this.addEventListener(TouchEvent.MOUSE_UP, this.tuioUpEvent, false, 0, true);									
			this.addEventListener(TouchEvent.MOUSE_OVER, this.tuioRollOverHandler, false, 0, true);									
			this.addEventListener(TouchEvent.MOUSE_OUT, this.tuioRollOutHandler, false, 0, true);			
			
			this.addEventListener(MouseEvent.MOUSE_MOVE, this.mouseMoveHandler, false, 0, true);									
			this.addEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownEvent, false, 0, true);															
			this.addEventListener(MouseEvent.MOUSE_UP, this.mouseUpEvent, false, 0, true);	
			this.addEventListener(MouseEvent.ROLL_OVER, this.mouseRollOverHandler, false, 0, true);
			this.addEventListener(MouseEvent.ROLL_OVER, this.mouseRollOutHandler, false, 0, true);
			
			this.addEventListener(Event.ENTER_FRAME, this.frameUpdate, false, 0, true);
			
		}
		
		public function setPos(px:Number, py:Number)
		{
			x = px;
			y = py;
			
			setPosX = x;
			setPosY = y;
		}
		
		public function lockInPlace()
		{
			buttonLocked = true;
		}
		
		public function unlock()
		{
			buttonLocked = false;
		}
		
		public function frameUpdate(e:Event)
		{
			if(!buttonDown && !buttonLocked)
			{
				this.x += (setPosX - x) * 0.5;
				this.y += (setPosY - y) * 0.5;
			}
			
		}
		
		public function tuioDownEvent(e:TouchEvent)
		{		
	
			if(buttonLocked)
				return;

			TUIO.addObjectListener(e.ID, this);
			buttonDown = true;
			buttonOverlay.gotoAndStop(2);
			this.parent.setChildIndex(this, this.parent.numChildren-1);
			e.stopPropagation();
		}

		public function tuioUpEvent(e:TouchEvent)
		{		
			TUIO.removeObjectListener(e.ID, this);
			trace("Upevent");

			if(buttonLocked)
			{
				apploader.buttonUnlock(this);				
				return;	
			}

		
			buttonDown = false;
			buttonOverlay.gotoAndStop(1);
			apploader.buttonDropped(this);
			
			e.stopPropagation();
		}		

		public function tuioMoveHandler(e:TouchEvent)
		{
			if(buttonDown && !buttonLocked)
			{
				var tuioobj:TUIOObject = TUIO.getObjectById(e.ID);							
				
				var localPt:Point = parent.globalToLocal(new Point(tuioobj.x, tuioobj.y));														
				activeX = localPt.x;
				activeY = localPt.y;
				
				this.x = activeX - this.width/2;
				this.y = activeY - this.height/2;
			}

			e.stopPropagation();			
		}
		
		public function tuioRollOverHandler(e:TouchEvent)
		{
			
		}
		
		public function tuioRollOutHandler(e:TouchEvent)
		{
			e.stopPropagation();			
		
		}			
		
		public function mouseDownEvent(e:MouseEvent)
		{		
		

			if(buttonLocked)
				return;		
		
			buttonDown = true;
			buttonOverlay.gotoAndStop(2);	
			
			this.parent.setChildIndex(this, this.parent.numChildren-1);
		}
		
		public function mouseUpEvent(e:MouseEvent)
		{		
		trace("Mouse up event");		
			if(buttonLocked)
			{
				//apploader.buttonUnlock(this);				
				return;	
			}
				
			buttonDown = false;
			buttonOverlay.gotoAndStop(1);
			apploader.buttonDropped(this);


		}		

		public function mouseMoveHandler(e:MouseEvent)
		{
			if(buttonDown && !buttonLocked)
			{
				this.x = parent.mouseX - this.width/2;
				this.y = parent.mouseY - this.height/2;
			}
		}
		
		public function mouseRollOverHandler(e:MouseEvent)
		{
		}
		
		public function mouseRollOutHandler(e:MouseEvent)
		{

		
		}							

		

	}
}