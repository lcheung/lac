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

	import flash.filters.*;

	public class mTouchSurface extends Multitouchable {
		//[Embed(source="brush.swf", symbol="Brush")]
		//public var Brush:Class;


		private var MenuItems:Array;
		private var paintBmpData:BitmapData;
		private var paintBmp:Bitmap;

		//private var MenuItem1:MovieClip;

		public function mTouchSurface() {
			Init();
		}
		function Init() {
			blobs = new Array();

			paintBmpData = new BitmapData(1024, 768, true, 0x00000000);

			MenuItems = new Array();
			paintBmp = new Bitmap(paintBmpData,'auto',true);
			this.addEventListener(Event.ENTER_FRAME, this.frameUpdate);

			this.addChild(paintBmp);
			
			for (var i:int = 0; i<=3; i++) 
			{
				var l:Loader = new Loader();
				switch (i) 
				{
					case (0) :
						l.load(new URLRequest("www/img/nuisurface/top_0.png"));
						break;
					case (1) :
						l.load(new URLRequest("www/img/nuisurface/top_1.png"));
						break;
					case (2) :
						l.load(new URLRequest("www/img/nuisurface/top_2.png"));
						break;
					case (3) :
						l.load(new URLRequest("www/img/nuisurface/top_3.png"));
						break;
				}
				
				l.scaleX = 0.5;
				l.scaleY = 0.5;
				l.x = -150/2;
				l.y = -150/2;
				var MenuItem1:MovieClip = new MovieClip();
				MenuItems.push({mc: MenuItem1});
				
				MenuItems[i].mc.addChild(l);
				//MenuItems[i].mc.l.x = -100;
				//MenuItems[i].mc.l.y = -100;

				switch (i) {
					case (0) :
						MenuItems[i].mc.Action = 'Trace';
						var m:Loader = new Loader();
						m.load(new URLRequest("www/img/nuisurface/bottom_0.png"));
						m.x = -150/2;
						m.y = +150/2;
						m.scaleX = 0.5;
						m.scaleY = 0.5;
						m.alpha = 0.15;
						MenuItems[i].mc.addChild(m);

						l.addEventListener(TouchEvent.MOUSE_DOWN, this.RunTrace);
						l.addEventListener(MouseEvent.MOUSE_DOWN, this.RunTrace);																	
						
						break;
					case (1) :
						MenuItems[i].mc.Action = 'Paint';
						var m:Loader = new Loader();
						m.load(new URLRequest("www/img/nuisurface/bottom_1.png"));
						m.x = -150/2;
						m.y = +150/2;
						m.scaleX = 0.5;
						m.scaleY = 0.5;
						m.alpha = 0.15;
						MenuItems[i].mc.addChild(m);
						
						l.addEventListener(TouchEvent.MOUSE_DOWN, this.RunPaint);
						l.addEventListener(MouseEvent.MOUSE_DOWN, this.RunPaint);																							
						break;
					case (2) :
						MenuItems[i].mc.Action = 'Photo';
						var m:Loader = new Loader();
						m.load(new URLRequest("www/img/nuisurface/bottom_2.png"));
						m.x = -150/2;
						m.y = +150/2;
						m.scaleX = 0.5;
						m.scaleY = 0.5;
						m.alpha = 0.15;
						MenuItems[i].mc.addChild(m);
						
						l.addEventListener(TouchEvent.MOUSE_DOWN, this.RunPhoto);
						l.addEventListener(MouseEvent.MOUSE_DOWN, this.RunPhoto);							
						break;
					case (3) :
						MenuItems[i].mc.Action = 'Ripples';
						var m:Loader = new Loader();
						m.load(new URLRequest("www/img/nuisurface/bottom_3.png"));
						m.x = -150/2;
						m.y = +150/2;
						m.scaleX = 0.5;
						m.scaleY = 0.5;
						m.alpha = 0.15;
						MenuItems[i].mc.addChild(m);
						break;
				}
				MenuItems[i].mc.x = 1024/2;
				MenuItems[i].mc.y = 768/2;
				MenuItems[i].mc.hAngle = 180 / 4 * i - 90;
				MenuItems[i].mc.hVel = 0;
				MenuItems[i].scaleX = 0.5;
				MenuItems[i].scaleY = 0.5;

				var filter:BitmapFilter = new DropShadowFilter(5.0,90,0x000000,0.7,15,15,1.0,1);
				MenuItems[i].mc.filters = [filter];

				//MenuItems[i].mc.addEventListener(TouchEvent.DownEvent, this.RunApp);
				//MenuItems[i].mc.graphics.beginFill(0xffffff,0.8);
				//MenuItems[i].mc.graphics.drawRect(-100,-100,100,100);
				//MenuItems[i].mc.graphics.loadMovie();


				this.addChild(MenuItems[i].mc);

			}
		}
		
		function RunTrace(e:Event)
		{
			var subobj = new TraceSurface();
			subobj.name = "TraceSurface";
			parent.addChild(subobj);
			parent.removeChild(parent.getChildByName("SurfaceHolder"));			
		}
		
		function RunPaint(e:Event)
		{
			trace(e.currentTarget);
			var subobj = new PaintSurface();
			subobj.name = "PaintSurface";
			parent.addChild(subobj);
			parent.removeChild(parent.getChildByName("SurfaceHolder"));			
		}
		
		function RunPhoto(e:Event)
		{
			var subobj = new PhotoCanvas();
			subobj.name = "PhotoSurface";
			parent.addChild(subobj);
			flickrLoader = new Flickr(subobj);
			parent.removeChild(parent.getChildByName("SurfaceHolder"));			
		}
		
		function frameUpdate(e:Event) 
		{

			var pt = new Point(0,0);
			var matrix1 = new Matrix();
			var fIndex:Number = -1;
			var i:int, j:int;
			var velChange:Number = 0;
			for (i=0; i<blobs.length; i++) 
			{
				velChange += blobs[i].dX;
			}
			
			//if(velChange != 0)
			//trace(velChange);
			// optimized some stuff here to make it simpler and faster
	
			for (j=0; j<MenuItems.length; j++) 
			{
				
				MenuItems[j].mc.hVel += velChange;
				if (MenuItems[j].mc.hVel > 10) MenuItems[j].mc.hVel = 10;
				if (MenuItems[j].mc.hVel < -10) MenuItems[j].mc.hVel = -10;
				
				MenuItems[j].mc.hAngle += MenuItems[j].mc.hVel;
				
				if (MenuItems[j].mc.hAngle <= -90) 
				{
					MenuItems[j].mc.hAngle = 90 - (-90 - MenuItems[j].mc.hAngle);
					//MenuItems[j].mc.hAngle = 90;
				} else {
					if (MenuItems[j].mc.hAngle >= 90) {
						MenuItems[j].mc.hAngle = (MenuItems[j].mc.hAngle - 90) + (-90);
						//MenuItems[j].mc.hAngle = 90;
					}
				}
				MenuItems[j].mc.hVel *= 0.90;
				MenuItems[j].mc.x = (MenuItems[j].mc.hAngle+90)/180 * 1024;
				MenuItems[j].mc.scaleX = Math.sin(Math.PI / 180 * (MenuItems[j].mc.hAngle+90));
				MenuItems[j].mc.scaleY = Math.sin(Math.PI / 180 * (MenuItems[j].mc.hAngle+90));
				MenuItems[j].mc.alpha = Math.sin(Math.PI / 180 * (MenuItems[j].mc.hAngle+90));
			}
			

		}

	}
}