package app.demo.pong
{
	public class Paddle extends RectangularMovieClip implements Bouncer
	{
		static var topBound:Number;
		static var bottomBound:Number;
		
		private static var maxBounceVYSkew:Number = 15;
		
		function requestMove(y:Number):void
		{
			this.y = Math.max(Paddle.topBound, Math.min(Paddle.bottomBound, y));
		}
		

		public function bounce(ball:Ball):void
		{
			ball.vX = -ball.vX;
			ball.x += ball.vX;
			
			var hitPos:Number = ball.y - (this.y+(this.height/2)-ball.height);
			var percentFromCenter:Number = hitPos/this.height/2;
			var vyAdjust:Number = percentFromCenter * Paddle.maxBounceVYSkew;
			ball.vY += vyAdjust
		}
	}
}