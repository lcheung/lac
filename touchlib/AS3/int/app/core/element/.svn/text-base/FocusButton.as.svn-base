package app.core.element{	
	import flash.text.*;	
	import flash.display.Sprite;
	import caurina.transitions.Tweener;	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	
	public class FocusButton extends Sprite{		
		var closeButton:Sprite = new Sprite();				
		public function FocusButton(){	
		closeButton.graphics.beginFill(0xFFFFFF,0.0);	
	   	closeButton.graphics.drawRoundRect(-50, -50, 100,100,10);	
		closeButton.graphics.beginFill(0xFFFFFF, 0.35);	
	   	closeButton.graphics.drawRoundRect(-25, -25, 50,50,10);		
	   	closeButton.graphics.endFill();	
	   	closeButton.graphics.lineStyle( 4, 0x000000 );	   	
		closeButton.graphics.moveTo( 0, -12 );
		closeButton.graphics.lineTo( 0, 12 );
		closeButton.graphics.moveTo( -12, 0 );
		closeButton.graphics.lineTo( 12, 0 );	 	
	 	//closeButton.x=Main.m_stage.stageWidth-50; 
		//closeButton.y=50;  		
		closeButton.addEventListener(MouseEvent.MOUSE_OVER, handleMouseOver);	
		closeButton.addEventListener(TouchEvent.MOUSE_OVER, handleMouseOver);		
		this.addChild(closeButton);	
		}
		public function handleMouseOver(e:Event){
		Tweener.addTween(closeButton, {alpha: 2, scaleX: 1.3, scaleY: 1.3, delay:0,time:0.5, transition:"easeinoutquad"});
		closeButton.removeEventListener(MouseEvent.MOUSE_OVER, handleMouseOver);	
		closeButton.removeEventListener(TouchEvent.MOUSE_OVER, handleMouseOver);	
		
		closeButton.addEventListener(MouseEvent.MOUSE_OUT, handleMouseOut);	
		closeButton.addEventListener(TouchEvent.MOUSE_OUT, handleMouseOut);	
		}
		public function handleMouseOut(e:Event){
		Tweener.addTween(closeButton, {alpha: 0.45, scaleX: 0.85, scaleY: 0.85, delay:0,time:0.5, transition:"easeinoutquad"});
		closeButton.removeEventListener(MouseEvent.MOUSE_OVER, handleMouseOut);	
		closeButton.removeEventListener(TouchEvent.MOUSE_OVER, handleMouseOut);
		
		closeButton.addEventListener(MouseEvent.MOUSE_OVER, handleMouseOver);	
		closeButton.addEventListener(TouchEvent.MOUSE_OVER, handleMouseOver);
		}
	}
}