package app.core.loader {
	
	import app.core.object.ImageObject;
	import app.core.object.VideoObject;
	import flash.display.*;		
	import flash.events.*;
	import flash.net.*;
	//import flash.util.trace;		
	
	public class Local extends Sprite
	{
		// Class properties
		private var thestage:Sprite;
		private var allPics:Array;			
		private var _thisScaleDown:Boolean;	
		
		// Misc.
		private var LIcontainer:String;	// Images
		private var LVcontainer:String; // Videos
		
		public function Local(d:Sprite,thisScaleDown:Boolean) 
		{
			thestage = d;
			_thisScaleDown=thisScaleDown
			allPics = new Array();						
			clearPics();			
			
			// Load images
			LocalImageLoader();
			
			// Load videos
			LocalVideoLoader();
		}
													
		public function LocalImageLoader()
        {
            var request:URLRequest = new URLRequest("local/images.xml");
            var variables:URLLoader = new URLLoader();
            variables.dataFormat = URLLoaderDataFormat.TEXT;
            variables.addEventListener(Event.COMPLETE, LIcompleteHandler, false, 0, true);
            try
            {
                variables.load(request);
            } 
            catch (error:Error)
            {
                trace("Unable to load (images) file " + error);
            }
        }
		
        private function LIcompleteHandler(event:Event):void
        {
            var loader:URLLoader = URLLoader(event.target);
			LIcontainer = loader.data;
			showPics();	// Show pics when done loading textfile
        }													
													
		public function showPics()
		{
			var myArray:Array = new Array();
			myArray = LIcontainer.split("\r\n");
			for(var i:int=0; i<myArray.length; i++)
			{
				myArray[i] = "local/image/" + myArray[i];							
			}	

			for(i=0; i < myArray.length-1; i++)
			{
				var photo:ImageObject = new ImageObject( myArray[i] ,false, false, false,_thisScaleDown);				
				//photo.scaleX = 1.0;
				//photo.scaleY = 1.0;
				thestage.addChild(photo);
				allPics.push(photo);				
			}			
		}
										
		public function LocalVideoLoader()
        {
            var request:URLRequest = new URLRequest("local/videos.xml");
            var variables:URLLoader = new URLLoader();
            variables.dataFormat = URLLoaderDataFormat.TEXT;
            variables.addEventListener(Event.COMPLETE, LVcompleteHandler);
            try
            {
                variables.load(request);
            } 
            catch (error:Error)
            {
                trace("Unable to load (videos) file " + error);
            }
        }
		 
		private function LVcompleteHandler(event:Event):void
        {
            var loader:URLLoader = URLLoader(event.target);
			LVcontainer = loader.data;
			showVids();	// Show videos when done loading textfile
        }			
		
			public function showVids()
		{
			var myArray:Array = new Array();
			myArray = LVcontainer.split("\r\n");
			for(var i:int=0; i<myArray.length; i++)
			{
				myArray[i] = "local/video/" + myArray[i];
				//myArray[i] = "http://cache.googlevideo.com/get_video?video_id=0awjPUkBXOU&amp&origin=youtube.com";			
				
			}	

			for(i=0; i < myArray.length-1; i++)
			{	
				trace('Trying to load :'+(myArray[i]));
				var flv_video:VideoObject = new VideoObject( myArray[i] );				
				thestage.addChild(flv_video);
				allPics.push(flv_video);								
			}			
		}
		
		public function clearPics()
		{
			for(var i:int = 0; i<allPics.length; i++)
			{
				thestage.removeChild(allPics[i]);
			}
			
			allPics = new Array();
		}

	}
}