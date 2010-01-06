package app.core.element {	
	import com.nui.tuio.TouchEvent;
	import flash.events.Event;
	import flash.display.MovieClip;
	import com.tweener.transitions.Tweener;
	
	public dynamic class nButton extends MovieClip {
		public function nButton() {
			alpha = 1;			
			this.addEventListener(TouchEvent.DownEvent, this.downEvent);						
			this.addEventListener(TouchEvent.UpEvent, this.upEvent);									
			this.addEventListener(TouchEvent.RollOverEvent, this.rollOverHandler);									
			this.addEventListener(TouchEvent.RollOutEvent, this.rollOutHandler);	
			buttonMode = true;
			useHandCursor = true;
		}
		public function downEvent(e:TouchEvent)
		{
			trace("Button Down");
			Tweener.addTween(this, {rotation:360, time:0.3, transition:"linear"});		
			//Tweener.addTween(this, {_blur_blurX:50, _blur_quality:2, time:1, transition:"linear"});
		}
		public function upEvent(e:TouchEvent)
		{
			trace("Button Up");		

		}
		public function rollOverHandler(e:TouchEvent)
		{
			trace("Button Over");		
			Tweener.addTween(this, {alpha:0.2, time:0.5, transition:"easeinoutquad"});
		}
		public function rollOutHandler(e:TouchEvent)
		{
			trace("Button Out");
			Tweener.addTween(this, {alpha:1, time:1, transition:"easeinoutquad"});
		}		
	}
}
