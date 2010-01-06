
package app.demo.multiKey {

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.display.Graphics;
	import flash.geom.ColorTransform;
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import flash.geom.Matrix;
	import flash.events.*;
	import app.demo.multiKey.*;


	public class DrawSharpKey extends Sprite {
		
		var outlineSize:int = 5;


		public function DrawSharpKey() {

			drawSharpOutline();
			makeSharpKey();	
		}		
		
		
		private function drawSharpOutline() {

			var outline:Sprite = new Sprite();
			
			var outlineW:Number = -800/12;
			var outlineH:Number = 600/1.7;

			outline.graphics.lineStyle(outlineSize, //outline Size
									   0x000000,    //outline Color
									   1,		    //outline Alpha
									   false,       //outline PixelHinting
									   "null",      //outline capsStyle
									   "none",      //outline ScaleMode
									   "round",     //outline JointStyle 
									    255);       //outline MiterLimit				
			outline.graphics.moveTo(-outlineW/2, -outlineH/2);
			outline.graphics.lineTo(outlineW/2, -outlineH/2);
			outline.graphics.lineTo(outlineW/2, outlineH/2);
			outline.graphics.lineTo(-outlineW/2, outlineH/2);
			outline.graphics.lineTo(-outlineW/2, -outlineH/2);

			outline.x = outline.width/2;
			outline.y = outline.height/2;

			addChild(outline);
			addEventListener(TouchEvent.MOUSE_OUT, offKey);   // if Finger rolls off key, go to onSpriteRelease function
			addEventListener(TouchEvent.MOUSE_UP, offKey);  // if Finger rolls over key, go to onStartAudio function
			addEventListener(TouchEvent.MOUSE_OVER, onKey);   // if Finger rolls off key, go to onSpritePress function
			addEventListener(TouchEvent.MOUSE_DOWN, onKey);  // if Finger rolls over key, go to onStartAudio function
		
		}		
		
		
		private function makeSharpKey() {

			//Sets Gradient Propterties				
			
			var key:Sprite = new Sprite();
			key.name = "key"

			//Start the creation of the key graphic. Propterty changes based on natural or sharp
			key.graphics.lineStyle();
			key.graphics.moveTo(0, 0);
			key.graphics.beginFill(0x000000, 1);
			key.graphics.drawRect((-800/12)/2, //x 
								   -(600/2)/1.7,   //y
									800/12,    //width
								    600/1.7);    //height
			key.graphics.endFill();

			//set x and y location of new key	
			key.x = key.width/2 + outlineSize/2;
			key.y = key.height/2 + outlineSize/2;
			

			addChild(key);//add the Sprite key to the stage	

			addEventListener(TouchEvent.MOUSE_OUT, offKey);   // if Finger rolls off key, go to onSpriteRelease function
			addEventListener(TouchEvent.MOUSE_UP, offKey);  // if Finger rolls over key, go to onStartAudio function
			addEventListener(TouchEvent.MOUSE_OVER, onKey);   // if Finger rolls off key, go to onSpritePress function
			addEventListener(TouchEvent.MOUSE_DOWN, onKey);  // if Finger rolls over key, go to onStartAudio function
		}
		
		
		/////////////////////
		//                 //
		// Event Functions //
		//				   //
		/////////////////////
		
		
		public function onKey(event:TouchEvent) {

			if (event.target.name == "key") {

				//event.target.rotation = 180;

				var colorTransform:ColorTransform = transform.colorTransform;
				colorTransform.color = 0xFF4D4D;
				event.target.transform.colorTransform = colorTransform;  // highlight key when pressed

				//event.stopPropagation();
			}
		}
		
		
		public function offKey(event:TouchEvent) {

			if (event.target.name == "key") {

				//event.target.rotation = 0;

				var ranColor = Math.random() * 0xFFFFFF;
				var colorTransform2:ColorTransform = transform.colorTransform;
				colorTransform2.color = (0x000000);

				event.target.transform.colorTransform = colorTransform2;  //random color

				//event.stopPropagation();
			}
		}		
	}
}