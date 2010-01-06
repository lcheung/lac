package app.demo.pong
{
	import flash.display.Sprite;  	
	public class RectangularMovieClip extends Sprite
	{
		function setDimensions(width:Number, height:Number, color)
		{
			this.graphics.beginFill(color, 1.0);
			this.graphics.drawRect(0, 0, width, height);
			this.graphics.endFill();
		}
	}
}