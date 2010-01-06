package app.core.object {
	import app.core.action.RotatableScalable;	
	import app.core.element.*;
	import caurina.transitions.Tweener;
	
	import flash.events.TouchEvent;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.net.*;
	import flash.text.*;	
		
	import app.core.element.Wrapper;
	
	public class KeyboardObject extends RotatableScalable
	{	
		[Embed(source="Arial.ttf", fontFamily="myFont")] var myFont:Class;
		
		public var keyboard: Loader;
		public var inShift:Boolean = false;
		public var TextObject_0:TextObject;

		
		public function KeyboardObject()
		{				
			noSelection = true;			
			
			keyboard = new Loader();

			keyboard.load(new URLRequest("www/keyboard.swf"));
			
			keyboard.contentLoaderInfo.addEventListener( Event.COMPLETE, arrange );	
			
			this.addChild(keyboard);	
			
			var buttonSprite = new Sprite();						
			buttonSprite.graphics.beginFill(0xFFFFFF,0.75);
			buttonSprite.graphics.lineStyle(1,0x000000,0.85);	
			buttonSprite.graphics.drawRoundRect(-345,-140,40,280,6);
			buttonSprite.graphics.drawRoundRect(303,-140,40,280,6);
			buttonSprite.addEventListener(MouseEvent.CLICK, fireFunc);	
			var WrapperObject:Wrapper = new Wrapper(buttonSprite);					
			this.addChild(WrapperObject);
				
		
		}
		function arrange(e:Event) {	
			trace('Keyboard Object Created');
			var chars: String = 'qwertyuiopasdfghjklzxcvbnm';
			var mc:MovieClip = keyboard.content;
			
			for (var i:int = 0; i< chars.length; i++) {
				mc['button'+chars.charAt(i).toString().toUpperCase()].addEventListener(TouchEvent.MOUSE_DOWN, this.DownKey);
				mc['button'+chars.charAt(i).toString().toUpperCase()].addEventListener(MouseEvent.CLICK, this.MouseDownKey);
				mc['button'+chars.charAt(i).toString().toUpperCase()].char = chars.charAt(i).toString();
			}

			mc['buttonDot'].addEventListener(TouchEvent.MOUSE_DOWN, this.DownKey);
			mc['buttonDot'].addEventListener(MouseEvent.CLICK, this.MouseDownKey);
			mc['buttonDot'].char = ".".toString();

			mc['buttonComma'].addEventListener(TouchEvent.MOUSE_DOWN, this.DownKey);
			mc['buttonComma'].addEventListener(MouseEvent.CLICK, this.MouseDownKey);
			mc['buttonComma'].char = ",".toString();
			
			mc['buttonSpace'].addEventListener(TouchEvent.MOUSE_DOWN, this.DownKey);
			mc['buttonSpace'].addEventListener(MouseEvent.CLICK, this.MouseDownKey);
			mc['buttonSpace'].char = " ";
			
			mc['buttonBackSpace'].addEventListener(TouchEvent.MOUSE_DOWN, this.BackSpaceDown);
			mc['buttonEnter'].addEventListener(TouchEvent.MOUSE_DOWN, this.EnterDown);
			mc['buttonBackSpace'].addEventListener(MouseEvent.CLICK, this.MouseBackSpaceDown);
			mc['buttonEnter'].addEventListener(MouseEvent.CLICK, this.MouseEnterDown);
			
			mc['buttonShift'].addEventListener(TouchEvent.MOUSE_DOWN, this.ShiftDown);
			mc['buttonShift'].addEventListener(TouchEvent.MOUSE_UP, this.ShiftUp);
		}

		function ShiftDown(e:Event) {
			inShift = !inShift;
			e.stopPropagation();
		}
		function ShiftUp(e:Event) {
			inShift = false;			
			e.stopPropagation();
		}
		function BackSpaceDown(e:Event) {
			var t: TextField = parent.getChildByName('TextObject_0').getChildByName('t');
			var tmp:String = t.text;
			t.text = tmp.slice(0,tmp.length-1);
			var format:TextFormat= new TextFormat();
			format.font= "myFont";
			format.color= 0xFFFFFF;
			format.size= 72;
			t.setTextFormat(format);			
			parent.setChildIndex(t.parent, parent.numChildren-1);			
			e.stopPropagation();
		}
		function EnterDown(e:Event) {			
			parent.getChildByName('TextObject_0').name = 'TextObject_1';
			var TextObject_0: TextObject = new TextObject(' ',true);
			TextObject_0.name = 'TextObject_0';
			TextObject_0.rotation = rotation;
			TextObject_0.x = 100;
			TextObject_0.y = 100;
			parent.addChild(TextObject_0);	
			var t: TextField = parent.getChildByName('TextObject_0').getChildByName('t');			
			var tmp:String = t.text;
			t.text = '~';
			t.text += tmp.slice(0,tmp.length-1);
			var format:TextFormat= new TextFormat();
			format.font= "myFont";
			format.color= 0xFFFFFF;
			format.size= 72;
			t.setTextFormat(format);			
			parent.setChildIndex(t.parent, parent.numChildren-1);		
			e.stopPropagation();
		}
		function DownKey(e:Event) {					
			var t: TextField = parent.getChildByName('TextObject_0').getChildByName('t');
			var ch: String;			
			if (t.text == "~") t.text = ' ';			
			if (e.relatedObject.parent.char != undefined) 
			 	ch = e.target.parent.char;
			else 
				ch = e.relatedObject.parent.parent.char;
				
			if (inShift) {
				t.text += ch.toUpperCase();
			} else {
				t.text += ch;
			}		
			
			var format:TextFormat= new TextFormat();
			format.font = "myFont";
			format.color= 0xFFFFFF;
			format.size = 72;
			t.setTextFormat(format);
			
			parent.setChildIndex(t.parent, parent.numChildren-1);
		 
			e.stopPropagation();
			
		}
		function MouseDownKey(e:Event) {					
			var t: TextField = parent.getChildByName('TextObject_0').getChildByName('t');
			var ch: String;			
			if (t.text == "~") t.text = ' ';			
			if (e.target.parent.char != undefined) {
			 	ch = e.target.parent.char;
			 	}
			else {
			ch = e.target.parent.parent.char;
			}
				
				
			if (inShift) {
				t.text += ch.toUpperCase();
			} else {
				t.text += ch;
			}		
			
			var format:TextFormat= new TextFormat();
			format.font = "myFont";
			format.color= 0xFFFFFF;
			format.size = 72;
			t.setTextFormat(format);
			
			parent.setChildIndex(t.parent, parent.numChildren-1);
		 
			e.stopPropagation();
			
		}	
		function MouseBackSpaceDown(e:Event) {
			var t: TextField = parent.getChildByName('TextObject_0').getChildByName('t');
			var tmp:String = t.text;
			t.text = tmp.slice(0,tmp.length-1);
			var format:TextFormat= new TextFormat();
			format.font= "myFont";
			format.color= 0xFFFFFF;
			format.size= 72;
			t.setTextFormat(format);			
			parent.setChildIndex(t.parent, parent.numChildren-1);
			e.stopPropagation();
		}
		function MouseEnterDown(e:Event) {		
			parent.getChildByName('TextObject_0').name = 'TextObject_1';
			var TextObject_0: TextObject = new TextObject(' ',true);
			TextObject_0.name = 'TextObject_0';
			TextObject_0.rotation = rotation;
			TextObject_0.x = 400;
			TextObject_0.y = 150;
			parent.addChild(TextObject_0);	
			var t: TextField = parent.getChildByName('TextObject_0').getChildByName('t');			
			var tmp:String = t.text;
			t.text = '~';
			t.text += tmp.slice(0,tmp.length-1);
			var format:TextFormat= new TextFormat();
			format.font= "myFont";
			format.color= 0xFFFFFF;
			format.size= 72;
			t.setTextFormat(format);			
			parent.setChildIndex(t.parent, parent.numChildren-1);		
			e.stopPropagation();
		} 	
		function fireFunc(e:Event)
		{
			if(this.x >= parent.stage.stageWidth-100){
			Tweener.addTween(this, {x:parent.stage.stageWidth/2,y:(parent.stage.stageHeight/2),scaleX: 1.0, scaleY: 1.0, rotation:0, time:0.5, transition:"easeinoutquad"});	
				
			}else{
			Tweener.addTween(this, {x:parent.stage.stageWidth+150,y:300,scaleX: 0.5, scaleY: 0.5, rotation:-0, time:0.5, transition:"easeinoutquad"});	
			}
		}
		 
	}
}