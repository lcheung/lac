package app.demo.musicalSquares
{
		import flash.display.Sprite;
		import flash.events.Event;
		import flash.events.MouseEvent;
		import flash.display.*;
		import flash.text.TextField;
		import flash.text.TextFormat;
		import flash.text.TextFieldAutoSize;
		import flash.text.*;
		import flash.geom.Point;
		import flash.events.*;
	
	
		public class Colliding extends Sprite {
	
			public var squares:Array;
			private var numSquares:Number = 16;
			private var hitloop:Number = 0;
			//Color of Square
			private var colorArray:Array = new Array(0xED1C24, 0xDC547C, 0xEC008C, 0x91278F, 0x5D53A3, 0x1B75BC, 0x00AEEF, 0x00A79D, 0x39B54A, 0xBFD73B, 0xF9ED33, 0xF7931E, 							 
													 
			0xEE2B30, 0xF0608E, 0xED2290, 0xA8489B, 0x726AB0, 0x418CCB, 0x43B4E7, 0x45C0BC, 0x6ABE56, 0xDFE343, 0xFCEF3E, 0xF89724,									 
													 0xFFFFFF, 0x595959, 0x000000);			
			
			
			//In case I want to attach the Note name to the Square
			private var letterArr:Array = new Array("C", "D", "E", "F", "G", "A", "B", "C2");
			//private var bounce:Number = -0.8;
			//private var spring:Number = .4;
			//private var friction:Number = 1;
			//private var gravity:Number = 0;
			//public var velX:Number;
			//public var velY:Number;	
	
			public function Colliding() {
	
				init();
			}
			
			private function init():void {
	
				squares = new Array();	

				//Create Squares (balls)
				for (var i:uint = 0; i < numSquares; i++) {
	
					var color = colorArray[i];
					var square:Throwing = new Throwing(25, color, true);
	
					square.x = (i * 40) + 95 ;
					square.y = 380 + (-i * 13);
					square.velX = 0;
					square.velY = 1;
					square.name = "ball" + i;
					square.getChildByName("throwBall").alpha = .15;

					addChild(square);
					squares.push(square);
				}
				
				newSquares();				
				addEventListener(Event.ENTER_FRAME, checkCollision, false, 0, true);
			}

			public function unload(e:Event)
			{
				trace("unloading..");
				removeEventListener(Event.ENTER_FRAME, checkCollision);
				for (var i:uint = 0; i < numSquares; i++) 
				{
					squares[i].unloadHandler(new Event(Event.UNLOAD));
				}
	
				// remove squares too?
			}

			private function newSquares(){				
				
			for (var j:uint = 0; j < 36; j++) {				
	
				var color = colorArray[j];
				var staticSquare:Ball = new Ball(20, color, false);

				if (j < 12){
					staticSquare.y = 90;
					staticSquare.x = 300 + (j * 21);
				}
				else if (j < 24){
					staticSquare.y = 70;
					staticSquare.x = 300 + ((j - 12) * 21);					
				}
				else{
					staticSquare.y = 50;
					staticSquare.x = 300 + ((j - 24) * 21);
				}
				
				staticSquare.name = "ball" + j;

				addChild(staticSquare);
				staticSquare.addEventListener(TouchEvent.MOUSE_DOWN, addSquare, false, 0, true);				
				}			
				
			for (var h:uint = 0; h < 36; h++) {				
	
				var color = colorArray[h];
				var staticSquare:Ball = new Ball(20, color, false);

				if (h < 12){
					staticSquare.y = 510;
					staticSquare.x = 530 - (h * 21);
				}
				else if (h < 24){
					staticSquare.y = 530;
					staticSquare.x = 530 - ((h - 12) * 21);					
				}
				else{
					staticSquare.y = 550;
					staticSquare.x = 530 - ((h - 24) * 21);	
				}				
				
				staticSquare.name = "ball" + h;

				addChild(staticSquare);
				staticSquare.addEventListener(TouchEvent.MOUSE_DOWN, addSquare, false, 0, true);				
				}				
			}
			

			/**********************************************************
			* When pressed, add new square
			***********************************************************/			
			private function addSquare(e:TouchEvent):void {
				
				switch (e.currentTarget.name) {								
				
				case "ball0" :					
					var color = colorArray[0];
					var square:Throwing = new Throwing(25, color, true);	
					square.name = e.currentTarget.name;
					break;				
				
				case "ball1" :			
					var color = colorArray[1];
					var square:Throwing = new Throwing(25, color, true);	
					square.name = e.currentTarget.name;
					break;	
					
				case "ball2" :			
					var color = colorArray[2];
					var square:Throwing = new Throwing(25, color, true);	
					square.name = e.currentTarget.name;
					break;	
					
				case "ball3" :			
					var color = colorArray[3];
					var square:Throwing = new Throwing(25, color, true);	
					square.name = e.currentTarget.name;
					break;
					
				case "ball4" :			
					var color = colorArray[4];
					var square:Throwing = new Throwing(25, color, true);	
					square.name = e.currentTarget.name;
					break;	
					
				case "ball5" :			
					var color = colorArray[5];
					var square:Throwing = new Throwing(25, color, true);	
					square.name = e.currentTarget.name;
					break;	
					
				case "ball6" :			
					var color = colorArray[6];
					var square:Throwing = new Throwing(25, color, true);	
					square.name = e.currentTarget.name;
					break;
					
				case "ball7" :			
					var color = colorArray[7];
					var square:Throwing = new Throwing(25, color, true);	
					square.name = e.currentTarget.name;
					break;
					
				case "ball8" :					
					var color = colorArray[8];
					var square:Throwing = new Throwing(25, color, true);	
					square.name = e.currentTarget.name;
					break;				
				
				case "ball9" :			
					var color = colorArray[9];
					var square:Throwing = new Throwing(25, color, true);	
					square.name = e.currentTarget.name;
					break;	
					
				case "ball10" :			
					var color = colorArray[10];
					var square:Throwing = new Throwing(25, color, true);	
					square.name = e.currentTarget.name;
					break;	
					
				case "ball11" :			
					var color = colorArray[11];
					var square:Throwing = new Throwing(25, color, true);	
					square.name = e.currentTarget.name;
					break;
					
				case "ball12" :			
					var color = colorArray[12];
					var square:Throwing = new Throwing(25, color, true);	
					square.name = e.currentTarget.name;
					break;	
					
				case "ball13" :			
					var color = colorArray[13];
					var square:Throwing = new Throwing(25, color, true);	
					square.name = e.currentTarget.name;
					break;	
					
				case "ball14" :			
					var color = colorArray[14];
					var square:Throwing = new Throwing(25, color, true);	
					square.name = e.currentTarget.name;
					break;
					
				case "ball15" :			
					var color = colorArray[15];
					var square:Throwing = new Throwing(25, color, true);	
					square.name = e.currentTarget.name;
					break;					
					
					
				case "ball16" :					
					var color = colorArray[16];
					var square:Throwing = new Throwing(25, color, true);	
					square.name = e.currentTarget.name;
					break;				
				
				case "ball17" :			
					var color = colorArray[17];
					var square:Throwing = new Throwing(25, color, true);	
					square.name = e.currentTarget.name;
					break;	
					
				case "ball18" :			
					var color = colorArray[18];
					var square:Throwing = new Throwing(25, color, true);	
					square.name = e.currentTarget.name;
					break;	
					
				case "ball19" :			
					var color = colorArray[19];
					var square:Throwing = new Throwing(25, color, true);	
					square.name = e.currentTarget.name;
					break;
					
				case "ball20" :			
					var color = colorArray[20];
					var square:Throwing = new Throwing(25, color, true);	
					square.name = e.currentTarget.name;
					break;	
					
				case "ball21" :			
					var color = colorArray[21];
					var square:Throwing = new Throwing(25, color, true);	
					square.name = e.currentTarget.name;
					break;	
					
				case "ball22" :			
					var color = colorArray[22];
					var square:Throwing = new Throwing(25, color, true);	
					square.name = e.currentTarget.name;
					break;
					
				case "ball23" :			
					var color = colorArray[23];
					var square:Throwing = new Throwing(25, color, true);	
					square.name = e.currentTarget.name;
					break;
					
				case "ball24" :					
					var color = colorArray[24];
					var square:Throwing = new Throwing(25, color, true);	
					square.name = e.currentTarget.name;
					break;				
				
				case "ball25" :			
					var color = colorArray[25];
					var square:Throwing = new Throwing(25, color, true);	
					square.name = e.currentTarget.name;
					break;	
					
				case "ball126" :			
					var color = colorArray[26];
					var square:Throwing = new Throwing(25, color, true);	
					square.name = e.currentTarget.name;
					break;	
					
				case "ball127" :			
					var color = colorArray[27];
					var square:Throwing = new Throwing(25, color, true);	
					square.name = e.currentTarget.name;
					break;
					
				case "ball28" :			
					var color = colorArray[28];
					var square:Throwing = new Throwing(25, color, true);	
					square.name = e.currentTarget.name;
					break;	
					
				case "ball29" :			
					var color = colorArray[29];
					var square:Throwing = new Throwing(25, color, true);	
					square.name = e.currentTarget.name;
					break;	
					
				case "ball30" :			
					var color = colorArray[30];
					var square:Throwing = new Throwing(25, color, true);	
					square.name = e.currentTarget.name;
					break;
					
				case "ball31" :			
					var color = colorArray[31];
					var square:Throwing = new Throwing(25, color, true);	
					square.name = e.currentTarget.name;
					break;					
					
				case "ball32" :			
					var color = colorArray[32];
					var square:Throwing = new Throwing(25, color, true);	
					square.name = e.currentTarget.name;
					break;	
					
				case "ball33" :			
					var color = colorArray[33];
					var square:Throwing = new Throwing(25, color, true);	
					square.name = e.currentTarget.name;
					break;	
					
				case "ball34" :			
					var color = colorArray[34];
					var square:Throwing = new Throwing(25, color, true);	
					square.name = e.currentTarget.name;
					break;
					
				case "ball35" :			
					var color = colorArray[35];
					var square:Throwing = new Throwing(25, color, true);	
					square.name = e.currentTarget.name;
					break;
			
			}			
				var tuioobj:TUIOObject = TUIO.getObjectById(e.ID);
				var localPt:Point = globalToLocal(new Point(tuioobj.x, tuioobj.y));
				
				square.x = localPt.x;
			    square.y = localPt.y;	
			
				addChild(square);
				squares.push(square);	
				
				square.state = "dragging";				
				square.dispatchEvent(new TouchEvent (TouchEvent.MOUSE_DOWN, false, false, tuioobj.x, tuioobj.y, localPt.x, localPt.y, 0, 0, null, false, false, false, false, 0, "2Dcur", e.ID, e.sID, e.angle));
			}

		
			
			private function checkCollision(event:Event):void {
	
				var square0:Throwing;
				var square1:Throwing;
				var j:uint;
				var i:uint = 0;
								
								
				if (squares.length < 1){
					var n:uint = 1;				
			  	   }else
				   {var n:uint = squares.length - 1;				   
			       }				
	
				for (; i < n; i++) {;
	
				square0 = squares[i];
				j = i + 1;
	
				for (; j < squares.length; j++) {
	
					square1 = squares[j];
	
					if (square0.hitTestObject(square1)) {
	
						//Play sound
						Sounds.sound(square0);
						Sounds.sound2(square1);
	
						//Change alpha
						square1.doTween(square0);
						square0.doTween(square1);
	
						//Reaction Code
						var firstVelX:Number = square0.velX;
						var firstVelY:Number = square0.velY;
						square0.velX = square1.velX;
						square0.velY = square1.velY;
						square1.velX = firstVelX;
						square1.velY = firstVelY;
	
						square0.hitloop = 0;
	
						//This part ensures the balls separate from eachother. Better way?
						while (square0.hitTestObject(square1)) {
	
							if (square0.hitloop >= 1) {
								square0.x = square0.x + 1 * (square0.velX - firstVelX) * .5;
								square0.y = square0.y + 1 * (square0.velY - firstVelY) * .5;
							}
							square0.hitloop++;
	
							if (square0.hitloop >= 80) {
								square0.x = square0.x + 15;
								square1.x = square1.x - 15;
							}
						}
					}
				}
			}
			for (i = 0; i < squares.length; i++) {
				var square:Throwing = squares[i];		
				move(square);
			}			
		}
		
		private function move(square:Throwing):void {
	
				 if (square.thisState == "release"){				
				  
					var index = squares.indexOf(square);					
					
					squares.splice(index, 1);	
					//null position in array and delete it
					squares.splice(index, 0);
					//remove eventlistener
					square.removeEventListener(Event.ENTER_FRAME, checkCollision);
					//kill ball
					removeChild(square);					
					//remove All children whithin ball
					while (square.numChildren > 0) {
					       square.removeChildAt(0);
						   
				}
			}
		}
	} 
}