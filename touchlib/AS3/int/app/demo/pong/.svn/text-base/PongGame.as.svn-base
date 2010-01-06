package app.demo.pong
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.*;
	import flash.geom.Rectangle;
	import flash.geom.Point;

	public class PongGame extends Sprite
	{
		static var playArea:Rectangle;
		private var gameOver:GameOver = new GameOver();
		private var scores:Score = new Score();
		
		//private var aiPaddle:AIPaddle = new AIPaddle();
		
		//private var userPaddle1:UserPaddle = new UserPaddle();		
		//private var userPaddle2:UserPaddle = new UserPaddle();
		
		private var ball:Ball = new Ball();		
		private var ballTrail = new BallFade();
		
		//private var finger1 = new Ball();	
		public var paddles1:LeftPaddle = new LeftPaddle();
		public var paddles2:RightPaddle = new RightPaddle();

		private var wallTop:Wall = new Wall();
		private var wallBottom:Wall = new Wall();
			
		private var net:Net = new Net();		
		
		private var n_stage:Stage;
		
		
		function PongGame(s:Stage)
		{	
			n_stage = s;
			TUIO.init( n_stage, 'localhost', 3000, '', true );	
			
			var wallHeight:Number = 10;
			
			PongGame.playArea = new Rectangle(
				0,
				wallHeight,
				n_stage.stageWidth,
				n_stage.stageHeight - wallHeight
			);
			
			// Setup the graphical elements on the n_stage
			//this.ball.setDimensions(20, 20);
			this.wallTop.setDimensions(n_stage.stageWidth, wallHeight, 0x000000);
			this.wallBottom.setDimensions(PongGame.playArea.width, wallHeight, 0x000000);
			//this.userPaddle1.setDimensions(20, 150, 0xFF0000);
			//this.userPaddle2.setDimensions(20, 150, 0x0000FF);
			//this.aiPaddle.setDimensions(15, 75);
			this.wallTop.y -= this.wallTop.height;
			this.wallBottom.y = n_stage.stageHeight;// - this.wallBottom.height;
			//this.scores.y = this.wallTop.y + this.wallTop.height;
			///this.userPaddle1.x = 18;
			////this.userPaddle1.y = 161.9;
			//this.userPaddle2.x = 1024-18-this.userPaddle2.width;
			//this.userPaddle2.y = 161.9;			
			
			// Add all the graphical elements to the n_stage
			addChild(this.scores);
			addChild(this.gameOver);
			//addChild(this.aiPaddle);
			addChild(this.ball);
			addChild(this.ballTrail);
			//addChild(this.userPaddle1);
			//addChild(this.userPaddle2);
			addChild(this.wallTop);
			addChild(this.wallBottom);
			
			addChild(this.paddles1);
			paddles1.x = 0;			
			addChild(this.paddles2);
			//paddles2.x = 512;	
			//paddles2.y = 0;
			
		//	addChild(this.ad);
		
			//addChild(this.net);

			// Bound the paddles top to the bottom of the top wall and bottom to the top of
			// the bottom wall
			//Paddle.topBound = this.wallTop.y + this.wallTop.height;
			//Paddle.bottomBound = this.wallBottom.y - this.wallBottom.height;
			
			//Paddle.bottomBound = this.wallBottom.y - this.userPaddle1.height;
			
			// Inform the AI paddle about the ball so it can try to hit it
			//this.aiPaddle.ball = this.ball;

			// Set up the ball to bounce off the paddles and walls
			this.ball.bouncers = [
				//this.userPaddle1,
				//this.userPaddle2,				
				//this.aiPaddle,
				this.wallTop,
				this.wallBottom
			];
			
			// Reset the game to initialize it
			reset(true);
			
			// Lock the player's paddle to the mouse to give them control
			//this.userPaddle1.lockToMouse();
			//this.userPaddle2.lockToMouse();
			
			// Update the game every time a frame is played
			addEventListener(Event.ENTER_FRAME, update);
			
			//addEventListener(TouchEvent.MOUSE_MOVE, moveEvent);
			//addEventListener(TouchEvent.MOUSE_DOWN, downEvent);
			//addEventListener(TouchEvent.MOUSE_UP, upEvent);		
		}
		
		
		public function downEvent(e:TouchEvent):void{}
		
		public function upEvent(e:TouchEvent):void{}
		
		public function moveEvent(e:TouchEvent):void{}
		
		
		private function reset(clearScores:Boolean):void
		{
			// Hide the game over
			this.gameOver.visible = false;

			// Set the ball's initial position to be the center of the n_stage
			this.ball.x = (n_stage.stageWidth - this.ball.width)/2;
			this.ball.y = (n_stage.stageHeight - this.ball.height)/2;
			
			// Serve the ball by giving it a random initial velocity
			this.ball.vX = (Math.random() % 2 == 0 ? 1 : -1) * 10;
			this.ball.vY = Math.random() * 5;
			
			// Reset the scores
			if (clearScores)
			{
				setGameScore(0, 0);
			}
		}
	
		/**
		 * End the game and wait for the user to restart it
		 * @param msg Message to display to the player while the game is over
		 */
		private function endGame(msg:String):void
		{
			// Show the requested message
			this.gameOver.setMessage(msg);
			this.gameOver.x = (n_stage.stageWidth - this.gameOver.width) / 2;
			this.gameOver.y = (n_stage.stageHeight - this.gameOver.height) / 2;
			this.gameOver.visible = true;
			
			// Stop allowing the player to control the paddle
			//this.userPaddle1.unlockFromMouse();
			
			// Stop the ball
			this.ball.vX = this.ball.vY = 0;
			
			// Listen for the user pressing the mouse. When they do, reset and play again
			n_stage.addEventListener(MouseEvent.CLICK, gameOverMouseListener);
			n_stage.addEventListener(TouchEvent.MOUSE_DOWN, gameOverMouseListener);
			
			// Wait for the user to press the mouse
			removeEventListener(Event.ENTER_FRAME, update);
		}
		
		/**
		 * Listen for mouse clicks on the game over screen
		 * @param event Mouse click event to respond to
		 */
		private function gameOverMouseListener(event:Event):void
		{
			// Reset the game and stop listening for the user to do so again
			reset(true);
			n_stage.removeEventListener(MouseEvent.CLICK, gameOverMouseListener);
			n_stage.removeEventListener(TouchEvent.MOUSE_DOWN, gameOverMouseListener);
			// Play the game again
			//this.userPaddle1.lockToMouse();
			addEventListener(Event.ENTER_FRAME, update);
		}
		
		/**
		 * Update the game
		 * @param event Event we are updating for
		 */
		private function update(event:Event):void
		{
			// Update the AI's paddle
			//this.aiPaddle.update();
			//ballTrail.x = ball.ballX - ball.vX*1;
			//ballTrail.y = ball.ballY - ball.vY*1;
			
		////////////////////////
		//Start collision code 
		   
		
		   
		//If hits 1st line	   
		if(HitTest.complexHitTestObject(paddles1.line1, ball, 1)){		
		
			angleBounce(paddles1.line1, paddles1.line1angle);
		
		}	
		
		//If hits 2nd line	
		if(HitTest.complexHitTestObject(paddles1.line2, ball, 1)){		
		
			angleBounce(paddles1.line2, paddles1.line2angle);

		}		
		
		//If hits 3rd line		
		if(HitTest.complexHitTestObject(paddles1.line3, ball, 1)){		
				
			angleBounce(paddles1.line3, paddles1.line3angle);
		
		}	

		//If hits 1st line	   
		if(HitTest.complexHitTestObject(paddles2.line1, ball, 1)){		
		
			trace("hit 2");
			
			angleBounce2(paddles2.line1, paddles2.line1angle);
		
		}	
		
		//If hits 2nd line	
		if(HitTest.complexHitTestObject(paddles2.line2, ball, 1)){		
		
			angleBounce2(paddles2.line2, paddles2.line2angle);

		}		
		
		//If hits 3rd line		
		if(HitTest.complexHitTestObject(paddles2.line3, ball, 1)){		
		
			angleBounce2(paddles2.line3, paddles2.line3angle);
		
		}	
		
		
		
			
			// Update the ball's movement and check for the game over condition
			var winnerIndex:Number = this.ball.update();
			switch (winnerIndex)
			{
				case 0:
				case 1:
					// Award a point to the player who scored it
					var oldScores:Array = this.scores.getScores();
					oldScores[winnerIndex]++;
					setGameScore(oldScores[0], oldScores[1]);
			
					// If the player who scored won, end the game
					var newScores:Array = this.scores.getScores();
					if (newScores[winnerIndex] == 5)
					{
						endGame(winnerIndex == 0 ? "Red Wins!" : "Blue Wins!");
					}
					// Otherwise, start a new round after a little bit
					else
					{
						reset(false);
					}
					break;
			}
			
			// If the game is not over, keep running the game by going to our own frame
			// to form the main loop
			//gotoAndPlay(1);
		}
		
		private function angleBounce2(lineNumber, lineAngle){
			
			trace("hit " + lineNumber);
			
			// get angle, sine, and cosine
			var angle = lineAngle;	
			var cos:Number = Math.cos(angle);
			var sin:Number = Math.sin(angle);		
			
			// get position of ball, relative to line
			var x1:Number = ball.x - lineNumber.x;
			var y1:Number = ball.y - lineNumber.y;		

			// rotate coordinates
			var y2:Number = cos * y1 - sin * x1;
			// rotate velocity
			var vy1:Number = cos * ball.vY - sin * ball.vX;			
			
			if(y2 > -ball.height / 2 && y2 < vy1)			
			{				
				trace("front side 2 " + y2 + " " + vy1);	
				
				// rotate coordinates
				var x2:Number = cos * x1 + sin * y1;
				// rotate velocity
				var vx1:Number = cos * ball.vX + sin * ball.vY;
				//var vy1:Number = cos * ball.vY - sin * ball.vX;
				
				y2 = -ball.height / 2;
				
				vy1 *= -1;
				// rotate everything back;
				x1 = cos * x2 - sin * y2;
				y1 = cos * y2 + sin * x2;
				ball.vX = cos * vx1 - sin * vy1;
				ball.vY = cos * vy1 + sin * vx1;
				
				ball.x = lineNumber.x + x1;
				ball.y = lineNumber.y + y1;					
			}
			
			if(y2 > -ball.height / 2 && y2 > vy1)
			
			{
				trace("opposite side 2 " + y2 + " " + vy1);	
				
				// rotate coordinates
				var x2:Number = cos * x1 + sin * y1;
				// rotate velocity
				var vx1:Number = cos * ball.vX + sin * ball.vY;
				//var vy1:Number = cos * ball.vY - sin * ball.vX;
				
				y2 = ball.height / 2;
				
				vy1 *= -1;
				// rotate everything back;
				x1 = cos * x2 - sin * y2;
				y1 = cos * y2 + sin * x2;
				ball.vX = cos * vx1 - sin * vy1;
				ball.vY = cos * vy1 + sin * vx1;
				
				ball.x = lineNumber.x + x1;
				ball.y = lineNumber.y + y1;
			}				
		}
		
		
		
		private function angleBounce(lineNumber, lineAngle){
			
			trace("hit " + lineNumber);
			
			// get angle, sine, and cosine
			var angle = lineAngle;	
			var cos:Number = Math.cos(angle);
			var sin:Number = Math.sin(angle);		
			
			// get position of ball, relative to line
			var x1:Number = ball.x - lineNumber.x;
			var y1:Number = ball.y - lineNumber.y;		

			// rotate coordinates
			var y2:Number = cos * y1 - sin * x1;
			// rotate velocity
			var vy1:Number = cos * ball.vY - sin * ball.vX;			
			
			if(y2 > -ball.height / 2 && y2 < vy1)
			
			{
				// rotate coordinates
				var x2:Number = cos * x1 + sin * y1;
				// rotate velocity
				var vx1:Number = cos * ball.vX + sin * ball.vY;
				//var vy1:Number = cos * ball.vY - sin * ball.vX;
				
				y2 = -ball.height / 2;
				
				vy1 *= -1;
				// rotate everything back;
				x1 = cos * x2 - sin * y2;
				y1 = cos * y2 + sin * x2;
				ball.vX = cos * vx1 - sin * vy1;
				ball.vY = cos * vy1 + sin * vx1;
				
				ball.x = paddles1.line1.x + x1;
				ball.y = paddles1.line1.y + y1;					
			}
			
			if(y2 > -ball.height / 2 && y2 > vy1)
			
			{
				trace("opposite side");	
				
				// rotate coordinates
				var x2:Number = cos * x1 + sin * y1;
				// rotate velocity
				var vx1:Number = cos * ball.vX + sin * ball.vY;
				//var vy1:Number = cos * ball.vY - sin * ball.vX;
				
				y2 = ball.height / 2;
				
				vy1 *= -1;
				// rotate everything back;
				x1 = cos * x2 - sin * y2;
				y1 = cos * y2 + sin * x2;
				ball.vX = cos * vx1 - sin * vy1;
				ball.vY = cos * vy1 + sin * vx1;
				
				ball.x = lineNumber.x + x1;
				ball.y = lineNumber.y + y1;
			}				
		}
		
		
		/**
		 * Set the score of the game and update the score display
		 * @param player The player's score
		 * @param ai The AI's score
		 */
		private function setGameScore(player:Number, ai:Number)
		{
			this.scores.setScore(player, ai);
			this.scores.x = (n_stage.stageWidth - this.scores.width) / 2;
		}
	}
}