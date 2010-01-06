package app.core.loader {
	import flash.display.Sprite;		
	import flash.display.MovieClip;	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.geom.Point;	
	
	import app.core.object.SWFObject;

	public class nLoad extends MovieClip
	{
		private var index:int = 0;		
		private var fetchAmount:int;	
		private var fetchObject:String;	
		private var rest:URLLoader = null;
		private var flickr:XML = null;
		private var thestage:Sprite;
		private var allPics:Array;
		private var setX:int;	
		private var setY:int;
		private var setscaleXY:int;
		private var inGetWHAT:String;
		
		public function nLoad(d:Sprite, infetchAmount:int, getFlickrID:String, infetchObject:String, insetX:int, insetY:int, insetScaleXY:int, inGetWhat:String) 
		{
			thestage = d;
			fetchAmount = infetchAmount;
			allPics = new Array();
			fetch(getFlickrID);		
			fetchObject	= infetchObject;
			setX = insetX;
			setY = insetY;
			setscaleXY = insetScaleXY;
			inGetWHAT = inGetWhat;
		}
				
		public function fetch(objectType:String):void 
		{			
			clearPics();
			// Request and name/value query string variables
			var request:URLRequest = new URLRequest( "http://api.flickr.com/services/rest/" );
			var variables:URLVariables = new URLVariables();
			
			// Query string variables can be added dynamically
			// (e.g. AS2 Object)
			variables.api_key = "be30d4d2a8d4c100e513cb4026987c03";
			
			if(objectType == "recent")
			{
				variables.method = "flickr.photos.getRecent";
			} 
			else if(objectType == "mine") {
				variables.method = "flickr.photosets.getPhotos";
				variables.photoset_id = "72157594203926920";
			}		
			else if(objectType == "swf") {
				variables.method = "flickr.photosets.getPhotos";
				variables.photoset_id = "72157594203926920";
			}		
			else {
				variables.method = "flickr.photosets.getPhotos";
				variables.photoset_id = objectType;
			}		
			// Set the variables
			request.data = variables;
			rest = new URLLoader();
			rest.addEventListener( "complete", parse );
			rest.load( request );
		}
		
		// Called when the XML data has been returned from Flickr
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
			if(len > fetchAmount) len = fetchAmount;
			for(var i:int=0; i<len; i++)
			{
				server = flickr..photo[i].@server.toString();
				id = flickr..photo[i].@id.toString();
				secret = flickr..photo[i].@secret.toString();
				//url = 	"http://static.flickr.com/" + server + "/" + id + "_" + secret + ".jpg";
				url = inGetWHAT;
				var SWFObject_0:SWFObject = new SWFObject( url , setX, setY, setscaleXY);
				trace("Loaded: "+url);
				thestage.addChild(SWFObject_0);
				allPics.push(SWFObject_0);
			}
		}

		function clearPics()
		{
			for(var i:int = 0; i<allPics.length; i++)
			{
				thestage.removeChild(allPics[i]);
			}
			allPics = new Array();
		}

	}
}