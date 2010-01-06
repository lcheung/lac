package app.demo.appLoader
{
	import flash.events.*;
	import app.demo.appLoader.*;
	import app.core.element.*;
	
	import flash.events.*;
	import flash.geom.*;
	import flash.display.*;	
	import fl.controls.Button;
	import flash.text.*;
	import flash.net.*;
	
	public class OSButton extends MovieClip
	{
		public var appName;
		public var appDesc;
		public var appAuthor;
		
		private var appLoader:AppLoader;
		private var bOpen:Boolean = false;
			
		public function OSButton()
		{
			appName = "not set";

			btClose.addEventListener(TouchEvent.MOUSE_DOWN, closeClicked, false, 0, true);						
			btInfo.addEventListener(TouchEvent.MOUSE_DOWN, infoClicked, false, 0, true);			
			
			btConfig.addEventListener(TouchEvent.MOUSE_DOWN, configClicked, false, 0, true);
			btApp.addEventListener(TouchEvent.MOUSE_DOWN, expanderClicked, false, 0, true);
		}
		
		function closeClicked(e:Event)
		{
			trace("Close Clicked");
			appQuit();
			toggleOpen();
		}
		
		function infoClicked(e:Event)
		{
			toggleOpen();
		}
		function configClicked(e:Event)
		{
			toggleOpen();
		}
		
		function toggleOpen()
		{
			if(bOpen)
			{
				this.visible = false;
				bOpen = false;
			} else {
				gotoAndStop("open");				
				bOpen = true;
				
				this.visible = true;
			}			
		}
		
		function expanderClicked(e:Event)
		{
			toggleOpen();
		}
		
		function setAppInfo(ldr:MovieClip, name:String, desc:String, auth:String)
		{
			appLoader = ldr;
			
			appName = name;
			appDesc = desc;
			appAuthor = auth;
		}
		
		function appQuit()
		{
			// RESTORE OS
			
			appLoader.closeApp(this.parent);
			
		}
	}
}
	