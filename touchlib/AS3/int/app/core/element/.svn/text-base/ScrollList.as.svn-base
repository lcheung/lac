package app.core.element
{
	
	import flash.display.*;		
	import flash.events.*;
	import flash.net.*;
	import flash.events.*;	
	import flash.geom.*;			
    import flash.filters.*;
	import flash.text.*;



	public class ScrollList extends Sprite
	{
		private var backGraphic:Sprite;
		private var display:TextField;
		private var szValues:Array;
		private var selectedIndex:int = 0;
		
		private var nextBtn:ArrowButton;
		private var prevBtn:ArrowButton;		
		
		public function ScrollList(values:Array)
		{
			szValues = values;
	
			
			backGraphic = new Sprite();
			backGraphic.graphics.beginFill(0x000000, 0.1);
			backGraphic.graphics.drawRoundRect(0,0,220,70, 10, 10);
			backGraphic.graphics.endFill();
			
			addChild(backGraphic);
			
			var tf:TextFormat = new TextFormat();
			tf.color = 0xffffff;
			tf.font = "Neo Tech Std";
			tf.size = "16";		
			
			display = new TextField();
			display.x = 10;
			display.y = 20;
			display.width = 100;
			display.defaultTextFormat = tf;
			display.text = "novalue";
			display.selectable = false;

			prevBtn = new ArrowButton("left");
			nextBtn = new ArrowButton("right");
		
			prevBtn.x = 100;
			prevBtn.y = 10;
			nextBtn.x = 160;
			nextBtn.y = 10;			
		
			addChild(prevBtn);
			addChild(nextBtn);
			addChild(display);
			setSelectedIndex(0);
			
			prevBtn.addEventListener(MouseEvent.CLICK, prevHandler, false, 0, true);
			nextBtn.addEventListener(MouseEvent.CLICK, nextHandler, false, 0, true);
			
		}
		
		public function setSelectedIndex(index:int)
		{
			if(index >= szValues.length)
				index = szValues.length-1;
			if(index < 0)
				index = 0;
				
			selectedIndex = index;
			
			trace(index);

			display.text = szValues[index];
		}
		
		public function getSelected():String
		{
			return szValues[selectedIndex];
		}
		
		public function setSelected(sz:String)
		{
			var i:int = 0;
			for(i=0; i<szValues.length; i++)
				if(szValues[i] == sz)
				{
					setSelectedIndex(i);
					break;
				}

		}
		
		public function nextHandler(e:Event):void
		{
			setSelectedIndex(selectedIndex + 1);
			
		}
		
		public function prevHandler(e:Event):void
		{
			setSelectedIndex(selectedIndex - 1);
			
		}		

		
	}
}