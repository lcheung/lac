package app.demo.multiKey{

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.display.Graphics;
	import flash.geom.ColorTransform;
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import flash.geom.Matrix;
	import flash.events.*;
	import app.demo.multiKey.*;


	public class DrawNaturalKey extends Sprite {
		
		var outlineSize:int = 5;


		public function DrawNaturalKey() {

			drawOutline();
			makeKey();	
		}		
		
		
		private function drawOutline() {

			var outline:Sprite = new Sprite();
			
			var outlineW:Number = -800/8;
			var outlineH:Number = 600;

			outline.graphics.lineStyle(outlineSize, //outline Size
									   0x000000,    //outline Color
									   1,		    //outline Alpha
									   false,       //outline PixelHinting
									   "null",      //outline capsStyle
									   "none",      //outline ScaleMode
									   "miter",     //outline JointStyle 
									    255);       //outline MiterLimit	
			
			outline.graphics.moveTo(-outlineW/2, -outlineH/2);
			outline.graphics.lineTo(outlineW/2, -outlineH/2);
			outline.graphics.lineTo(outlineW/2, outlineH/2);
			outline.graphics.lineTo(-outlineW/2, outlineH/2);
			outline.graphics.lineTo(-outlineW/2, -outlineH/2);

			outline.x = outline.width/2;
			outline.y = outline.height/2;

			addChild(outline);
		}		
		
		
		private function makeKey() {

			var randomColor      = Math.random() * 0xffffff;//Creates random color for keys
			var fillType:String  = GradientType.LINEAR;//Set gradient to Linear
			var colors:Array     = [0x222222, 0xffffff, 0x222222];//Have gradient go from keycolor to random color
			var alphas:Array     = [1, 0, 1];//then make gradient change from transparent to keyAlpha
			var ratios:Array     = [0, 160, 200];//rate of gradient change
			var matr:Matrix      = new Matrix();
			matr.createGradientBox(1,                   //width 
								   350,                 //height
								   Math.PI/2,           //rotation
								   0,                   //ty
								   0);				    //tx

			var key:Sprite = new Sprite();
			key.name = "key"

			//Start the creation of the key graphic. Propterty changes based on natural or sharp
			key.graphics.lineStyle();
			key.graphics.moveTo(0, 0);
			key.graphics.beginGradientFill(fillType, colors, alphas, ratios, matr);
			key.graphics.drawRect((-800/8)/2, //x 
								   -600/2,   //y
									800/8,    //width
								    600);    //height
			key.graphics.endFill();

			//set x and y location of new key	
			key.x = key.width/2 + outlineSize/2;
			key.y = key.height/2 + outlineSize/2;
			key.alpha = .4;
			

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

				var colorTransform:ColorTransform = transform.colorTransform;
				colorTransform.color = 0xFF4D4D;
				event.target.transform.colorTransform = colorTransform; // highlight key when pressed
				
				event.target.alpha = 1;
			}
		}
		
		
		public function offKey(event:TouchEvent) {

			if (event.target.name == "key") {

				//var ranColor = Math.random() * 0xFFFFFF;
				var colorTransform2:ColorTransform = transform.colorTransform;
				colorTransform2.color = (0x222222);
				event.target.transform.colorTransform = colorTransform2;
				
				event.target.alpha = .4;
			}
		}		
	}
}