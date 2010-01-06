package app.core.object {
	import app.core.action.RotatableScalable;
	
	import flash.display.Sprite;
	import flash.events.Event;	
	import flash.events.MouseEvent;	

	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import caurina.transitions.Tweener;	
	import app.core.element.Wrapper;
	
	public class TextObject extends RotatableScalable
	{
		[Embed(source="Arial.ttf", fontFamily="myFont")] 
		public var myFont:Class;
		
		public var t: TextField;
		public var mc: Sprite;
		public var inString:String;	
		public var closeButton:Boolean;	
			
		public function TextObject(inVar:String, _closeButton:Boolean)
		{	
			closeButton	= _closeButton;		

			inString = inVar;
			
			mc = new Sprite();
			mc.graphics.beginFill(0xFF00FF,1);
			mc.graphics.drawRect(-200,-200,400,400);
			noSelection = true;			
		
			var format:TextFormat= new TextFormat();
			format.font= "myFont";
			format.color= 0xFFFFFF;
			format.size= 99;
			
			t = new TextField();
			t.autoSize = TextFieldAutoSize.CENTER;
			//t.wordWrap = true;
			t.background = true;	
			t.backgroundColor = 0x000000;	
			t.border = true;	
			t.borderColor = 0x333333;			
			t.embedFonts = true;
			t.selectable  = true;		 
			if(inString != ' '){	t.text = ' '+inString+' ';}
			else{	t.text = "~";}
			
		
			t.name = "t";
			t.x = 0;
			t.y = -36;
			t.setTextFormat(format);
			
			//mc.addChild(t);
	  		this.addChild(t);	    
			trace('TEXT----'+closeButton);
			if(closeButton){
			var buttonSprite = new Sprite();						
			buttonSprite.graphics.beginFill(0xFFFFFF,0.75);
			buttonSprite.graphics.lineStyle(1,0x000000,0.85);
			buttonSprite.graphics.drawRoundRect(-t.width/2,-63,t.width+4,25,6);
			buttonSprite.addEventListener(MouseEvent.CLICK, fireFunc);	
			var WrapperObject:Wrapper = new Wrapper(buttonSprite);					
			this.addChild(WrapperObject);
			}
		}   
		function fireFunc(e:Event){
		//parent.removeChild(this); 	
		//this.alpha=0;			
		Tweener.addTween(this, {alpha:0,scaleX: 0.0, scaleY: 0.0, time:0.25, transition:"easeinoutquad"});	
		//this.visible=false;		
		}  		
	}
}