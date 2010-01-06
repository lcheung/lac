package app.demo.piano
{

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.display.Graphics;
	import flash.geom.ColorTransform;
	import flash.media.Sound;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.display.GradientType;  
	import flash.display.SpreadMethod;  
	import flash.geom.Matrix;
	
	import flash.events.*;
	import app.demo.piano.*;	
	import app.core.action.RotatableScalable;

	public class CreatingKeyboard extends RotatableScalable {

		//------------- Define the Sounds ----------------------//

		var Ckey = new Sound(new URLRequest("www/mp3/C.mp3"));
		var Cskey = new Sound(new URLRequest("www/mp3/Cs.mp3"));
		var Dkey = new Sound(new URLRequest("www/mp3/D.mp3"));
		var Dskey = new Sound(new URLRequest("www/mp3/Ds.mp3"));
		var Ekey = new Sound(new URLRequest("www/mp3/E.mp3"));
		var Fkey = new Sound(new URLRequest("www/mp3/F.mp3"));
		var Fskey = new Sound(new URLRequest("www/mp3/Fs.mp3"));
		var Gkey = new Sound(new URLRequest("www/mp3/G.mp3"));
		var Gskey = new Sound(new URLRequest("www/mp3/Gs.mp3"));
		var Akey = new Sound(new URLRequest("www/mp3/A.mp3"));
		var Askey = new Sound(new URLRequest("www/mp3/As.mp3"));
		var Bkey = new Sound(new URLRequest("www/mp3/B.mp3"));
		var C2key = new Sound(new URLRequest("www/mp3/C2.mp3"));		
		
		var sndTransform:SoundTransform = new SoundTransform();		
		

		
		public function CreatingKeyboard(begin:Number, keyAlpha:Number, keyColor, gradAngle:Number, kWidth:Number, kHeight:Number, numKeys:Number, natural:Boolean, outline:Boolean) {

			
			bringToFront = false;			
			noScale = true;          //make it not scale
			noRotate = true;         //make it not rotate
			noMove = true;           //make it not move
			noSelection = true;	
			
			//This draws the border of the keyboard
			if (outline == true){
			
				var outlineBox:Sprite = new Sprite();
				addChild(outlineBox);
		
				outlineBox.graphics.lineStyle(20, 0x000000);
				outlineBox.graphics.moveTo(0, 0);
				outlineBox.graphics.drawRect(0, 0, kWidth, kHeight);
				outlineBox.graphics.endFill();	
				
				//outlineBox.addEventListener (TouchEvent.DownEvent, onMoveOn, false, 0, true);  // If on border, turn Scaling/Rotating On
			    //outlineBox.addEventListener(TouchEvent.UpEvent, onupEvent, false, 0, true);    // If not on border, turn Scaling/Rotating Off									
				
			}
			
			//------------- Create all the key graphics ----This needs to be changed so it draws all graphics together-----//

			for (var i:int = begin; i < numKeys; i++) {

				var key:Sprite = new Sprite();				
				if(natural == true){                           //If a natural key
				  key.name = "natural_" + i;  				   //then name it "natural_#"
				} else
				{ key.name = "sharp_" + i;}                    //else name it "sharp_#"
				
				
				var ranColor = Math.random() * keyColor;       //Creates random color for keys
								
				//Sets Gradient Propterties
				var fillType:String = GradientType.LINEAR;     //Set gradient to Linear
  				//var colors:Array = [keyColor, ranColor];       //Have gradient go from keycolor to random color
				var colors:Array = [0x222222, 0x222222]; 
				if(natural == true)                            //If a natural key
				{  var alphas:Array = [0, keyAlpha];           //then make gradient change from transparent to keyAlpha
				} else
				{  var alphas:Array = [keyAlpha, keyAlpha];}   //else make it change from keyAlpha to keyAlpha
				var ratios:Array = [0, 255];                   //rate of gradient change
                var matr:Matrix = new Matrix();		           
				matr.createGradientBox((kWidth/16), kHeight, gradAngle, 0, 0);		
				var spreadMethod:String = SpreadMethod.PAD;
				
				
				//Start the creation of the key graphic. Propterty changes based on natural or sharp
				key.graphics.lineStyle();                      
				key.graphics.moveTo(0, 0);
				key.graphics.beginGradientFill(fillType, colors, alphas, ratios, matr, spreadMethod);
				if(natural == true){				
				key.graphics.drawRect(0 , 0, (kWidth/8), kHeight); }
				else{key.graphics.drawRect(0 , 0, (kWidth/12), kHeight/1.7); }				
				key.graphics.endFill();
				
				//set x and y location of new key				
				if(natural == true){key.x = (kWidth/8) * i; key.y = 0;}
				else{key.x = (kWidth/8) * (i + .65); key.y = 0;}								
				
				addChild(key); //add the Sprite key to the stage
				
				key.addEventListener (TouchEvent.MOUSE_OVER, onStartAudio, false, 0, true);  // if Finger rolls over key, go to onStartAudio function
				key.addEventListener(TouchEvent.MOUSE_OUT, onKeyRelease, false, 0, true); // if Finger rolls off key, go to onSpriteRelease function
				key.addEventListener(TouchEvent.MOUSE_OVER, onKeyPress, false, 0, true);  // if Finger rolls off key, go to onSpritePress function
			}		
			
			
			
			//--------------------- Create black outlines for keys ----------------------//
			
			if (outline == true){ //only draw outline when outline == true
				
				for (var j:int = 0; j < 9; j++) {
	
					var outlineKeys:Sprite = new Sprite();
					addChild(outlineKeys);
	
					outlineKeys.graphics.lineStyle(4, 0x000000);
					outlineKeys.graphics.moveTo(0, 0);
					outlineKeys.graphics.drawRect((kWidth/8) * j , 0, 0, kHeight);
					outlineKeys.graphics.endFill();
				}	
			}			
		}		
		
				
				
				
	    //-----------------Event Functions-------------	//		
		
		private function onKeyPress(event:TouchEvent):void {
			
			//Flip gradient of natural keys when pressed
	        if (event.target.name.substr(0, 1) == "n" ) {
			      event.target.y = event.target.y + event.target.height;
			      event.target.x = event.target.x + event.target.width;
				  event.target.rotation = 180;
			}

            //Change Key Color to Red when pressed			
			var colorTransform:ColorTransform = transform.colorTransform;
			colorTransform.color = 0x333333;
			event.target.transform.colorTransform = colorTransform;// highlight key when pressed			
		}	
		
		
				
		
		
		
		private function onKeyRelease(event:TouchEvent):void {
			
         
		    //Flip gradient of natural keys back to original
            if (event.target.name.substr(0, 1) == "n" ){
				  event.target.y = event.target.y - event.target.height;
				  event.target.x = event.target.x - event.target.width;
				  event.target.rotation = 0;
			}
			
			//Change color of natural key. Change sharp key back to black
            var ranColor = 0xFFFFFF; 			
			//var ranColor = Math.random() * 0xFFFFFF; 			
			var colorTransform2:ColorTransform = transform.colorTransform;
			colorTransform2.color = (ranColor);
			colorTransform2.alphaMultiplier = .5;
			var sharpcolorTransform:ColorTransform = transform.colorTransform;
			sharpcolorTransform.color = 0x000000;
			
			if (event.target.name.substr(0, 1) == "n" ){
					event.target.transform.colorTransform = colorTransform2; //random color					
			}
			else {
				event.target.transform.colorTransform = sharpcolorTransform; //black color
			}		
		}
		
		
		
		
		
		
		private function onStartAudio(event:TouchEvent):void {
			
	        var keyvolume:Number = (event.localY/event.target.height);	//Volume = Key pressed location/ height of key	
            if (keyvolume >= .9) {keyvolume = .9};
			

			switch (event.target.name) {			
				
				case "natural_0" :
                    sndTransform.volume = keyvolume;
                    Ckey.play(0, 0, sndTransform);
					break;
				case "sharp_0" :
		            sndTransform.volume = keyvolume;
                    Cskey.play(0, 0, sndTransform);
					break;
				case "natural_1" :
		            sndTransform.volume = keyvolume;
                    Dkey.play(0, 0, sndTransform);
					break;
				case "sharp_1" :
		            sndTransform.volume = keyvolume;
                    Dskey.play(0, 0, sndTransform);
					break;
				case "natural_2" :
		            sndTransform.volume = keyvolume;
                    Ekey.play(0, 0, sndTransform);
					break;
				case "natural_3" :
		            sndTransform.volume = keyvolume;
                    Fkey.play(0, 0, sndTransform);
					break;
				case "sharp_3" :
		            sndTransform.volume = keyvolume;
                    Fskey.play(0, 0, sndTransform);
					break;
				case "natural_4" :
		            sndTransform.volume = keyvolume;
                    Gkey.play(0, 0, sndTransform);
					break;
				case "sharp_4" :
		            sndTransform.volume = keyvolume;
                    Gskey.play(0, 0, sndTransform);
					break;
				case "natural_5" :
		            sndTransform.volume = keyvolume;
                    Akey.play(0, 0, sndTransform);
					break;
				case "sharp_5" :
		            sndTransform.volume = keyvolume;
                    Askey.play(0, 0, sndTransform);
					break;
				case "natural_6" :
		            sndTransform.volume = keyvolume;
                    Bkey.play(0, 0, sndTransform);
					break;
				case "natural_7" :
		            sndTransform.volume = keyvolume;
                    C2key.play(0, 0, sndTransform);
					break;			
			}
		}
		
		
		//This one works
		private function onMoveOn(event:TouchEvent):void {
			
			trace("Scaling/Rotating ONNNNNNNNNNNN");
			
		/*	bringToFront = false;			
			noScale = false;
			noRotate = false;
			noMove = false;
		*/
		}
		
		
		//This one doesn't work. UpEvent doesn't work.
		public function onMoveUp(e:TouchEvent):void {
			
			trace("Scaling/Rotating OFFFFFFFFFFFF");
			
		/*	bringToFront = false;			
			noScale = true;
			noRotate = true;
			noMove = true;	
		*/
			
		}		
		
		

	}

}