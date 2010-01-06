package app.core.canvas{
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.events.*;
	import flash.geom.*;
	
	import flash.filters.*;

	public class TraceCanvas extends MovieClip {
		//[Embed(source="brush.swf", symbol="Brush")]
		//public var Brush:Class;


		private var blobs:Array;// blobs we are currently interacting with
		private var sourceBmp:BitmapData;
		private var paintBmpData:BitmapData;
		private var paintBmpData2:BitmapData;
		private var buffer:BitmapData;
		private var paintBmp:Bitmap;
		private var brush:MovieClip;
		private var menu:MovieClip;
		private var filter:BitmapFilter;
		private var filter2:BitmapFilter;
		private var col:ColorTransform;

		private var redButton:MovieClip;
		private var blueButton:MovieClip;
		private var greenButton:MovieClip;
		private var clearButton:MovieClip;
		private var bmp:MovieClip;
		private var Paths: Array;

		public function TraceCanvas() {
			Init();
		}
		
		function Init() {
			blobs = new Array();
			
			Paths = new Array();
			
			paintBmpData = new BitmapData(1024, 768, true, 0x00000000);
			
			paintBmp = new Bitmap(paintBmpData,'auto',true);
		
			this.addEventListener(TouchEvent.MOUSE_MOVE, this.moveHandler);
			this.addEventListener(TouchEvent.MOUSE_DOWN, this.downEvent);
			this.addEventListener(TouchEvent.MOUSE_UP, this.upEvent);
			this.addEventListener(TouchEvent.MOUSE_OVER, this.rollOverHandler);
			this.addEventListener(TouchEvent.MOUSE_OUT, this.rollOutHandler);

			this.addEventListener(Event.ENTER_FRAME, this.update);
			
			this.addChild(paintBmp);
			
			var exitButton:Loader = new Loader();
			exitButton.load(new URLRequest("closeButton.png"));
			exitButton.x = 20;
			exitButton.y = 768 - 148;
			exitButton.alpha = 0.8;
			exitButton.addEventListener(TouchEvent.MOUSE_DOWN, this.exit);
			
			this.addChild(exitButton);

		}
		function exit(e:Event) {
			var subobj = new mTouchSurface();
			subobj.name = "SurfaceHolder";
			parent.addChild(subobj);
			parent.removeChild(parent.getChildByName("TraceSurface"));
		}
		function addBlob(id:Number, origX:Number, origY:Number) {
			for (var i=0; i<blobs.length; i++) {
				if (blobs[i].id == id) {
					return;
				}
			}
			blobs.push( {id: id, origX: origX, origY: origY, myOrigX: x, myOrigY:y, oldX:x, oldY: y} );
			
			var holder: MovieClip = new MovieClip();
			
			Paths.push({mc: holder, blobID: id});
			addChild(Paths[Paths.length -1].mc);
		}
		function removeBlob(id:Number) {
			for (var i=0; i<blobs.length; i++) {
				if (blobs[i].id == id) {
					blobs.splice(i, 1);
					
					trace('===');
					for(var j:int = 0; j<Paths.length; j++) {
						trace(Paths[j].blobID);
						if (Paths[j].blobID == id) {
							//Paths[j].mc.clear();
							removeChild(Paths[j].mc);
							Paths.splice(j,1);
						}
					}
					return;
				}
			}
		}
		function update(e:Event) {

			var pt = new Point(0,0);
			var matrix1 = new Matrix();
			var fIndex:Number = -1;
			for(var i:int = 0; i<blobs.length; i++)
			{
				var tuioobj:TUIOObject = TUIO.getObjectById(blobs[i].id);
				
				// if not found, then it must have died..
				if(!tuioobj)
				{
					removeBlob(blobs[i].id);
					for(var j:int = 0; j<Paths.length; j++) {
						if (Paths[j].blobID == blobs[i].id) {
							removeChild(Paths[j].mc);
							Paths.splice(j,1);
						}
					}
				} else {
					for(var j:int = 0; j<Paths.length; j++) {
						if (Paths[j].blobID == blobs[i].id) {
							//trace('Found '+j);
							fIndex = j;
						}
					}
					if (fIndex == -1)  {
						if (Paths[fIndex] == undefined) {
							
						}
					}
					else
					{
						var Line:MovieClip = Paths[fIndex].mc;
							Line.graphics.lineStyle(2,tuioobj.color,1.0);
							Line.graphics.moveTo(tuioobj.x,tuioobj.y);
							Line.graphics.lineTo(tuioobj.oldX,tuioobj.oldY);
					}
				}
			}
		}
		public function downEvent(e:TouchEvent) {
			if (e.stageX == 0 && e.stageY == 0) {
				return;
			}

			var curPt:Point = parent.globalToLocal(new Point(e.stageX, e.stageY));
			addBlob(e.ID, curPt.x, curPt.y);

			e.stopPropagation();
		}
		public function upEvent(e:TouchEvent) {
			
			removeBlob(e.ID);
			e.stopPropagation();

		}

		public function moveHandler(e:TouchEvent) {

			e.stopPropagation();
		}
		public function rollOverHandler(e:TouchEvent) {
		}
		public function rollOutHandler(e:TouchEvent) {

		}
	}
}