package app.core.action.gestures {	
public class GestureCanvas extends Sprite {				
public function GestureCanvas(s:DisplayObjectContainer, xml_url:String) {
trace("Construct ~ GestureCanvas.as");			
			thestage = s.stage;			
			var loader:URLLoader = new URLLoader();	
			var request:URLRequest = new URLRequest(xml_url);
			loader.addEventListener(Event.COMPLETE, dataLoaded);		
            try {loader.load(request);} 
            catch (error:Error) {trace("Unabled to locate your gesture definition file (dictionary.xml)");
            }
		}
// -------------------------------------------------------------------------------------------
	   	function exit(e:Event) {		
	   		//thestage.removeEventListener(MouseEvent.MOUSE_MOVE,this.paintLine); 
	   		thestage.removeEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownEvent);															
			thestage.removeEventListener(MouseEvent.MOUSE_UP, this.mouseUpEvent);
			thestage.removeEventListener(TouchEvent.MOUSE_DOWN, this.downEvent);	
			thestage.removeEventListener(TouchEvent.MOUSE_UP, this.mouseUpEvent);	
			parent.removeChild(parent.getChildByName("GestureCanvas"));	

		}
		
	   function dataLoaded(event:Event):void {
			var loader:URLLoader = URLLoader(event.target);
            dictXML = new XML(loader.data);
			init();		
		}	
					
		function init():void {		
		
		thestage.addEventListener(Event.RESIZE, onResize); 						
		paintingSurface = new Sprite();						
		paintingSurface.graphics.beginFill(0xFFFFFF,0.0);	
		paintingSurface.graphics.drawRect(0,0,thestage.stageWidth,thestage.stageHeight);
		paintingSurface.graphics.endFill();		
		this.addChild(paintingSurface);	
		
		
		normalizedMC = new Sprite();						
		normalizedMC.graphics.drawRect(500,500,100,100);	
		this.addChild(normalizedMC);	
		
		
		//var imageButton:Loader = new Loader();		
		//imageButton.load(new URLRequest("closeButton.png"));	
		//WrapperObject = new Wrapper(imageButton);		
		//WrapperObject.addEventListener(MouseEvent.CLICK, this.exit);		
		//WrapperObject.y = stage.stageHeight-150;	
		//this.addChild(WrapperObject);	
		//this.setChildIndex(WrapperObject, this.numChildren-1);
					
		//	parent.removeChild(parent.getChildByName("GestureButton"));
		
		format = new TextFormat();	
       	format.font = "DIN";
     	format.color = 0xFFFFFF;    
        format.size = 42;
        
        scoreField = new TextField();
		scoreField.defaultTextFormat = format;
		scoreField.autoSize = TextFieldAutoSize.LEFT;
		scoreField.x = stage.stageWidth-100;
		scoreField.y = stage.stageHeight+200;
		scoreField.selectable=false;
		scoreField.background=true;
		scoreField.backgroundColor=0x000000;
		//scoreField.scaleX = scoreField.scaleY = 0;
		scoreField.alpha = 0;
		this.addChild( scoreField );	
	   
	    matchField = new TextField();	
		matchField.defaultTextFormat = format; 	
		matchField.selectable=false;
		//matchField.alpha = 0;	
		matchField.background=true;
		matchField.backgroundColor=0x000000;
		//scoreField.scaleX = scoreField.scaleY = 0;
		matchField.autoSize = TextFieldAutoSize.LEFT;
		matchField.x = stage.stageWidth-135;
		matchField.y = stage.stageHeight+200;
		this.addChild( matchField );			
				
			capturer = new GestureCapturer();
			addChild(capturer);
			
			//printer = new GestureXMLPrinter();
			dict = new GestureDictionary();
			//trace("DICT:"+dictXML);
			GestureDictionaryBuilder.populate(dict,dictXML);			
		   	thestage.addEventListener(KeyboardEvent.KEY_DOWN, keyPressedDown);			
			//stage.addEventListener(TouchEvent.MOUSE_MOVE, this.moveHandler, false, 0, true);			
			thestage.addEventListener(TouchEvent.MOUSE_DOWN, this.downEvent);						
			thestage.addEventListener(TouchEvent.MOUSE_UP, this.mouseUpEvent);									
			//stage.addEventListener(TouchEvent.MOUSE_OVER, this.rollOverHandler, false, 0, true);									
			//stage.addEventListener(TouchEvent.MOUSE_OUT, this.rollOutHandler, false, 0, true);		
		
			//this.addEventListener(MouseEvent.MOUSE_MOVE, this.mouseMoveHandler);									
			thestage.addEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownEvent);															
			thestage.addEventListener(MouseEvent.MOUSE_UP, this.mouseUpEvent);	
			//this.addEventListener(MouseEvent.MOUSE_OVER, this.mouseRollOverHandler);
			//this.addEventListener(MouseEvent.MOUSE_OUT, this.mouseUpEvent);			
		}
		
		function mouseDownEvent(event:MouseEvent):void {			
			//Prep the paintingSurface
			paintingSurface.graphics.clear();		
			paintingSurface.graphics.beginFill(0x000000,0.0);	
			paintingSurface.graphics.drawRect(0,0,thestage.stageWidth,thestage.stageHeight);
			paintingSurface.graphics.beginFill(0xFF0000,0.0);	
			paintingSurface.graphics.moveTo(mouseX,mouseY);	
			paintingSurface.graphics.lineStyle(5,0xCCCCCC,0.85);	
			//Draw the all of the mouse movements to the screen
			//this.mouseMove = this.paintLine;
			thestage.addEventListener(MouseEvent.MOUSE_MOVE,this.paintLine); 
			//Start capturing the gesture
			capturer.startGesture();			
		}
		
		function downEvent(e:TouchEvent):void {			
			//Prep the paintingSurface
			paintingSurface.graphics.clear();		
			paintingSurface.graphics.beginFill(0x000000,0.0);	
			paintingSurface.graphics.drawRect(0,0,thestage.stageWidth,thestage.stageHeight);
			paintingSurface.graphics.beginFill(0xFF00FF,0.0);	
			paintingSurface.graphics.moveTo(e.stageX,e.stageY);	
			paintingSurface.graphics.lineStyle(5,0xFF00FF,1.0);	
			//Draw the all of the mouse movements to the screen
			//this.mouseMove = this.paintLine;
			thestage.addEventListener(TouchEvent.MOUSE_MOVE,this.paintTouchLine); 
			//Start capturing the gesture
			capturer.startGesture();			
		}				

		function paintLine(event:MouseEvent):void {
			paintingSurface.graphics.lineTo(mouseX,mouseY);	
		}
		
		function paintTouchLine(e:TouchEvent):void {
			paintingSurface.graphics.lineTo(e.stageX,e.stageY);	
		}
		private function paintGesture(surface:Sprite,pnts:Array,clr:Number=0x000000):void { 
		surface.graphics.clear();
		var scale:Number = surface.width*.8;		
		surface.graphics.lineStyle(8,clr,100);
		surface.graphics.moveTo(pnts[0].x*scale,pnts[0].y*scale);
		for (var i:uint=1; i < pnts.length; i++) {
				surface.graphics.lineTo(pnts[i].x*scale,pnts[i].y*scale);
		}		
		}
		function mouseUpEvent(event:Event):void {
			//this.removeChild(paintingSurface);
			//paintingSurface.graphics.clear();			
 			
			//Stop capturing the gesture
			thestage.removeEventListener(MouseEvent.MOUSE_MOVE,this.paintLine); 
	   		//stage.removeEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownEvent);															
			//stage.removeEventListener(MouseEvent.MOUSE_UP, this.mouseUpEvent);
			//thestage.removeEventListener(TouchEvent.MOUSE_DOWN, this.downEvent);	
			//thestage.removeEventListener(TouchEvent.MOUSE_UP, this.upEvent);	
			capturer.stopGesture();
			
			//Grab the gesture and paint it to the screen
			var gesture:Array = capturer.getGesture();
			paintGesture(normalizedMC,gesture,0xffffff);
			
			//If we started a recording, add it as a dictionary entry
			if (recordGestureID != null) {
				trace("Recorded : "+recordGestureID);
				var entry:GestureDictionaryEntry = dict.getEntry(recordGestureID);
				//If there's an exiting entry, simply update the gesture
				if (entry != null) {
					entry.gesture = gesture;
				//Othewise, create an entry and add it
				} else {
					entry = new GestureDictionaryEntry(recordGestureID);
					entry.id = recordGestureID;
					entry.gesture = gesture;
					dict.addEntry(entry);
					trace(gesture);
				}
				recordGestureID = null;
			} 

			var results:Array = dict.search(gesture);
			var score:Number = Math.round(results[0].score*100);
			
			matchField.text = ' '+results[0].entry.id+' ';		
			trace(matchField.text + ' - ' + scoreField.text+'%');

			if(score>=90){format.color = 0x0BF44C;}	
			else if(score>=75){format.color = 0x50AF6A;}
			else if(score>=45){format.color = 0xCF2626;}
			else {format.color = 0xFF0000;}
			scoreField.defaultTextFormat = format;
			scoreField.text = ' '+String(score)+'% ';	
			
			Tweener.addTween(matchField, {alpha:1,  x: stage.stageWidth-185,  y: stage.stageHeight-55, time:0.55, transition:"easeinoutquad"});	
			Tweener.addTween(scoreField, {alpha:1,  x: stage.stageWidth-135,  y: stage.stageHeight-55, time:0.65, transition:"easeinoutquad"});
		
			Tweener.addTween(matchField, {alpha:0, y: stage.stageHeight+200, delay:1.4, time:0.55, transition:"easeinoutquad"});
			Tweener.addTween(scoreField, {alpha:0, y: stage.stageHeight+200, delay:1.5, time:0.55, transition:"easeinoutquad"});
		}

		
		function onResize(e:Event):void {
			paintingSurface.graphics.clear();		
			paintingSurface.graphics.beginFill(0x000000,0.0);	
			paintingSurface.graphics.drawRect(0,0,thestage.stageWidth,thestage.stageHeight);			
			WrapperObject.y = thestage.stageHeight-150;				
		}

		function keyPressedDown(event:Event):void {
  		 var key:uint = event.keyCode;
       	 recordGestureID = String.fromCharCode(key);	   
       	  trace("key down: " + event.charCode);
       	 // this.dispatchEvent(KeyboardEvent.KEY_DOWN,event);
		}			
		override public function toString():String {
			return "[GestureCanvas]";
		}
		//PUBLIC VARS -------------------------------------------------------------------------------
		public var normalizedMC:Sprite; 
		public var matchField:TextField; 
	    public var scoreField:TextField; 
		public var paintingSurface:Sprite; 
		static var thestage:Stage;
		static var objectArray:Array;	
		private var capturer:GestureCapturer;
		//private var printer:GestureXMLPrinter;
		private var dict:GestureDictionary;		
		private var dictXML:XML;		
		private var lastKey:Number; 
		private var recordGestureID:String; 	
		private var format:TextFormat;		
		private var WrapperObject:Wrapper;		
	}	
	//IMPORTS -------------------------------------------------------------------------------
	import flash.display.*;
	import flash.events.*;  
	import app.core.element.Wrapper;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;	
	import caurina.transitions.Tweener;
	import flash.events.Error;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;			
	import flash.events.KeyboardEvent;
    import flash.ui.Keyboard;    
	import app.core.utl.FPS;		
	import caurina.transitions.Tweener;
}