package app.core.utl {
//-----------------------------------------------------------------------------------------------------------
	import flash.display.Sprite;
	import flash.events.Event;
//-----------------------------------------------------------------------------------------------------------
	public class Bling extends Sprite {
//-----------------------------------------------------------------------------------------------------------
		private var ag:AnimatingGradient;
//-----------------------------------------------------------------------------------------------------------
		public function Bling($width, $height, $color1, $color2)
		{
			this.ag = new AnimatingGradient($width, $height, Math.random()*0xffffff, Math.random()*0xffffff);	
			this.addChild(this.ag);
			this.ag.tweenGradient(Math.random()*0xffffff, Math.random()*0xffffff, 125);
			this.ag.addEventListener("finish", tweenAgain)			
		}
//-----------------------------------------------------------------------------------------------------------		
		private function tweenAgain(event:Event):void	{
			this.ag.tweenGradient(Math.random()*0xffffff, Math.random()*0xffffff, 65);
		}
//-----------------------------------------------------------------------------------------------------------END
	}
}
