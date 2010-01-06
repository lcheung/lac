package app.demo.artgen
{
	import flash.display.*;
	import flash.events.*;
	import app.demo.artgen.*;
	import flash.geom.*;
	import flash.net.*;
	import flash.events.*;
	
	public class Swarm extends Sprite 
	{
		public var members:Array;
		public var shapeloader:URLLoader;
		//public var guide:Sprite;
		
		private var drawingCanvas:Sprite;
		
		private var xmlSetupInfo:XML;
		
		private var waitCount:int = 5;
		private var waitCountLeft:int = 5;		

		public var id:int;
		
		public var trackPt:Point;
		
		private var r:Number;
		private var g:Number;
		private var b:Number;
		

		public function Swarm(i:int, ix:Number, iy:Number) 
		{
			trackPt = new Point();
			
			trackPt.x = ix;
			trackPt.y = iy;

			id = i;
			members = new Array();
		}
		
		public function setDrawingCanvas(dc:Sprite)
		{
			drawingCanvas = dc;
		}
		
		public function addMember(m:ISwarmMember)
		{
			addChild(m);
			members.push(m);
		}
		
		public function clear()
		{
			for( var i:int = 0; i<members.length; i++)
			{			
				removeChild(members[i]);
			}
			
			members = new Array();
		}
		
		public function setupInfo(data:XML)
		{
			// fixme: clear membmers.. 
			clear();
			

			
			trace("r" + r + " b" + b + " g" + g);
			
			waitCount = data.trail.createDelay;
			trace("www/shapes/" + data.shape);
			xmlSetupInfo = data;
			shapeloader = new URLLoader( );	
			shapeloader.dataFormat = URLLoaderDataFormat.BINARY;
			shapeloader.load( new URLRequest(	"www/shapes/" + data.shape ) );
			shapeloader.addEventListener(HTTPStatusEvent.HTTP_STATUS, loaderEvent);

			shapeloader.addEventListener(Event.COMPLETE, loaderEvent);
			
			// FIXME: create members.. 
			// Factory kinda thing.. 
			
			for( var i:int = 0; i<data.numMembers; i++)
			{
				addMember(createMember(data.swarmType, data));
				trace("Member");
			}
		}
		
		public function loaderEvent(e:Event)
		{
			trace("URLLoader event " + e.type);
			
			if(e.type == "complete")
			{

			}
		}
		
		
		public function createMember(sz:String, data:XML):ISwarmMember
		{
			var m:ISwarmMember;
			switch(sz)
			{
				case "LazyFollower":
					m = new LazyFollower();
					break;
				case "HoppingBugs":
					m = new HoppingBugs();
					break;
				case "Boid":
					m = new Boid();
					break;
				case "Boid2":
					m = new Boid2();
					break;					
			}
			m.x = trackPt.x;
			m.y = trackPt.y;
			m.setSwarm(this);
			m.setupInfo(data.algorithm);
			m.memberscale = data.scale;
			m.memberalpha = data.alpha;			

			var mod:XML;
			for each(mod in data.modulators.modulator)
			{


				m.addModulator(mod.type, mod.rate, mod.dest, mod.amount);
			}
			
			return m;
		}
		

		public function getCentroid():Point
		{

			var pt = new Point();
			for( var i:int = 0; i<members.length; i++)
			{			
				pt.x += members[i].x;
				pt.y += members[i].y;
			}
			
			pt.x /= members.length;
			pt.y /= members.length;
			return pt;
		}
		
		public function getAverageVel():Point
		{
			var pt = new Point();
			for( var i:int = 0; i<members.length; i++)
			{			
				pt.x += members[i].vel.x;
				pt.y += members[i].vel.y;			
			}
			
			pt.x /= members.length;
			pt.y /= members.length;
			return pt;
		}
		
		public function setTrack(pt:Point)
		{
			trackPt = pt;
		}
		
		public function track()
		{
			for(var i:int =0; i<members.length; i++)
			{
				members[i].track(trackPt);
			}
		}
		
		public function draw()
		{

			waitCountLeft -= 1;
			
			if(waitCountLeft == 0)
			{


			
//			drawingCanvas.graphics.beginFill(0xffffff);
			if(shapeloader.data != null)
			{
				for(var i:int =0; i<members.length; i++)
				{
	//				drawingCanvas.graphics.drawCircle(members[i].x, members[i].y, 5);

					members[i].runModulators();
					
					var t:Sprite = new Trail(xmlSetupInfo.trail, shapeloader.data);
					t.x = members[i].x;
					t.y = members[i].y;
					
					t.rotation = members[i].rotation + 180; //+ Math.random()*40;
	// Math.atan2(members[i].vel.x, members[i].vel.y) * 180 / Math.PI;
					t.scaleX = members[i].scaleX;
					t.scaleY = members[i].scaleY;
					t.transform.colorTransform.alphaMultiplier = members[i].alpha;
					//t.transform.colorTransform.redMultiplier = r;
					//t.transform.colorTransform.greenMultiplier = g;					
					//t.transform.colorTransform.blueMultiplier = b;					
					drawingCanvas.addChild(t);
					t = null;
				}
			}			
//			drawingCanvas.graphics.endFill();

				waitCountLeft = waitCount;
			}			

		}
		

	}
}