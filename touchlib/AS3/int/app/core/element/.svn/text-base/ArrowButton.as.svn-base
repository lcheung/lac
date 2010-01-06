package app.core.element
{
	
	import flash.display.*;		
	import flash.events.*;
	import flash.net.*;
	import flash.events.*;	
	import flash.geom.*;			
    import flash.filters.*;
	import flash.text.*;


	public class ArrowButton extends Sprite
	{
		private var arrowGraphic:Sprite;
		private var buttonBackGraphic:Sprite;
		
		public function ArrowButton(dir:String = "right")
		{
			arrowGraphic = new Sprite();
			arrowGraphic.graphics.beginFill(0x363636, 1.0);
			arrowGraphic.graphics.moveTo(-15, -15);
			arrowGraphic.graphics.lineTo(15, 0);			
			arrowGraphic.graphics.lineTo(-15, 15);
			arrowGraphic.graphics.lineTo(-15, -15);			
			arrowGraphic.graphics.endFill();
			arrowGraphic.alpha = 0.5;
			arrowGraphic.x = 25;
			arrowGraphic.y = 25			
	
			
			buttonBackGraphic = new Sprite();
			buttonBackGraphic.graphics.beginFill(0xFFFFFF, 0.7);
			buttonBackGraphic.graphics.drawRoundRect(-25,-25,50,50, 10, 10);
			buttonBackGraphic.graphics.endFill();
			buttonBackGraphic.x = 25;
			buttonBackGraphic.y = 25;			
			
			addChild(buttonBackGraphic);
			addChild(arrowGraphic);
			
			setDirection(dir);
			
			this.addEventListener(TouchEvent.MOUSE_DOWN, this.downHandler, false, 0, true);						
			this.addEventListener(TouchEvent.MOUSE_UP, this.upHandler, false, 0, true);									
			this.addEventListener(TouchEvent.MOUSE_OVER, this.rollOverHandler, false, 0, true);									
			this.addEventListener(TouchEvent.MOUSE_OUT, this.rollOutHandler, false, 0, true);

			this.addEventListener(MouseEvent.MOUSE_DOWN, this.downHandler, false, 0, true);															
			this.addEventListener(MouseEvent.MOUSE_UP, this.upHandler, false, 0, true);	
			this.addEventListener(MouseEvent.ROLL_OVER, this.rollOverHandler, false, 0, true);
			this.addEventListener(MouseEvent.ROLL_OUT, this.rollOutHandler, false, 0, true);
			
		}
		
		public function setDirection(dir:String):void
		{
			if(dir == "right")
				arrowGraphic.rotation = 0;
			if(dir == "left")
				arrowGraphic.rotation = 180;				
			if(dir == "down")
				arrowGraphic.rotation = 90;								
			if(dir == "up")
				arrowGraphic.rotation = -90;												
		}
		
		public function downHandler(e:Event)
		{
		}
		
		public function upHandler(e:Event)
		{
			if(e.type == TouchEvent.MOUSE_UP)
				dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}		
		
		public function rollOverHandler(e:Event)
		{
			arrowGraphic.alpha = 1.0;
		}
		public function rollOutHandler(e:Event)
		{
			arrowGraphic.alpha = 0.5;			
		}
		
	}
}