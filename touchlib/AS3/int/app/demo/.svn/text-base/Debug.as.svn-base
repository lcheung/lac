package app.demo{
	
import flash.events.*;

import app.core.canvas.*;
import app.core.loader.*;
import app.core.utl.*;
import flash.display.*;

import flash.events.Event;

public class Debug extends Sprite
{		
	public function Debug()
		{					
		Settings.instance.loadSettings('www/xml/config.xml');
		Settings.instance.addEventListener(Settings.INIT, initApp);	
		}
		
	public function initApp(event:Event):void
		{				
		if (Settings.instance.debug == true){	
		var DEBUG_FPS:FPS = new FPS();
		var debugMode:Boolean = Settings.instance.debug;
		this.addChild(DEBUG_FPS);
		}
		this.stage.frameRate = Settings.instance.framerate;
        trace('~view: '+Settings.instance.version);
        trace('-------------------------------------------------------------------------------------------------------------------------------');
        trace(' Theme : '+Settings.instance.theme); 
        trace(' Debug : '+Settings.instance.debug); 
        trace(' FPS : '+Settings.instance.framerate);		
        TUIO.init( this, Settings.instance.host, Settings.instance.TCP, '', true);	        
        trace(' TUIO Socket Enabled : Host: '+Settings.instance.host+' TCP: '+Settings.instance.TCP+' UDP: '+Settings.instance.UDP);	
	    trace('-------------------------------------------------------------------------------------------------------------------------------');		
		trace(' Modules Available : '+Settings.instance.modules_avail);
		trace('-------------------------------------------------------------------------------------------------------------------------------');
		trace(' Modules Loaded : '+Settings.instance.modules);	
  		trace('-------------------------------------------------------------------------------------------------------------------------------');
  		setupApplication();
  		runApplication();
  		}
  		
	public function setupApplication()
		{			
		var fpsManager = new FPS();
		this.addChild(fpsManager);
		
		if (Settings.instance.background != "none"){
		var bg = new Background(Settings.instance.background);
		this.addChildAt(bg, 0);	

		bg.addEventListener(Background.BACKGROUND_LOADING, loading);
		bg.addEventListener(Background.BACKGROUND_LOADED, loaded);
			
	
			
		function loaded(e:Event) {
		bg.removeEventListener(Background.BACKGROUND_LOADING, loading);
		bg.removeEventListener(Background.BACKGROUND_LOADED, loaded);
		}

		function loading(e:Event) {
		var bL:Number = bg.bytesLoaded;
		var bT:Number = bg.bytesTotal;	
		var bT:Number = bg.bytesTotal;		
		 trace('Loading URL: ' + Settings.instance.background +' - '+ bT / 1000 + 'KB / ' +uint(100 * bL / bT)+'%');
		}	
  		}	
  		}
	public function runApplication()
		{	
		trace('Test');
		}
  }	
}























/*
import flash.events.TUIO;
import app.core.canvas.*;
import app.core.loader.*;
import app.core.utl.*;

import flash.events.Event;
import flash.system.Capabilities;

TUIO.init( this, 'localhost', 3000, '', false );

//var subobj = new MediaCanvas();
var subobj = new TestCanvas();
//this.addChild(subobj);
//var flickrLoader = new Flickr(subobj);
//var localLoader = new Local(subobj);
var sysManager = new MemoryMonitor();
var fpsManager = new FPS();
this.addChild(sysManager);
this.addChild(fpsManager);

stage.addEventListener(Event.RESIZE,onResize);  
stage.align = "TL"; 
stage.scaleMode = "noScale";  
function onResize(e:Event = null):void {
var stageW:int = stage.stageWidth;
var stageH:int = stage.stageHeight;
	this.center_mc.x = stageW/2;
	this.center_mc.y = stageH/2;	
	this.sysManager.x = stageW-350;
	this.sysManager.y = stageH-220;	
	this.fpsManager.x = stageW-340;
	this.fpsManager.y = stageH-238;	
	}
onResize();

*/