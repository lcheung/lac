package app.demo.puzzle {
	
	import flash.display.*;
	import flash.events.*;
	
	import flash.events.TUIO;
	import app.demo.puzzle.*;		
	import app.core.action.RotatableScalable;
	
	public class PuzzleGameTile extends RotatableScalable {		
	
		// Items
		private var clickgrabber:Shape = new Shape();
		private var item:Sprite = new Sprite();	
				
		public function PuzzleGameTile() {											
			
			noScale = true;
			noRotate = true;		
			noSelection = true;	
			
			// Clickgrabber
			clickgrabber.scaleX = 1;
			clickgrabber.scaleY = 1;
			
			clickgrabber.graphics.beginFill(0xffffff, 0.1);
			clickgrabber.graphics.drawRect(0, 0, 1, 1);
			clickgrabber.graphics.endFill();						

			addChild(clickgrabber);			
		}		
	}
}
