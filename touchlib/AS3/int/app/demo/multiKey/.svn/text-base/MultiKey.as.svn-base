//////////////////////////////////////////////////////////////////////
//                                                                  //
//    Main Document Class. Sets TUIO and adds main parts to stage   //
////
//////////////////////////////////////////////////////////////////////

package app.demo.multiKey {

	import flash.display.Sprite;
	import flash.system.Capabilities;
	import flash.events.*;
	import app.demo.multiKey.*;
	import app.demo.musicalSquares.*;
	
	public class MultiKey extends Sprite {
		
		private var octaves1 = 1;   //how many octaves on first keyboard
		private var octaves2 = 2;   //how many octaves on second keyboard
		//private var octaves3 = 1; //how many octaves on third keyboard
		//private var octaves4 = 2; //how many octaves on fourth keyboard
		private var multiCanvas:MultiCanvas;

		public function MultiKey() {

			TUIO.init( this, 'localhost', 3000, '', true );

			//var mainClip:Sprite = new Sprite();	
			//this.addChild(mainClip);
			multiCanvas = new MultiCanvas();
			//multiCanvas.x = multiCanvas.width/2;
			//multiCanvas.y = multiCanvas.height/2;
		
						
			//first keyboard							
			var fullPiano = new AddPiano(octaves1);
			//addChild(fullPiano);			
			fullPiano.x = fullPiano.width/2.3;
			fullPiano.y = fullPiano.height/3;			
			fullPiano.scaleX = .22;
			fullPiano.scaleY = .22;
			fullPiano.rotation = 60;				
			
			//second keyboard	
			var fullPiano2 = new AddPiano(octaves2);
			//addChild(fullPiano2);			
			
			if (octaves2 == 1) {
				fullPiano2.scaleX = .22;
				fullPiano2.scaleY = .22;
				fullPiano2.x = fullPiano2.width/1.6;
				fullPiano2.y = fullPiano2.height/1.5;			
			}			
			if (octaves2 == 2){
				fullPiano2.x = fullPiano2.width/4;
				fullPiano2.y = fullPiano2.height/1.5;			
				fullPiano2.scaleX = .22;
				fullPiano2.scaleY = .22;
			}

			this.addChild(multiCanvas);
			multiCanvas.addChild(fullPiano2);
			multiCanvas.addChild(fullPiano);
			
			multiCanvas.x = 0;
			multiCanvas.y = 0;		
			multiCanvas.scaleX = .9;
			multiCanvas.scaleY = .9;			
		}
	}
}