package app.demo.pong
{
	public class AIPaddle extends Paddle
	{
		var ball:Ball;
		private var maxSpeed:Number = 9;
		function update():void
		{
			var hitSpot:Number = Math.random() % this.height;
			var ballMiddle:Number = ball.y + (ball.height/2);
			var ballDelta:Number = this.y + hitSpot - ballMiddle;
			var moveAmount:Number = Math.min(Math.abs(ballDelta), this.maxSpeed);
			if (ballDelta < 0)
			{
				requestMove(this.y + moveAmount);
			}
			else
			{
				requestMove(this.y - moveAmount);
			}
		}
	}
}