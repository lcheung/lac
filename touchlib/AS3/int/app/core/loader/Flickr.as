package app.core.loader{	
	import app.core.object.ImageObject;
	import flash.display.DisplayObject;		
	import flash.display.MovieClip;	
	import flash.display.Sprite;	
	import flash.events.Event;	
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.geom.Point;

	public class Flickr extends Sprite
	{
		private var index:int = 0;		
		private var rest:URLLoader = null;
		private var flickr:XML = null;
		private var thestage:Sprite;
		private var fetchCount:Number;
		private var allPics:Array;	
		public var photo:ImageObject;
		
		public function Flickr(d:Sprite,fetchIn:Number) 
		{
			thestage = d;
			fetchCount = fetchIn;
			allPics = new Array();

		}
		public function fetch(type:String):void 
		{			
			clearPics();
			var request:URLRequest = 
			new URLRequest( "http://api.flickr.com/services/rest/" );
			var variables:URLVariables = new URLVariables();
			variables.api_key = "566c6aa058a2b4aa13f1b6ddc9bfd582";
			
			if(type == "recent")
			{
				variables.method = "flickr.photos.getRecent";
			} 
			else 
			{
				variables.method = "flickr.photosets.getPhotos";
				//72157594433368939
				//72157594381857577
				//72157594203926920
				
				//72157603423646710
				variables.photoset_id = type;
			}
			request.data = variables;
			rest = new URLLoader();
			rest.addEventListener( "complete", parse , false, 0, true);
			rest.load( request );
		}
		
		private function parse( event:Event ):void 
		{			
			flickr = new XML( rest.data );
			showPics();
		}

		private function showPics():void 
		{	
			var id:String = null;
			var secret:String = null;
			var server:String = null;			
			var url:String = null;
			var request:URLRequest = null;			
			
			var len:int = flickr..photo.length();
		
			if(len > fetchCount)
				len = fetchCount;

			for(var i:int=0; i<len; i++)
			{
				server = flickr..photo[i].@server.toString();
				id = flickr..photo[i].@id.toString();
				secret = flickr..photo[i].@secret.toString();
				
				// Assemble the URL and request
				url = 	"http://static.flickr.com/" + server + "/" + id + "_" + 
						secret + ".jpg";
		
	
				photo = new ImageObject( url , true,false,true,false);
				photo.name="ImageObject_"+i;
				photo.scaleX = 0.5 + Math.random();
				photo.scaleY = photo.scaleX;
				photo.x = (Math.random()*2000) - 1000;
				photo.y = (Math.random()*2000) - 1000;				
				thestage.addChild(photo);
				allPics.push(photo);
			}
		}
		
		function clearPics():void
		{
			for(var i:int = 0; i<allPics.length; i++)
			{
				thestage.removeChild(allPics[i]);
			}			
			allPics = new Array();
		}

	}
}