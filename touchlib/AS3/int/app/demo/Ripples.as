package app.demo
{
	import flash.display.Sprite;
	import flash.events.*;
	import app.core.canvas.RippleCanvas;
	
	public class Ripples extends Sprite {
		
		private var subobj:RippleCanvas;
		
		public function Ripples() {
		
		trace("Ripples Initialized");
		TUIO.init( this, 'localhost', 3000, '', true );
		var subobj = new RippleCanvas();
		this.addChild(subobj);

		}
	}
}