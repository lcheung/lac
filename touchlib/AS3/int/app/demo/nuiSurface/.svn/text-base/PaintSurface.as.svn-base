﻿package app.demo.nuiSurface {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import app.core.element.FocusButton;

	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.geom.*;

	import flash.events.*;	

	import app.core.element.*;
	import app.core.action.*;

	public class PaintSurface extends Multitouchable {
		private var paintBmpData:BitmapData;
		private var paintBmp:Bitmap;
		private var brush:Sprite;	
		private var col:ColorTransform;
		private var clearButton:Sprite;
		private var bmp:Sprite;
		private var exitButton:FocusButton;
		private var colorSelect:ColorPicker;
		private var color;
		//private var m_stage:Stage;
		public function PaintSurface() 
		{
			init();
			//m_stage=e;
		}
		
		function init() 
		{				
			blobs = new Array();
			paintBmpData = new BitmapData(1024, 768, true, 0x00000000);
			
			brush = new Sprite();
			brush.graphics.beginFill(0xFFFFFF);
			brush.graphics.drawCircle(0,0,10);	
			
			clearButton = new Sprite();
			clearButton.x = 10;
			clearButton.y = 190;
			
			bmp = new Sprite();
			bmp.x = 0;
			bmp.y = 0;			
			clearButton.graphics.beginFill(0xFFFFFF);
			clearButton.graphics.drawRect(-1, -1, 50, 50);			
			bmp.graphics.beginFill(0x000000,0.0);
			bmp.graphics.drawRect(-1, -1, 800, 600);
			paintBmp = new Bitmap(paintBmpData,'auto',true);	
			bmp.cacheAsBitmap = true;
			bmp.blendMode="invert";
			bmp.name="Note";
			bmp.addChild(paintBmp);
			this.addChild(bmp);			
			
			colorSelect = new ColorPicker();
			colorSelect.x = 1040/2;
			colorSelect.y = 80;
			this.addChild(colorSelect);
			
			this.addEventListener(Event.ENTER_FRAME, this.update);    
			if (col==undefined) {setBlue(null);}
			
		}
		function setColor(r:Number, g:Number, b:Number) {
			col = new ColorTransform(r, g, b);
		}
		function setBlue(e:Event) {
			setColor(1.0, 1.0, 1.0);
		}
		
		public function clearLayer(e:Event) {
			paintBmpData.dispose(); 
			init();
		}

		function update(e:Event) {
			
			var pt = new Point(0,0);
			var matrix1 = new Matrix();
			for(var i:int = 0; i<blobs.length; i++)
			{	//col = colorSelect.color;
				var line:Sprite = new Sprite();
				line.graphics.lineStyle(12,0xffffff,1,true);
				var historyLen:int = blobs[i].history.length;
				if(historyLen >= 2)
				{
				line.graphics.moveTo(blobs[i].history[historyLen-2].x,blobs[i].history[historyLen-2].y);					
				line.graphics.lineTo(blobs[i].history[historyLen-1].x,blobs[i].history[historyLen-1].y);
				paintBmpData.draw(line, null, col, 'normal');
				}
			}
		}
	}
}