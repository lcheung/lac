//////////////////////////////////////////////////////////////////////
//                                                                  //
//    Main Document Class. Sets TUIO and adds main parts to stage   //
////
//////////////////////////////////////////////////////////////////////

package app.demo{
	import flash.display.Sprite;
	
	import flash.events.TUIO;
	import app.core.canvas.TraceCanvas;

	public class Trace extends Sprite {

	public function Trace() {
		trace("Debug Initialized");
		TUIO.init( this, 'localhost', 3000, '', true );
		var naturalTrace = new TraceCanvas();
		this.addChild(naturalTrace);
	}
  }
}