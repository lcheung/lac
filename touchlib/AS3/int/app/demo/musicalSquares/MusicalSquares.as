package app.demo.musicalSquares 
{
	import flash.display.Sprite;
	import flash.events.*;
	import flash.events.*;
	import app.demo.musicalSquares.*;


	public class MusicalSquares extends Sprite {

		private var collider:Colliding;
		private var musicCanvas:MusicCanvas;
		private var collidingCanvas:CollidingCanvas;
		
		public function MusicalSquares() {

			TUIO.init( this, 'localhost', 3000, '', true );

			collidingCanvas = new CollidingCanvas();
			collidingCanvas.x = collidingCanvas.width/2;
			collidingCanvas.y = collidingCanvas.height/2;
			
			//collider = new Colliding();
			
			var musicCanvas = new MusicCanvas();
			this.addChild(musicCanvas);
			musicCanvas.addChild(collidingCanvas);
			//musicCanvas.addChild(collider);
			
			musicCanvas.x = 0;
			musicCanvas.y = 0;		
			musicCanvas.scaleX = .9;
			musicCanvas.scaleY = .9;		
			
			//addEventListener(Event.UNLOAD, collider.unload, false, 0, true);
			//this.setChildIndex(collider, this.numChildren-1);
		}		
		
		function unloadHandler(e:Event)
		{
			trace("UNLOAD event");
			
			//collider(unload);
		}	
	}
}