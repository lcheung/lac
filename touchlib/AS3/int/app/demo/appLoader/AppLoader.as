//////////////////////////////////////////////////////////////////////
//                                                                  //
//    Main Document Class. Sets TUIO and adds main parts to stage   //
////
//////////////////////////////////////////////////////////////////////

package app.demo.appLoader
{
	import flash.display.Sprite;
	
	import flash.events.*;
	import flash.display.*;
	import flash.net.*;
	import flash.events.*;
	import flash.text.*;
	import flash.geom.*;
	import app.demo.appLoader.*;
	import app.core.element.*;
	import flash.system.fscommand;

	// fixme: read apps, categories from XML
	
	dynamic public class AppLoader extends MovieClip 
	{
		var appLoader:Loader;
		var backLoader:Loader;
		var xmlLoader:URLLoader;
		var appButtons:Array;
		
		var screenshotLoader:Loader;
		var selectedButton:AppLoaderButton;
		var loadbtn:Wrapper;
		
		var osButton:OSButton;
		
		var bAppLoaded:Boolean = false;

		public function AppLoader()
		{

			osButton = new OSButton();
			osButton.x = stage.stageWidth;
			osButton.y = stage.stageHeight;
//			addChild(osButton);
			selectedButton = null;
			appButtons = new Array();
			
			TUIO.init( this, '127.0.0.1', 3000, 'www/xml/tableData.xml', true );
			//TUIO.addEventListener(this);
			xmlLoader = new URLLoader();
			xmlLoader.addEventListener(Event.COMPLETE, this.xmlLoaded, false, 0, true); 			
			xmlLoader.load(new URLRequest("www/xml/applist.xml"));
			
		
			backLoader = new Loader();
			mcBack.addChild(backLoader);
			backLoader.load(new URLRequest("www/img/apploaderBack.jpg"));
			
			var b:SimpleButton = new AppLoadButton();

			loadbtn = new Wrapper(b);
			loadbtn.x = 571;
			loadbtn.y = 515;
			loadbtn.visible = false;
			
			tfAppInfo.visible = false;
			
			screenshotLoader = new Loader();
			screenshotLoader.visible = false;
			screenshotLoader.x = 218;
			screenshotLoader.y = 85;
			addChild(screenshotLoader);
			
			addChild(loadbtn);
			
			loadbtn.addEventListener(MouseEvent.CLICK, loadClicked, false, 0, true);
			
			//addChild(appLoader);
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
			
			this.addEventListener(TouchEvent.LONG_PRESS, this.longPress, false, 0, true);
			
			if(this.stage)
			{
				addedToStage(new Event(Event.ADDED_TO_STAGE));
			} else {
				this.addEventListener(Event.ADDED_TO_STAGE, addedToStage, false, 0, true);
			}
		}
		
		function addedToStage(e:Event)
		{
			stage.addEventListener(Event.RESIZE, stageResized, false, 0, true);									
			stage.align = StageAlign.TOP_LEFT;
			stage.displayState = StageDisplayState.FULL_SCREEN;			
				
			stageResized(new Event(Event.RESIZE));				
		}
		
		function stageResized(e:Event)
		{
			trace("stage resized");
			
			if(osButton.stage)
			{			
				osButton.x = osButton.stage.stageWidth + 14;
				osButton.y = osButton.stage.stageHeight + 14;			
			}
		}
		
		function longPress(e:TouchEvent)
		{
			trace("Long press");

			if(bAppLoaded)
			{
				osButton.visible = true;
				osButton.x = e.stageX;
				osButton.y = e.stageY;
			}
		}
		
		function createParticles(n:int, px:Number, py:Number)
		{
			for(var i:int =0; i<n; i++)
			{
				var p:Sprite = new AppParticle();
				p.x = px;
				p.y = py;
				this.mcParticleLayer.addChild(p);
			}
		}
		
		function tuioMoveHandler(e:TouchEvent)
		{
			var tuioobj:TUIOObject = TUIO.getObjectById(e.ID);							
			
			var localPt:Point = parent.globalToLocal(new Point(tuioobj.x, tuioobj.y));														
			createParticles(1, localPt.x, localPt.y);
		}
		function tuioDownEvent(e:TouchEvent)
		{
			var tuioobj:TUIOObject = TUIO.getObjectById(e.ID);							
			
			var localPt:Point = parent.globalToLocal(new Point(tuioobj.x, tuioobj.y));														
			createParticles(1, localPt.x, localPt.y);			
		}
		function tuioUpEvent(e:TouchEvent)
		{
		}
		function tuioRollOverHandler(e:TouchEvent)
		{
		}		
		function tuioRollOutHandler(e:TouchEvent)
		{
		}				
		
		function mouseMoveHandler(e:MouseEvent)
		{
			createParticles(1, this.mouseX, this.mouseY);			
		}
		function mouseDownEvent(e:MouseEvent)
		{
			createParticles(1, this.mouseX, this.mouseY);

		}
		function mouseUpEvent(e:MouseEvent)
		{
		}		
		
		function mouseRollOverHandler(e:MouseEvent)
		{
		}
		
		function mouseRollOutHandler(e:MouseEvent)
		{
		}
		
		
		public function loadClicked(e:MouseEvent)
		{
			screenshotLoader.unload();
			screenshotLoader.visible = false;
			trace("Load " + selectedButton.appName);
			this.gotoAndPlay("RunApp");
		}
		
		public function runApp()
		{

			osButton.setAppInfo(this, selectedButton.appName,  selectedButton.appDescription, "");
			osButton.visible = false;
			loadbtn.visible = false;						
			appLoader = new Loader();
			appLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, stageResized, false, 0, true);									
			appLoader.load(new URLRequest(selectedButton.appName + ".swf"));			
			//this.setChildIndex(appLoader, this.numChildren-1);
			bAppLoaded = true;
			parent.addChild(appLoader);
			parent.addChild(osButton);
			parent.removeChild(this);
			

		}
		
		public function closeApp(main:DisplayObjectContainer)
		{
			appLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, stageResized);			
			appLoader.content.dispatchEvent(new Event(Event.UNLOAD, true));
			
			this.gotoAndStop("Init");
			main.removeChild(appLoader);
			main.removeChild(osButton);
			main.addChild(this);

			appLoader.unload();

			appLoader = null;
			bAppLoaded = false;
			buttonUnlock(selectedButton);			
	
			
		}
		
		public function showDesc()
		{
			screenshotLoader.unload();			
			screenshotLoader.load(new URLRequest("www/img/apps/" + selectedButton.appName + "_screenshot.jpg"));
			screenshotLoader.visible = true;
			tfAppInfo.visible = true;
			this.tfAppInfo.text = selectedButton.appDescription;
			this.mcAppArea.visible = false;
			this.mcCatArea.visible = false;
		}

		public function buttonDropped(b:AppLoaderButton)
		{
			if(selectedButton == null && b.hitTestObject(this.mcAppTarget))
			{
				b.lockInPlace();
				b.parent.removeChild(b);				
				b.x = 0;
				b.y = 0;
				gotoAndPlay("AppInfo");				
				this.mcAppTarget.addChild(b);
				loadbtn.visible = true;
				selectedButton = b;

			}
		}
		
		public function returnButtonToPool(b:AppLoaderButton)
		{
			screenshotLoader.unload();						
			b.unlock();
			b.x = b.parent.x - this.mcAppArea.x;
			b.y = b.parent.y - this.mcAppArea.y;
			
			b.parent.removeChild(b);							
			
			this.mcAppArea.addChild(b);			
			loadbtn.visible = false;							


			tfAppInfo.visible = false;			
		}
		
		public function buttonUnlock(b:AppLoaderButton)
		{
			returnButtonToPool(b);
			selectedButton = null;			
			this.mcAppArea.visible = true;			
			this.mcCatArea.visible = true;			
			this.gotoAndPlay("Cancel");			
			
		}
		
		public function xmlLoaded(e:Event)
		{	
			var myFont:Font = new DustismoFont();			

			try
			{
				var xml:XML = new XML(e.target.data);
				
				var by:int = 0;
				
				var tf:TextFormat = new TextFormat();
				tf.font = myFont.fontName;
				tf.color = 0xffffff;
				tf.bold = true;
				tf.size = "22";					
				tf.align = TextFormatAlign.RIGHT;;
				
				for each (var cat:XML in xml.categories.category)
				{

					var bx:int = 0;
					var catlabel:TextField = new TextField();
					
					catlabel.defaultTextFormat = tf;
					catlabel.text = cat.@name;
					catlabel.y = by + (96 / 2) - 11;
					catlabel.x = 0;
					catlabel.width = 128;
					catlabel.embedFonts = true;

					this.mcCatArea.addChild(catlabel);
					
					for each (var app:XML in cat.apps.app)
					{
						//trace("app " + app);
						var button:AppLoaderButton = new AppLoaderButton(this, app.name, app.body);
						button.setPos(bx, by);

						bx += 96 + 12;
						appButtons.push( button );
						this.mcAppArea.addChild( button );
					}
					
					by += 96 + 12;
				}

			} catch (e:TypeError)
			{
				//Could not convert the data, probably because
				//because is not formated correctly
				
				trace("Could not parse the XML")
				trace(e.message)
			}
		}
		
	}
}