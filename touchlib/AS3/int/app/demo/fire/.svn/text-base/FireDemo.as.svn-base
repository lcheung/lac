package app.demo.fire
{

	import flash.display.*;
	import flash.filters.*;
	import flash.geom.*;
	import flash.events.*;
	import app.core.action.*;
	import app.core.element.*;
	
	public class FireDemo extends Multitouchable
	{
		// make 200x200 canvas
		private var canvas:BitmapData;
		private var canvasBitmap:Bitmap;
	
		// genral geometry constants
		private var p1:Point;
		private var p2:Point;
		private var p3:Point;
		private var r:Rectangle;
		private var blobRect:Rectangle;
		
		// constants that define fire appearance
		private var bf:BlurFilter;
		private var ct:ColorTransform;
		private var ct2:ColorTransform;		
		private var m:Matrix;
		
		// make some noise pattern
		private var noise:BitmapData;
		
		function FireDemo()
		{
			// make 200x200 canvas
			canvas = new BitmapData(256, 256, false, 0);
			canvasBitmap = new Bitmap(canvas);
			addChild(canvasBitmap);
			// genral geometry constants
			p1 = new Point (0, 0);
			p2 = new Point (0, canvas.height -1);
			p3 = new Point (0,0);
			r = new Rectangle (0, 0, canvas.width, 2);
			blobRect = new Rectangle(0,0, 128, 128);

			// constants that define fire appearance
			bf = new BlurFilter (6,6, 1);
			ct = new ColorTransform(1.037, 1.03, 1, 1, -1, -1, -1, 0);
			ct2 = new ColorTransform(2, 1.5, 0.5);
			m = new Matrix (); 
			m.translate(0, -1);
		
			// make some noise pattern
			noise = new BitmapData(canvas.width, 321);
			noise.perlinNoise(8, 8, 3, 7, false, false, 1|2|4, true);
			
			addEventListener(Event.ENTER_FRAME, updateFire, false, 0, true);
			
			if(this.stage)
			{
				addedToStage(new Event(Event.ADDED_TO_STAGE));
			} else {
				this.addEventListener(Event.ADDED_TO_STAGE, addedToStage, false, 0, true);
			}			

			TUIO.init( this, 'localhost', 3000, '', false );		
			
		}
		
		function addedToStage(e:Event)
		{
			trace("Added to stage");
			this.stage.addEventListener(Event.RESIZE, stageResized, false, 0, true);			
			stageResized(new Event(Event.RESIZE));			
			
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);			
		}
		
		function stageResized(e:Event)
		{			
			stage.align = StageAlign.TOP_LEFT;
			stage.displayState = StageDisplayState.FULL_SCREEN;			
			this.x = 0;
			this.y = 0;
			var wd:int = stage.stageWidth;
			var ht:int = stage.stageHeight;		
			
			canvasBitmap.width = wd;
			canvasBitmap.height = ht;
			
		}

		public function drawBlob(id:int, mx:Number, my:Number)
		{
			var bx:Number, by:Number;
			
			p3.x = int(mx * 256 / stage.stageWidth) - 4;
			p3.y = int(my * 256 / stage.stageHeight) - 4;			
			
			//blobRect.y = (blobRect.y + 1) % (noise.height);
			
			blobRect.left = p3.x;
			blobRect.top = p3.y;			
			blobRect.right = p3.x+8;
			blobRect.bottom = p3.y+8;						
			// add noise at the bottom
//			canvas.(noise, blobRect, p3, 255, 255, 255, 255);			
			
			trace("Update move");
			var m2:Matrix = new Matrix();
			m2.translate(p3.x, p3.y);
			canvas.draw(noise, m2, ct2, BlendMode.ADD, blobRect);

			

		}		
		

	
	
		function updateFire(e:Event) 
		{
			// go through noise pattern
			r.y = (r.y + 1) % noise.height;
		
			// add noise at the bottom
			//canvas.copyPixels(noise, r, p2);
			trace(blobs.length);
			
			for(var i:int = 0; i<blobs.length; i++)
			{
				if(blobs[i].history.length >= 2)
				{
					var len:int = blobs[i].history.length;
					drawBlob(blobs[i].id, blobs[i].history[len-1].x, blobs[i].history[len-1].y);
				}
			}
			
		
			// blur
			canvas.applyFilter(canvas, canvas.rect, p1, bf);
		
			// scroll & change color
			canvas.draw(canvas, m, ct);
		}
	}
}