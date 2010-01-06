package com.touchlib {
	
	import flash.display.Sprite;
	//import flash.text.TextFormat;
	//import flash.text.TextField;
	//import flash.text.TextFieldAutoSize;

	public class TUIOCursor extends Sprite
	{
		//private var DEBUG_TEXT:TextField;	
		
		public function TUIOCursor(debugText:String,color:int,pressure:Number,thewidth:Number, theheight:Number)
		{
			super();
			if(TUIO.bDebug) { 
			graphics.lineStyle( 2, 0x000000);
			if(pressure >= 0 && pressure != null){			
			graphics.drawCircle(0 ,0, pressure+10);
			}
			else{
			graphics.drawCircle(0 ,0, 15);
			}
			
		
			/*//graphics.beginFill(color , 1);	
			// Draw us the lil' circle
			graphics.beginFill(0xFF00FF , 1);	
			graphics.drawCircle(0 ,0, 10);	
			graphics.lineStyle( 1, 0x000000 );
			graphics.moveTo( 0, -6 );
			graphics.lineTo( 0, 6 );
			graphics.moveTo( -6, 0 );
			graphics.lineTo( 6, 0 );
			graphics.endFill();*/
			this.blendMode="invert";
			
			/*
			if (debugText != '' || debugText != null)
			{
				var format:TextFormat = new TextFormat();
				DEBUG_TEXT = new TextField();
	        	format.font = 'Verdana';
	     		format.color = 0x000000;
	       	 	format.size = 10;
				DEBUG_TEXT.defaultTextFormat = format;
				DEBUG_TEXT.autoSize = TextFieldAutoSize.LEFT;
				DEBUG_TEXT.background = true;	
				DEBUG_TEXT.backgroundColor = 0x000000;	
				DEBUG_TEXT.border = true;	
				DEBUG_TEXT.text = '';
				DEBUG_TEXT.appendText(' '+debugText+'  ');				
				DEBUG_TEXT.x = 12;
				DEBUG_TEXT.y = -13;  				
				addChild(DEBUG_TEXT);
			}*/
		}
			else
			{			
			/* hide cursor
			graphics.lineStyle( 1, 0x000000 );
			//graphics.drawRect((-thewidth/2)-10,(-theheight/2)-10,thewidth+20,theheight+20);
			trace('--------------------------------------- w:' + width + ' h:' + height);
			graphics.moveTo( 0, -5 );
			graphics.lineTo( 0, 5 );
			graphics.moveTo( -5, 0 );
			graphics.lineTo( 5, 0 );
			this.blendMode='invert';
			*/
			}	
		}		
	}
}