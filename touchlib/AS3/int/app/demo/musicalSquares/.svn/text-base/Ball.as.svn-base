package app.demo.musicalSquares {
	
	import flash.display.Sprite;
	import flash.display.Graphics;
	import flash.display.LineScaleMode;
	import flash.display.*;
	import flash.geom.*
    import flash.filters.DropShadowFilter;
	
	public class Ball extends Sprite {
		
		public var radius:Number;
		private var color:uint;
		private var filterOn:Boolean;
		public var vx:Number = 0;
		public var vy:Number = 0;
		public var mass:Number = 1;
		public var dropShadow:DropShadowFilter = new DropShadowFilter(6, 45, 0x2F2F2F, 1, 2, 2, 1);		
		
		public function Ball(radius:Number=40, color:uint=0xff0000, filterOn:Boolean = false) {
			this.radius = radius;
			this.color = color;
			this.filterOn = filterOn
			init();
		}
		
		public function init():void {
			
		  var fillType:String = GradientType.LINEAR;
		  var colors:Array = [color, color];
		  var alphas:Array = [100, 20];
		  var ratios:Array = [0, 255];
		  var matr:Matrix = new Matrix();
		  matr.createGradientBox(5, 5, 0, 0, 0);
		  var spreadMethod:String = SpreadMethod.PAD;
		  graphics.beginGradientFill(fillType, colors, alphas, ratios, matr, spreadMethod);  
 
		  graphics.lineStyle(2, 0xFFFFFF, 1, false, LineScaleMode.NONE);
		  graphics.drawRect(-radius/2, -radius/2, radius, radius);			
		  graphics.endFill();		
		
		  if (filterOn == true){
			  filters = [dropShadow];
		  }
		  
		}		
	}	
}