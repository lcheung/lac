// IDEA: allow layer blending effects to be set
// IDEA: Add a slider to adjust framerate
// IDEA: ability to modulate colors?

// TODO: 
// Tweak sliders in SettingsDialog - ScaleDecay, AlphaDecay too fidly (need finer control).
// Color Picker - multifinger blending?
// Get NUI xmlmenu working.. 
// Layer editor - delete layer, hide/unhide layer, layer blend mode.. layer FX - blend / dropshadow.. 
// write more AI algo's..


// RESOURCE: http://tutorialblog.org/free-vector-downloads/  
// RESOURCE: http://www.bittbox.com/freebies/35-free-abstract-illustrator-brushes/
// RESOURCE: http://www.vecteezy.com/

package app.demo.artgen
{
	import flash.display.*;
	import flash.events.*;
	import app.demo.artgen.*;
	import app.core.element.*;
	import app.core.action.Multitouchable;	
	import flash.events.*;
	import flash.ui.Keyboard;
	import flash.geom.*;
	
	import app.core.element.XMLMenu;
	import app.core.element.Wrapper;
	import app.core.utl.FPS;
	
	public class ArtGenMain extends Multitouchable 
	{		
		private var aSwarms:Array;

		private var curLayer:Sprite;
		private var layers:Array;
		
		private var settings:XML;
		
		private var dialog:SettingsDialog;
		private var myVMenu:XMLMenu;
		
		public function ArtGenMain() 
		{
			aSwarms = new Array();
			trace("ArtGenCanvas Initialized");

			layers = new Array();
			
			var spr:Sprite = new Sprite();
			curLayer = spr;
			
//			var t:ColorTransform = new ColorTransform(1.0, 0.2, 0.2);
//			curLayer.transform.colorTransform = t;			
			
			layers.push(spr);
			layerHolder.addChild(spr);
						
			settings = <swarm>
							<swarmType>Boid2</swarmType>
							<numMembers>2</numMembers>
							<shape>Shape1.swf</shape>
							<scale>0.5</scale>
							<alpha>0.5</alpha>			
							<color>255</color>
							<algorithm>
								<speed>10</speed>
								<turnRate>4</turnRate>
							</algorithm>
							<trail>
								<lifeTime>5000</lifeTime>
								<createDelay>2</createDelay>
								<scaleDecay>-0.01</scaleDecay>
								<alphaDecay>-0.01</alphaDecay>
								<rotationDecay>0.1</rotationDecay>									
							</trail>
							<modulators>

								
								
								<modulator>
									<type>random</type>
									<rate>16.0</rate>
									<dest>position</dest>
									<amount>0.1</amount>
								</modulator>
								
								<modulator>
									<type>random</type>
									<rate>32.0</rate>
									<dest>alpha</dest>
									<amount>0.4</amount>
								</modulator>									
								
							</modulators>
					</swarm>;
			

			
			addEventListener(Event.ENTER_FRAME, frameUpdate, false, 0, true);
			addEventListener(Event.UNLOAD, unloadHandler, false, 0, true);
			
			var wrap0:Wrapper = new Wrapper(btSaveLayer);
			var wrap1:Wrapper = new Wrapper(btClearLayer);
			var wrap2:Wrapper = new Wrapper(btSwarmSettings);			
			wrap0.addEventListener(MouseEvent.CLICK, saveLayerHandler, false, 0, true);
			wrap1.addEventListener(MouseEvent.CLICK, clearLayerHandler, false, 0, true);
			wrap2.addEventListener(MouseEvent.CLICK, editSettingsHandler, false, 0, true);				
			addChild(wrap0);
			addChild(wrap1);
			addChild(wrap2);
						
			// hide it for now, until I make it work.
			btEditLayers.visible = false;
			
			addEventListener(Event.ADDED_TO_STAGE, addedHandler, false, 0, true);

			TUIO.init( this, 'localhost', 3000, '', true );			
			

			dialog = new SettingsDialog(settings, this);
			dialog.visible = false;

			addChild(dialog);
			
			//var menu new XMLMenu(layout, XML file, padding, width, height, x, y, labels?, effects?);
			/*
			myVMenu = new XMLMenu('vertical', 'www/menus/artgen/vert_menu.xml',0 ,125,50,10,7, true, false);
			
			var menuHolder = new Sprite();
			menuHolder.graphics.beginFill(0xFFFFFF,0.35);
			menuHolder.graphics.drawRoundRect(0,0,145, 215,10);
			menuHolder.graphics.endFill();
			addChildAt(menuHolder, this.numChildren-1);
			menuHolder.x = menuHolder.y = 16;
			menuHolder.addChild(myVMenu);		
			
			
			var fps = new FPS();
			fps.x = menuHolder.width+25;			
			fps.y = 25;
			this.addChild(fps);	 
			*/
		}
		
		function applySettings()
		{
			settings = dialog.getXML();
			
			var color:int = settings.color;
			var r:Number = Number(color >> 16) / 255.0;
			var g:Number = Number((color & 0xff00) >> 8) / 255.0;
			var b:Number = Number(color & 0xff) / 255.0;			
			
			var t:ColorTransform = new ColorTransform(r, g, b);
			curLayer.transform.colorTransform = t;					
			
			
			/*
			for(var i:int = 0; i<aSwarms.length; i++)
			{
				aSwarm[i].setupInfo(dialog.getXML());
			}
			*/
		}
		
		function addedHandler(e:Event)
		{
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyboardHandler);			
		}
		
		function editSettingsHandler(e:Event)
		{
			// fixme: stop all swarms?
			
			for(var i:int = 0; i<aSwarms.length; i++)
			{
				layerHolder.removeChild(aSwarm[i]);
			}			
			aSwarms = new Array();
			dialog.visible = true;
		}
		
		function saveLayerHandler(e:Event)
		{
			saveLayer();
		}
		
		function clearLayerHandler(e:Event)
		{
			clearLayer();
		}		
		
		public function saveLayer()
		{
			for(var i:int = 0; i<aSwarms.length; i++)
			{
				layerHolder.removeChild(aSwarm[i]);
			}			
			aSwarms = new Array();			
			
			trace("save layer");
			curLayer.dispatchEvent(new Event("freeze"));
			curLayer.cacheAsBitmap = true;
			
			var spr:Sprite = new Sprite();
			curLayer = spr;
			
			
			var color:int = settings.color;
			var r:Number = Number(color >> 16) / 255.0;
			var g:Number = Number((color & 0xff00) >> 8) / 255.0;
			var b:Number = Number(color & 0xff) / 255.0;			
			
			var t:ColorTransform = new ColorTransform(r, g, b);
			curLayer.transform.colorTransform = t;
			
			
			layers.push(spr);			
			layerHolder.addChild(spr);
							
	
			
		}
		
		
		public function clearLayer()
		{
			trace("save layer");
			curLayer.dispatchEvent(new Event("clear"));

			
		}		
		function keyboardHandler(k:KeyboardEvent)
		{
			trace("Keyboard handler");
			if(k.keyCode == Keyboard.ENTER)
			{
				saveLayer();
			}
		}
		
		public function frameUpdate(e:Event)
		{
			for(var i:int = 0; i<aSwarms.length; i++)
			{			
				aSwarms[i].track();
				aSwarms[i].draw();
			}

		}
		
		public override function handleBlobCreated(id:int, mx:Number, my:Number):void
		{
			var swarm:Swarm;
			swarm = new Swarm(id, mx, my);
			layerHolder.addChild(swarm);
			
			swarm.setDrawingCanvas(curLayer);			
			
			swarm.setupInfo(settings);			
			
			aSwarms.push(swarm);
		}
		
		public override function handleBlobRemoved(id:int):void
		{
			for(var i:int = 0; i<aSwarms.length; i++)
			{
				if(aSwarms[i].id == id)
				{
					layerHolder.removeChild(aSwarms[i]);
					aSwarms.splice(i, 1);
					return;
				}
			}
			
		}		

		public override function handleMoveEvent(id:int, mx:Number, my:Number, targetObj:Object):void
		{
			for(var i:int = 0; i<aSwarms.length; i++)
			{
				if(aSwarms[i].id == id)
				{
					aSwarms[i].setTrack(new Point(mx, my));
					return;
				}
			}
			
		}		
		
		public function unloadHandler(e:Event)
		{
			removeEventListener(Event.ENTER_FRAME, frameUpdate);			
			
			btSaveLayer.removeEventListener(MouseEvent.CLICK, saveLayerHandler);
			btClearLayer.removeEventListener(MouseEvent.CLICK, clearLayerHandler);			
			removeEventListener(Event.ADDED_TO_STAGE, addedHandler);			
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyboardHandler);			
		}
	}
}