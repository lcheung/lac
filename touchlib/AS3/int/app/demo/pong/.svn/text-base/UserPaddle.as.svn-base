package app.demo.pong
{	import flash.events.Event;
	import flash.events.MouseEvent;	
	import flash.events.TouchEvent;
	public class UserPaddle extends Paddle
	{
		function lockToMouse():void
		{
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveListener);
			this.stage.addEventListener(TouchEvent.MOUSE_MOVE, mouseMoveListener);
		}

		function unlockFromMouse():void
		{
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveListener);	
			this.stage.removeEventListener(TouchEvent.MOUSE_MOVE, mouseMoveListener);
		}

		function mouseMoveListener(event:Event)
		{
			requestMove(event.stageY-this.height/2);
		}
	}
}