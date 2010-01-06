package app.core.canvas
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import flash.display.Sprite;		
	import flash.events.*;
	import flash.events.*;	
   	import flash.geom.*;	
   	import flash.filters.*;
   	
	public class RippleCanvas extends Sprite
	{
		
		private var blobs:Array;		
		internal var sourceBmp:BitmapData;		
		internal var paintBmpData:BitmapData;
		internal var paintBmpData2:BitmapData;		
		private var buffer:BitmapData;		
		private var paintBmp:Bitmap;
		private var output:Bitmap;
		private var brush:Sprite;
		private var logo:Sprite;
		private var filter:BitmapFilter;
		private var filter2:BitmapFilter;		

		private var dispFilt:BitmapFilter;				
		
		private var outputBmpData:BitmapData;				
		private var surface:BitmapData;						
		
		internal var pt = new Point(0,0);
		internal var matrix1 = new Matrix();		
		
		public function RippleCanvas()
		{
			blobs = new Array();
			paintBmpData = new BitmapData(128, 98, false, 0x80);
			paintBmpData2 = new BitmapData(128, 98, false, 0x80);			
			
			logo = new Sprite();			
			
			brush = new Sprite();
			brush.graphics.beginFill(0xFFFFFF,1);
			brush.graphics.drawCircle(0,0,4);
					
			
			surface = new BitmapData(128, 98, true, 0x000000);			
			surface.draw(logo);
			
			sourceBmp = new BitmapData(128, 98, false, 0x80);											
			buffer = paintBmpData.clone();			
			
			outputBmpData = new BitmapData(128, 98, false, 0x80);
			
			scaleX = 8.0;
			scaleY = 8.0;
			
			//trace(brush);
			
					
			//this.addEventListener(MouseEvent.MOUSE_MOVE, this.mouseMoveHandler);									
			//this.addEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownEvent);															
			//this.addEventListener(MouseEvent.MOUSE_UP, this.mouseUpEvent);	
			//this.addEventListener(MouseEvent.MOUSE_OVER, this.mouseRollOverHandler);
			//this.addEventListener(MouseEvent.MOUSE_OUT, this.mouseUpEvent);	
			
			this.addEventListener(TouchEvent.MOUSE_MOVE, this.moveHandler, false, 0, true);			
			this.addEventListener(TouchEvent.MOUSE_DOWN, this.downEvent, false, 0, true);						
			this.addEventListener(TouchEvent.MOUSE_UP, this.upEvent, false, 0, true);									
			this.addEventListener(TouchEvent.MOUSE_OVER, this.rollOverHandler, false, 0, true);									
			this.addEventListener(TouchEvent.MOUSE_OUT, this.rollOutHandler, false, 0, true);															
			
			this.addEventListener(Event.ENTER_FRAME, this.update, false, 0, true);			
			paintBmp = new Bitmap(paintBmpData);
			
			
			var cmat:Array = [ 1, 1, 1,
						       1, 1, 1,
							   1, 1, 1 ] ;
			filter = new ConvolutionFilter(3, 3, cmat, 9, 0);
			filter2 = new BlurFilter(4,4);
			
			output = new Bitmap(outputBmpData);
//			output.blendMode = BlendMode.ADD;					
			//paintBmp.blendMode = BlendMode.ADD;
			
			addChild(output);			
			addChild(paintBmp);


//			var tf = new TextField();
//			tf.text = "testing123";
//			addChild(tf);


           disp = new DisplacementMapFilter(paintBmpData2, new Point(), 4, 4, 48, 48, DisplacementMapFilterMode.IGNORE );
		   
          	this.filters = new Array(new BlurFilter(16, 16));

		}
		
		function addBlob(id:Number, origX:Number, origY:Number)
		{
			for(var i=0; i<blobs.length; i++)
			{
				if(blobs[i].id == id)
					return;
			}
			
			blobs.push( {id: id, origX: origX, origY: origY, myOrigX: x, myOrigY:y} );
		}
		
		function removeBlob(id:Number)
		{
			for(var i=0; i<blobs.length; i++)
			{
				if(blobs[i].id == id) 
				{
					blobs.splice(i, 1);		
					return;
				}
			}
		}
		
		function update(e:Event)
		{

			for(var i:int = 0; i<blobs.length; i++)
			{
				var tuioobj:TUIOObject = TUIO.getObjectById(blobs[i].id);
				
				// if not found, then it must have died..
				if(!tuioobj)
				{
					removeBlob(blobs[i].id);
				} else {
					if(parent!=null){
					var localPt:Point = parent.globalToLocal(new Point(tuioobj.x*0.125, tuioobj.y*0.125));										
					var m:Matrix = new Matrix();
					m.translate(localPt.x, localPt.y);
					sourceBmp.draw(brush, m, null, 'invert');
					}
				}
				
			}
			
			
			paintBmpData.applyFilter(sourceBmp, paintBmpData.rect, pt, filter);
			paintBmpData.draw(paintBmpData, matrix1, null, 'add');
			paintBmpData.draw(buffer, matrix1, null, 'difference');			
			paintBmpData.draw(paintBmpData, matrix1, new ColorTransform(0, 0, 0.98609374, 1, 0, 0, 2, 0));			
			paintBmpData2.draw(paintBmpData, matrix1);
//			paintBmpData2.applyFilter(paintBmpData2, paintBmpData.rect, pt, filter2);			

			outputBmpData.applyFilter(surface, outputBmpData.rect, pt, disp);
			
			buffer = sourceBmp;
			sourceBmp = paintBmpData.clone();
//			buffer.copyPixels(sourceBmp, sourceBmp.rect, pt);
//			sourceBmp.copyPixels(paintBmpData, paintBmpData.rect, pt);

		}
		
		
		public function downEvent(e:TouchEvent)
		{		
			if(e.stageX == 0 && e.stageY == 0)
				return;			
			
			var curPt:Point = parent.globalToLocal(new Point(e.stageX, e.stageY));									
			

			addBlob(e.ID, curPt.x, curPt.y);
			

				
			e.stopPropagation();
		}
		
		public function upEvent(e:TouchEvent)
		{		
			
				
			removeBlob(e.ID);			
				
			e.stopPropagation();				
				
		}		

		public function moveHandler(e:TouchEvent)
		{
		}
		
		public function rollOverHandler(e:TouchEvent)
		{
		}
		
		public function rollOutHandler(e:TouchEvent)
		{
		
		}		
		
	}
}