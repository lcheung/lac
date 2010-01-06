package app.demo
{
	import flash.display.Sprite;
	import flash.events.TUIO;
	import app.core.canvas.PaintCanvas;

	public class Paint extends Sprite {

		private var naturalPaint:PaintCanvas;

		public function Paint() {
		trace("Paint Initialized");
		TUIO.init( this, 'localhost', 3000, '', true );
		var naturalPaint = new PaintCanvas();
		this.addChild(naturalPaint);
		}
	}
}