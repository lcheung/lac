// FIXME: animate tank tread spinning..

package app.demo.tank
{
	import flash.events.*;
	import app.demo.tank.*;
	import app.core.element.*;
	
	import flash.events.*;
	import flash.geom.*;
	import flash.display.*;	
	import flash.text.*;

	dynamic public class PlayerTank
	{
		private var leftTread:Slider;
		private var rightTread:Slider;
		private var upVec:Point;
		private var tankAngle:Number;
		private var mcMain:TankGame;
		private var facingVec:Point;		
		private var playerNum:Number;
		
		private var fireButton:SimpleButton;
		
		public var score:int;
		
		private var startX:Number;
		private var startY:Number;
		private var startAngle:Number;
		
		private var health:Number = 0.0;
		
		private var turretKnob:Knob;
		
		private var UIHolder:Sprite;
		private var tankNum:Number;
		
		public var mcTank:MovieClip;
		
		private var reloadFrames:int = 50;
		private var reloadFramesLeft:int = 0;
		
		private var invulnFrames:int = 100;
		private var invulnFramesLeft:int = 0;
		
		private var respawnFrames:int = 100;
		private var respawnFramesLeft:int = 0;
		
		public var playerState:String = "normal";		// normal, dead, invuln, waiting
		private var playerNameText:TextField;
		private var scoreText:TextField;
		
		function PlayerTank(mc:TankGame, n:Number)
		{
			tankNum = n;
			mcMain = mc;
			tankAngle = 0;
			var myFont:Font = new Font1();			
			
			// FIXME: textlabel "player 1"
			// textlabel score.. 
			
			UIHolder = new Sprite();
			mcMain.addChild(UIHolder);
			
			leftTread = new Slider(50, 150);
			leftTread.x = -100;
			leftTread.y = -100;
			leftTread.setValue(0.5);
			UIHolder.addChild(leftTread);
			
			rightTread = new Slider(50, 150);
			rightTread.x = 0;
			rightTread.y = -100;
			rightTread.setValue(0.5);
			UIHolder.addChild(rightTread);
			
			turretKnob = new Knob(100);
			turretKnob.x = 100;
			turretKnob.y = -100;
			turretKnob.setMinValue(0.25);
			turretKnob.setMaxValue(0.75);			
			turretKnob.setValue(0.5);			
			turretKnob.hideLabel();
			UIHolder.addChild(turretKnob);	
	
			fireButton = new FireButton();
			fireButton.addEventListener(MouseEvent.CLICK, fireFunc, false, 0, true);
			
			var tempobj:Wrapper = new Wrapper(fireButton);
			tempobj.x = 100;
			tempobj.y = 0;
			
			var tf:TextFormat = new TextFormat();
			tf.color = 0xffffff;
			tf.align = "left";
			tf.size = 20;
			tf.font = myFont.fontName;
			
			playerNameText = new TextField();
			playerNameText.x = 200;
			playerNameText.y = -100;
			playerNameText.width = 75;
			playerNameText.defaultTextFormat  = tf;			
			playerNameText.text = "Player" + tankNum;
			playerNameText.embedFonts = true;
			UIHolder.addChild(playerNameText);
			
			scoreText = new TextField();
			scoreText.x = 200;
			scoreText.y = -80;
			scoreText.width = 75;
			scoreText.defaultTextFormat  = tf;			
			scoreText.text = "0";
			scoreText.embedFonts = true;
			UIHolder.addChild(scoreText);			
			
			
			// FIXME: create 'health' text box.. 
			
			UIHolder.addChild(tempobj);

			upVec = new Point(0,-1);
			
			if(tankNum == 1)
				mcTank = new Tank1();
			else if(tankNum == 2)
				mcTank = new Tank2();			
			else if(tankNum == 3)				
				mcTank = new Tank3();				
			else if(tankNum == 4)				
				mcTank = new Tank4();				
			
			mcTank.name = "Player" + tankNum;
			mcMain.mcArena.addChild(mcTank);
			
			mcMain.addEventListener(Event.ENTER_FRAME, this.frameUpdate, false, 0, true);		
			
			
			mcTank.visible = false;
			playerState = "waiting";
			invulnFramesLeft = invulnFrames;
			mcTank.alpha = 0.5;	
			
			mcMain.addEventListener(Event.UNLOAD, unloadHandler, false, 0, true);
			
		}
		
		function unloadHandler(e:Event)
		{
			mcMain.removeEventListener(Event.ENTER_FRAME, this.frameUpdate);
			fireButton.removeEventListener(MouseEvent.CLICK, fireFunc);
		}
		
		function setUIPosition(xpos:Number, ypos:Number, rot:Number)
		{
			// Position the UI.. 
			UIHolder.x = xpos;
			UIHolder.y = ypos;
			UIHolder.rotation = rot;
		}
		
		function setTankPosition(xpos:Number, ypos:Number, rot:Number)
		{
			startX = xpos;
			startY = ypos;
			startAngle = rot;
			mcTank.x = xpos;
			mcTank.y = ypos;
			mcTank.rotation = rot;
			tankAngle = rot;
			turretKnob.setValue(0.5);
		}
		
		function fireFunc(e:Event)
		{
			if(playerState == "waiting")
			{
					mcTank.visible = true;
					playerState = "invuln";
					invulnFramesLeft = invulnFrames;
					mcTank.alpha = 0.5;				
			} else if (playerState == "normal" || playerState == "invuln") {
				
			
				trace("FIRE");
				if(reloadFramesLeft == 0)
				{
					var projectile:TankProjectile = new TankProjectile(tankAngle + mcTank.mcTurret.rotation, 20, this, mcMain);
					projectile.x = mcTank.x;
					projectile.y = mcTank.y;
					mcMain.mcArena.addChild(projectile);			
					reloadFramesLeft = reloadFrames;
				}
			}
			
		}
		
		function frameUpdate(e:Event)		
		{
			if(this.playerState == "normal" || this.playerState == "invuln")
			{
				var m:Matrix = new Matrix();
				m.rotate((tankAngle * Math.PI) / 180.0);
				facingVec = m.transformPoint(upVec);
				var leftVal:Number = (leftTread.getValue() - 0.5) * 2.0;
				var rightVal:Number = (rightTread.getValue() - 0.5) * 2.0;
	
				mcTank.x += 3 * facingVec.x * (leftVal + rightVal);
				mcTank.y += 3 * facingVec.y * (leftVal + rightVal);			
	
				mcTank.mcTurret.rotation = (turretKnob.getValue() * 360) - 180;
				
				if(mcTank.x > mcMain.arenaWidth)
					mcTank.x = 0.0;
				if(mcTank.x < 0.0)
					mcTank.x = mcMain.arenaWidth;
					
				if(mcTank.y > mcMain.arenaHeight)
					mcTank.y = 0.0;
				if(mcTank.y < 0)
					mcTank.y = mcMain.arenaHeight;
				
				tankAngle += (leftVal - rightVal)*5.0;
	
				mcTank.rotation = tankAngle;
				
				if(reloadFramesLeft > 0)
					reloadFramesLeft -= 1;
					
				if(invulnFramesLeft > 0)
				{
					invulnFramesLeft -= 1;
					if(invulnFramesLeft == 0)
					{
						playerState = "normal";
						mcTank.alpha = 1.0;						
					}
				}
					
			} else if(playerState == "dead")
			{
				if(respawnFramesLeft > 0)
					respawnFramesLeft--;
					
				if(respawnFramesLeft == 0)
				{
					mcTank.visible = true;
					playerState = "invuln";
					invulnFramesLeft = invulnFrames;
					mcTank.alpha = 0.5;
					setTankPosition(startX, startY, startAngle);
				}
					
			}
		}
		
		function addToScore(n:int)
		{
			score += n;
			// update text field
			scoreText.text = score.toString();
		}

		function tankHit()
		{
			playerState = "dead";
			mcTank.visible = false;
			
			var exp:MovieClip = new Explosion();
			mcMain.mcArena.addChild(exp);			
			exp.x = mcTank.x;
			exp.y = mcTank.y;

			respawnFramesLeft = respawnFrames;
			
		}
	}
}