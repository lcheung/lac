package app.core.element{
//-----------------------------------------------------------------------------------------------------------
import app.core.element.Accordion;
import app.core.utl.QuickRect;
import app.core.utl.ColorUtil;
import app.core.action.Touchable;
import flash.text.*;
import flash.display.Sprite;
import flash.events.*;
import flash.net.URLLoader;
import flash.net.URLRequest;
import app.core.utl.Bling;
import flash.display.Stage;
//import flash.system.*;
//-----------------------------------------------------------------------------------------------------------
public class A extends Touchable {
//----------------------------------------------------------------------------------------------------------- 	
		[Embed(source="Arial.ttf", fontFamily="myFont")]  var myFont:Class;			
		private var n_accord:Accordion;
		private var n_loader:URLLoader;
		private var data:XML;
		private var n_stage:Stage;
		public static const SWIPE_LEFT = "SWIPE_LEFT";
		public static const SWIPE_RIGHT = "SWIPE_RIGHT";
//-----------------------------------------------------------------------------------------------------------		
		public function A()
		{
			init();	
		}
		private function init()
		{	
			n_stage = stage;
			n_stage.frameRate=30;
			n_stage.quality="BEST";
			n_stage.scaleMode="noScale";
			n_stage.align = "TL"; 
			TUIO.init( n_stage, 'localhost', 3000, '', true );			
			n_loader = new URLLoader( new URLRequest("www/xml/accord.xml"));
			n_loader.addEventListener(Event.COMPLETE, loadComplete);
		}
//----------------------------------------------------------------------------------------------------------- 	
		private function loadComplete(e:Event)
		{
			data = XML(e.target.data);
			n_accord = new Accordion(n_stage.stageWidth, n_stage.stageHeight, data.node.length(), 25);		
				
				var n_format:TextFormat = new TextFormat();
				n_format.font= "myFont";
				n_format.color = 0x000000;	
				n_format.bold = true;
			
			for(var i:int=0; i < data.node.length(); i++)
			{
				var n_color = ColorUtil.random(255,255,255);
				var m_color = ColorUtil.random(0,0,0);
				var n_button = new Sprite;			
				var n_content = new Sprite;				
				var n_bling = new Bling(n_stage.stageWidth,n_stage.stageHeight,n_color,m_color);
				///
				var n_text = new TextField();						
				n_text.autoSize = TextFieldAutoSize.LEFT;
				n_text.selectable = false;			
				n_format.size = 1000;	
				n_text.defaultTextFormat = n_format;
				n_text.embedFonts = true;
				n_text.text = data.node[i].content;
				n_text.x = 50;
				n_text.y = 50;
				n_text.blendMode='invert';
				n_content.addChild(n_bling);
				n_content.addChild(n_text);	
				///	
				var n_label = new TextField();						
				n_label.autoSize = TextFieldAutoSize.LEFT;
				n_label.selectable = false;			
				n_format.size = 16;	
				n_label.defaultTextFormat = n_format;
				n_label.embedFonts = true;
				n_label.text = data.node[i].title;
				n_label.x = 0;
				n_label.y = n_stage.stageHeight-15;
				n_label.rotation = -90;
				n_button.addChild(n_label);		
				///
				n_accord.addNode(n_button, n_content);
			}
			n_accord.addEventListener(SWIPE_LEFT,swipeLeft);	
			n_accord.addEventListener(SWIPE_RIGHT,swipeRight);
			this.addChild(n_accord);
			n_accord.toggleNode(1);
		}	
//----------------------------------------------------------------------------------------------------------- 	
		private function swipeLeft(e:Event)
		{
			 if(n_accord.n_state<data.node.length()) 
			 n_accord.toggleNode(n_accord.n_state+1); 
		}
		private function swipeRight(e:Event)
		{
				if (n_accord.n_state>1) 
				n_accord.toggleNode(n_accord.n_state-1);
		}
//----------------------------------------------------------------------------------------------------------- OVERRIDE FROM TOUCHABLE
		public override function handleDownEvent(id:int, mx:Number, my:Number, targetObj)
		{	
		}
		public override function handleMoveEvent(id:int, mx:Number, my:Number, targetObj)
		{		
		}
		public override function handleUpEvent(id:int, mx:Number, my:Number, targetObj)
		{	
			if(blobs.length == 1)
			{			
			
				//SWIP RIGHT OR LEFT (with thresholds)
				if((blobs[0].history.length) >= 10 && (blobs[0].history.length) <= 50 ){	
				if((my-blobs[0].history[0].y) <= 25 && (my-blobs[0].history[0].y) >= -25){
					if((mx-blobs[0].history[0].x) >= 75 || (mx-blobs[0].history[0].x) <= -75){
							if(mx > blobs[0].history[0].x){
							 	n_accord.dispatchEvent(new Event(SWIPE_RIGHT))
								}
							else{
								 n_accord.dispatchEvent(new Event(SWIPE_LEFT));
						}
					}
				}//else()		
				}
			}
		
		}
		
		public override function handleRollOverEvent(id:int, mx:Number, my:Number, targetObj)
		{
		}
		public override function handleRollOutEvent(id:int, mx:Number, my:Number, targetObj)
		{			
		}			
//-----------------------------------------------------------------------------------------------------------	
	}
}