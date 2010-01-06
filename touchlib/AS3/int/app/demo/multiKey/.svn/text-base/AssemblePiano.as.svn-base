
package app.demo.multiKey {
	
	import flash.display.Sprite;
	import flash.media.Sound;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.events.*;
	import app.demo.multiKey.*;

	public class AssemblePiano extends Sprite {
		
		public var noSound:Boolean;

	
		var C1key = new Sound(new URLRequest("www/mp3/C1.mp3"));
		var D1key = new Sound(new URLRequest("www/mp3/D1.mp3"));
		var E1key = new Sound(new URLRequest("www/mp3/E1.mp3"));
		var F1key = new Sound(new URLRequest("www/mp3/F1.mp3"));
		var G1key = new Sound(new URLRequest("www/mp3/G1.mp3"));
		var A1key = new Sound(new URLRequest("www/mp3/A1.mp3"));
		var B1key = new Sound(new URLRequest("www/mp3/B1.mp3"));
		var C2key = new Sound(new URLRequest("www/mp3/C2.mp3"));	
		var D2key = new Sound(new URLRequest("www/mp3/D2.mp3"));
		var E2key = new Sound(new URLRequest("www/mp3/E2.mp3"));
		var F2key = new Sound(new URLRequest("www/mp3/F2.mp3"));
		var G2key = new Sound(new URLRequest("www/mp3/G2.mp3"));
		var A2key = new Sound(new URLRequest("www/mp3/A2.mp3"));
		var B2key = new Sound(new URLRequest("www/mp3/B2.mp3"));
		var C3key = new Sound(new URLRequest("www/mp3/C3.mp3"));			
		var Cs1key = new Sound(new URLRequest("www/mp3/Cs1.mp3"));
		var Ds1key = new Sound(new URLRequest("www/mp3/Ds1.mp3"));
		var Fs1key = new Sound(new URLRequest("www/mp3/Fs1.mp3"));
		var Gs1key = new Sound(new URLRequest("www/mp3/Gs1.mp3"));
		var As1key = new Sound(new URLRequest("www/mp3/As1.mp3"));		
		var Cs2key = new Sound(new URLRequest("www/mp3/Cs2.mp3"));
		var Ds2key = new Sound(new URLRequest("www/mp3/Ds2.mp3"));
		var Fs2key = new Sound(new URLRequest("www/mp3/Fs2.mp3"));
		var Gs2key = new Sound(new URLRequest("www/mp3/Gs2.mp3"));
		var As2key = new Sound(new URLRequest("www/mp3/As2.mp3"));
		
		var sndTransform:SoundTransform = new SoundTransform();			

		private var numNaturalKeys = 1;
		private var numSharpKeys = 1;

		
		
		public function AssemblePiano(octaves:int) {
			
			if (octaves == 1) {
				numNaturalKeys = 8;
				numSharpKeys   = 5;
			}
			if (octaves == 2) {
				numNaturalKeys = 15;
				numSharpKeys   = 10;
			}

			combineKeys(numNaturalKeys, numSharpKeys);			
		}		
		
		
		private function combineKeys(numNaturalKeys:int, numSharpKeys:int) {

			for (var i = 0; i < numNaturalKeys; i++) {

				var subobj = new AddKey("natural");
				subobj.name = "natural_" + i;
				addChild(subobj);
				
				//trace(subobj.name);
				
				subobj.x = ((subobj.width) * i) + subobj.width/2 ;
				subobj.y = subobj.height/2;
				
				subobj.addEventListener(TouchEvent.MOUSE_OVER, onStartAudio);  // if Finger rolls over key, go to onStartAudio function
				subobj.addEventListener(TouchEvent.MOUSE_DOWN, onStartAudio);  // if Finger rolls over key, go to onStartAudio function
			}
			
			for (var j = 0; j < numSharpKeys; j++) {

				var subobj = new AddKey("sharp");				  
				subobj.name = "sharp_" + j; 				
				addChild(subobj);
				
				//trace(subobj.name);
				
				subobj.x = (subobj.width + 33) * (j + 1);
				subobj.y = subobj.height/2;

				if (j >= 2) {
					subobj.x = (subobj.width + 33) * (j + 2);
					subobj.y = subobj.height/2;
				}
				if (j >= 5) {
					subobj.x = (subobj.width + 33) * (j + 3);
					subobj.y = subobj.height/2;
				}
				if (j >= 7) {
					subobj.x = (subobj.width + 33) * (j + 4);
					subobj.y = subobj.height/2;
				}
				if (j >= 10) {
					subobj.x = (subobj.width + 33) * (j + 5);
					subobj.y = subobj.height/2;
				}
				
				subobj.addEventListener(TouchEvent.MOUSE_OVER, onStartAudio);  // if Finger rolls over key, go to onStartAudio function
				subobj.addEventListener(TouchEvent.MOUSE_DOWN, onStartAudio);  // if Finger rolls over key, go to onStartAudio function
			}
		}		
		
		
		
		public function onStartAudio(event:TouchEvent):void {
			
			
			
	        var keyvolume:Number = (event.localY/event.target.height);	//Volume = Key pressed location/ height of key	
            if (keyvolume >= .50) {keyvolume = .50};
			
			//trace("this is" + " " + event.currentTarget.name);
			
			if(!noSound){

			switch (event.currentTarget.name) {								
				
				case "natural_0" :
                    sndTransform.volume = keyvolume;
                    C1key.play(0, 0, sndTransform);
					break;
				case "natural_1" :
		            sndTransform.volume = keyvolume;
                    D1key.play(0, 0, sndTransform);
					break;
				case "natural_2" :
		            sndTransform.volume = keyvolume;
                    E1key.play(0, 0, sndTransform);
					break;
				case "natural_3" :
		            sndTransform.volume = keyvolume;
                    F1key.play(0, 0, sndTransform);
					break;		
				case "natural_4" :
		            sndTransform.volume = keyvolume;
                    G1key.play(0, 0, sndTransform);
					break;
				case "natural_5" :
		            sndTransform.volume = keyvolume;
                    A1key.play(0, 0, sndTransform);
					break;
				case "natural_6" :
		            sndTransform.volume = keyvolume;
                    B1key.play(0, 0, sndTransform);
					break;
				case "natural_7" :
		            sndTransform.volume = keyvolume;
                    C2key.play(0, 0, sndTransform);
					break;
				case "natural_8" :
		            sndTransform.volume = keyvolume;
                    D2key.play(0, 0, sndTransform);
					break;
				case "natural_9" :
		            sndTransform.volume = keyvolume;
                    E2key.play(0, 0, sndTransform);
					break;
				case "natural_10" :
		            sndTransform.volume = keyvolume;
                    F2key.play(0, 0, sndTransform);
					break;		
				case "natural_11" :
		            sndTransform.volume = keyvolume;
                    G2key.play(0, 0, sndTransform);
					break;
				case "natural_12" :
		            sndTransform.volume = keyvolume;
                    A2key.play(0, 0, sndTransform);
					break;
				case "natural_13" :
		            sndTransform.volume = keyvolume;
                    B2key.play(0, 0, sndTransform);
					break;
				case "natural_14" :
		            sndTransform.volume = keyvolume;
                    C3key.play(0, 0, sndTransform);
					break;					
					
					
			   //Sharps
					
				case "sharp_0" :
		            sndTransform.volume = keyvolume;
                    Cs1key.play(0, 0, sndTransform);
					break;
				case "sharp_1" :
		            sndTransform.volume = keyvolume;
                    Ds1key.play(0, 0, sndTransform);
					break;
				case "sharp_2" :
		            sndTransform.volume = keyvolume;
                    Fs1key.play(0, 0, sndTransform);
					break;
				case "sharp_3" :
		            sndTransform.volume = keyvolume;
                    Gs2key.play(0, 0, sndTransform);
					break;
				case "sharp_4" :
		            sndTransform.volume = keyvolume;
                    As1key.play(0, 0, sndTransform);
					break;					
				case "sharp_5" :
		            sndTransform.volume = keyvolume;
                    Cs2key.play(0, 0, sndTransform);
					break;
				case "sharp_6" :
		            sndTransform.volume = keyvolume;
                    Ds2key.play(0, 0, sndTransform);
					break;
				case "sharp_7" :
		            sndTransform.volume = keyvolume;
                    Fs2key.play(0, 0, sndTransform);
					break;
				case "sharp_8" :
		            sndTransform.volume = keyvolume;
                    Gs2key.play(0, 0, sndTransform);
					break;
				case "sharp_9" :
		            sndTransform.volume = keyvolume;
                    As2key.play(0, 0, sndTransform);
					break;
			}
			}
		}		
	}
}