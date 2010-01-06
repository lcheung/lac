package app.demo.nuiSurface {
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.geom.*;
	
	import flash.events.*;	
	import app.demo.nuiSurface.*;
	import app.core.element.*;	
	import app.core.action.*;		
	
	import whitenoise.*;


	import flash.filters.*;

	public class TraceSurface extends Multitouchable {
		//[Embed(source="brush.swf", symbol="Brush")]
		//public var Brush:Class;

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

		public function TraceSurface() 
		{
			Init();
		}
		
		function Init() {
			blobs = new Array();
			
			Paths = new Array();
			
			paintBmpData = new BitmapData(1024, 768, true, 0x00000000);
			
			paintBmp = new Bitmap(paintBmpData,'auto',true);
		


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
		
		// FIXME: handle paths stuff using blob added and blob removed functions.. (see multitouchable.. 
		
		public override function handleBlobCreated(id:int, mx:Number, my:Number):void
		{
			var holder: MovieClip = new MovieClip();
			
			Paths.push({mc: holder, blobID: id});
			addChild(Paths[Paths.length -1].mc);			
		}
		
		public override function handleBlobRemoved(id:int):void
		{
			for(var j:int = 0; j<Paths.length; j++) {
				trace(Paths[j].blobID);
				if (Paths[j].blobID == id) {
					//Paths[j].mc.clear();
					removeChild(Paths[j].mc);
					Paths.splice(j,1);
				}
			}			
		}		
		

		function update(e:Event) {

			var pt = new Point(0,0);
			var matrix1 = new Matrix();
			var fIndex:Number = -1;
			
			for(var i:int = 0; i<blobs.length; i++)
			{

				for(var j:int = 0; j<Paths.length; j++) 
				{
					if (Paths[j].blobID == blobs[i].id) {
						//trace('Found '+j);
						fIndex = j;
					}
				}
				if (fIndex == -1)  
				{
					if (Paths[fIndex] == undefined) {
						
					}
				}
				else
				{

				}
			}


		}

	}
}