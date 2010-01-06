package app.demo.pong
{
	import flash.display.Sprite; 
	import flash.display.Graphics;	

	public class Ball extends Sprite
	{
	
		var vX:Number = 0;
		var vY:Number = 0;

		var bouncers:Array;
		
		public var ball:Sprite;
		
		var ballX:Number;
		var ballY:Number;
		
		var friction = .998;
		
		var particleArray:Array = new Array();

		 public function Ball(){
			 			

			ball = new Sprite();
			ball.graphics.beginFill(0x00FF3A,0.85);
			ball.graphics.drawCircle(0,0,10);
				
			this.addChild(ball);
			//var blurfx:BlurFilter = new BlurFilter(10, 10, 1);
			//this.filters = [blurfx];		 
				 
			 
		 }		 
		 
		function update():Number
		{
		
			//Create new particle
			circleParticle = new Sprite();
			circleParticle.graphics.beginFill(0x00FF3A,0.85);
			circleParticle.graphics.drawCircle(0,0,10);				
			parent.addChild(circleParticle);
			particleArray.push(circleParticle);
						
			circleParticle.x = ballX;
			circleParticle.y = ballY;			
			
			//Particle Code
			for (i = 0; i < particleArray.length; i++){
			
				var distance=Math.sqrt((Math.pow(circleParticle.alpha-0,2))+(Math.pow(circleParticle.alpha-0,2)))/5;
				
				var particle = particleArray[i];
				
				particle.alpha -= .1;
				particle.scaleX -=distance/4;
				particle.scaleY -=distance/4;
				
				//If particle alpha < .01 remove it
				if(particle.alpha<.01){
					
					particleArray.splice(particleArray.indexOf(particle),1);
					parent.removeChild(particle);
				}			
			}
		
			
			//Update based on velocity
			vX *= friction;
			vY *= friction;
			
			//Limit velocity
			if (vX > 20){ vX = 20;}
			if (vX < -20){ vX = -20;}
			if (vY > 20){ vY = 20;}
			if (vY < -20){ vY = -20;}
			
			//Set velocity/position of ball
			this.x += vX;
			this.y += vY;			
			ballX = this.x;
			ballY = this.y;
			
			//////////////////////////////
			//Edited to shorten the goal
			//bounce off sides
			
			var goalSize = 250;
			
			if (this.x < PongGame.playArea.x && this.y < PongGame.playArea.y + goalSize || this.x < PongGame.playArea.x && this.y > PongGame.playArea.y + goalSize*2)
			{	
				vX *= 1.5;
				vX = -vX;
				this.x += vX;
			}
			//bounce of sides
			if (this.x >= PongGame.playArea.x + PongGame.playArea.width && this.y < PongGame.playArea.y + goalSize || this.x >= PongGame.playArea.x + PongGame.playArea.width && this.y > PongGame.playArea.y + goalSize*2)
			{	
				vX *= 1.5;
				vX = -vX;
				this.x += vX;
			}			
			
			
			if (this.y >= PongGame.playArea.height || this.y <= 0 )
			{	
				vY *= 1.5;
				vY = -vY;
				this.x += vY;
			}		
			
			
			// Check if we've gone off the left side (P2 wins)
			if (this.x < PongGame.playArea.x && this.y > PongGame.playArea.y + goalSize && this.y < PongGame.playArea.y + goalSize*2)
			{
				return 1;
			}

			// Check if we've gone off the right side (P1 wins)
			if (this.x >= PongGame.playArea.x + PongGame.playArea.width && this.y > PongGame.playArea.y + goalSize && this.y < PongGame.playArea.y + goalSize*2)
			{
				return 0;
			}	
				
			return -1;
		}
	}
}