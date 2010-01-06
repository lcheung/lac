package app.demo.pong
{
	public class Wall extends RectangularMovieClip implements Bouncer
	{
		/**
		 * Bounce a ball off of the wall.
		 * @param ball Ball to bounce
		 */
		public function bounce(ball:Ball):void
		{
			// Reverse Y direction and bounce
			ball.vY = -ball.vY;
			ball.y += ball.vY;
		}
	}
}