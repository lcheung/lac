package app.demo.musicalSquares
{
	import flash.display.Sprite;
	import flash.display.Graphics;
	import flash.display.LineScaleMode;
	
	public class BallOutline extends Sprite {
		
		public var radius:Number;
		private var color:uint;
		public var vx:Number = 0;
		public var vy:Number = 0;
		public var mass:Number = 1;
		
		public function BallOutline(radius:Number=15, color:uint=0xff0000) {
			this.radius = radius;
			this.color = color;
			init();
		}
		
		public function init():void {
			graphics.lineStyle(2, 0xFFFFFF, 1, false, LineScaleMode.NONE);
			graphics.drawRect(-radius/2, -radius/2, radius, radius);			

		}
	}
}