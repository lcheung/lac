package app.demo.phys1
{

	import flash.display.*;
	import flash.filters.*;
	import flash.geom.*;
	import flash.events.*;
	import app.core.action.*;
	import app.core.element.*;
	import app.core.canvas.PhysicsCanvas;
	import flash.text.*;
	
	import Box2D.Dynamics.*;
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Dynamics.Joints.*;
	import Box2D.Dynamics.Contacts.*;
	import Box2D.Common.*;
	import Box2D.Common.Math.*;

	public class Pegs extends PhysicsCanvas
	{
		private static var GOALPEGS:int = 10;
		private static var NUMBALLS:int = 5;
		
		private var goalPegs:int = 0;
		private var score:int = 0;
		private var balls:int = GOALPEGS;
		
		private var freeBallMeter = 0.0;
		

		
		private var gameBalls:Array;
		
	
		function Pegs()
		{

			trace("Phys1 demo init");
			
			if(this.stage)
			{
				addedToStage(new Event(Event.ADDED_TO_STAGE));
			} else {
				this.addEventListener(Event.ADDED_TO_STAGE, addedToStage, false, 0, true);
			}			

			
			TUIO.init( this, 'localhost', 3000, '', false );		
			SetupPlayfield();
			setGravity(0, 300);
			setWalls(700, 600);			
		}
		
		public function updateDisplayText()
		{
			tfBalls.text = balls;			
			tfScore.text = score;			
			tfGoals.text = GOALPEGS;									
		}
		
		public function freeBall()
		{
			freeBallMeter = 0;
			balls += 1;
			updateDisplayText();
		}
		
		public function restartGame()
		{
			score = 0;
			balls = 0;
			
			clearWorld();
			SetupPlayfield();

		}
		
		public function resetBall(wx:Number, wy:Number)
		{
//			gameBall.SetCenterPosition(new b2Vec2(wx, wy), 0);
//			gameBall.SetLinearVelocity(new b2Vec2(0,0) );
//			gameBall.SetAngularVelocity(0);

			var bodyDefC:b2BodyDef = new b2BodyDef();
			var circDef:b2CircleDef = new b2CircleDef();

			circDef.density = 0.1;
			circDef.radius = 15 / m_physScale;
			// Override the default friction.
			circDef.friction = 0.98;
			circDef.restitution = 0.95;
			bodyDefC.position.Set(wx, wy);
			bodyDefC.rotation = Math.random() * Math.PI;
			bodyDefC.AddShape(circDef);
			var gameBall = m_world.CreateBody(bodyDefC);
			gameBall.m_userData = new Object();
			gameBall.m_userData.sprite = new GameBall();
			addChild(gameBall.m_userData.sprite);
			
			gameBalls.push(gameBall);
			
			balls -= 1;
			
			tfBalls.text = balls;
		}
		
		private function addScore(n:int)
		{
			score += n;
			tfScore.text = score;
			
			freeBallMeter += n * 0.001;
			if(freeBallMeter > 1.0)
				freeBall();
		}
		
		private function goalPegHit()
		{
			goalPegs -= 1;
			tfGoals.text = goalPegs;
			if(goalPegs == 0)
				restartGame();			
		}
		
		public function SetupPlayfield()
		{
			freeBallMeter = 0.0;
			gameBalls = new Array();			
			
			balls = NUMBALLS;
			tfBalls.text = balls;
			
			// Set Text field
			var ground:b2Body = m_world.m_groundBody;
			var i:int;
			
			var bod:b2Body;

			var wallSd:b2BoxDef = new b2BoxDef();
			var wallBd:b2BodyDef = new b2BodyDef();
			wallBd.AddShape(wallSd);
			
			/*
			wallSd.extents.Set(40/m_physScale, (20)/m_physScale);
			wallBd.position.Set(760 / m_physScale, 100/m_physScale);
			bod = m_world.CreateBody(wallBd);
			bod.m_userData = { type: "WorldWall", orient: "misc"};			
			*/
			
			wallSd.extents.Set(800/m_physScale, (20)/m_physScale);
			wallBd.position.Set(390 / m_physScale, 590/m_physScale);
			bod = m_world.CreateBody(wallBd);
			bod.m_userData = { type: "BallEater", orient: "misc"};
			
			goalPegs = GOALPEGS;
			var pegDef:b2CircleDef = new b2CircleDef();

			pegDef.density = 0.2;
			pegDef.radius = (Math.random() * 5 + 10) / m_physScale;
			// Override the default friction.
			pegDef.friction = 1.1;
			pegDef.restitution = 0.95;
			var bodyDefPeg:b2BodyDef = new b2BodyDef();			
			// Add 10 random circles for them to hit
			for (var j:int = 0; j < 70; j++){
				pegDef.radius = 10 / m_physScale;
				pegDef.density = 0.0;
				pegDef.friction = 0.4;
				pegDef.restitution = 0.3;
				bodyDefPeg = new b2BodyDef();
				bodyDefPeg.AddShape(pegDef);
				bodyDefPeg.position.Set((Math.random() * 600 + 40) / m_physScale, (Math.random() * 400 + 150) / m_physScale);
				bod = m_world.CreateBody(bodyDefPeg);
				
				bod.m_userData = new Object();				
			
				if(j < GOALPEGS)
				{
					bod.m_userData.sprite = new GoalPeg();
					bod.m_userData.type = "GoalPeg";		
				} else {
					bod.m_userData.sprite = new RegularPeg();													
					bod.m_userData.type = "Peg";							
				}
				addChild(bod.m_userData.sprite);									
			}

			for (i = 0; i < 3; i++) 
			{
				var bodyDef:b2BodyDef = new b2BodyDef();
				var boxDef:b2BoxDef = new b2BoxDef();
				boxDef.density = 1.0;
				// Override the default friction.
				boxDef.friction = 0.3;
				boxDef.restitution = 0.1;
				boxDef.extents.Set((Math.random() * 5 + 50) / m_physScale, (Math.random() * 5 + 10) / m_physScale);
				bodyDef.position.Set((Math.random() * 550 + 100) / m_physScale, (Math.random() * 50 + 50) / m_physScale);
				bodyDef.rotation = Math.random() * Math.PI;
				bodyDef.AddShape(boxDef);
				m_world.CreateBody(bodyDef);
				
			}			
			

			tfGoals.text = goalPegs;
			
	
		}		
		
		function addedToStage(e:Event)
		{
			trace("Added to stage");
			this.stage.addEventListener(Event.RESIZE, stageResized, false, 0, true);			
			stageResized(new Event(Event.RESIZE));			
			
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);			
		}
		
		function stageResized(e:Event)
		{			
			stage.align = StageAlign.TOP_LEFT;
			stage.displayState = StageDisplayState.FULL_SCREEN;			
			this.x = 0;
			this.y = 0;
			var wd:int = stage.stageWidth;
			var ht:int = stage.stageHeight;		
			
			//setWalls(wd, ht);			
			
			// fixme: scale to fit.. 
		}
		
		// override default dragging behavior.. 
		override public function handleBlobCreated(id:int, mx:Number, my:Number):void
		{
			if(balls <= 0)
				return;
				
			trace("Handle blob created " + id);
			blobinfo = getBlobInfo(id);
		
			var xworld:Number = mx/m_physScale,
				yworld:Number = my/m_physScale;		
				
			resetBall(xworld, yworld);
		}
		
		override public function InputDrag():void
		{
			// we don't want dragging in this application so turn it off here too. 
		}

		override public function frameCallback()
		{
			
			tfFreeMeter.text = int(freeBallMeter*100);				
			var i:int = 0;
			
			freeBallMeter *= 0.99;

			
			for(i=0; i<gameBalls.length; i++)
			{
				
				var contacts:b2ContactNode = gameBalls[i].GetContactList();
	
				var dep:int = 0;
				while(contacts)
				{
					try 
					{
						if(contacts.other.m_userData)
						{
							var spr:MovieClip;							
							if(contacts.other.m_userData.type == "BallEater")
							{
								trace("Kill!");
								//resetBall();
								
								if(balls == 0)			
								{
									restartGame();								
									return;
								} else {
									spr = new BurstAnim();
									spr.x = gameBalls[i].m_userData.sprite.x;
									spr.y = gameBalls[i].m_userData.sprite.y;								
									addChild(spr);											
									
									destroyBody(gameBalls[i]);
									gameBalls[i] = null;
								}

							}


							if(contacts.other.m_userData.type == "Peg")
							{
								spr = new BurstAnim();
								spr.x = contacts.other.m_userData.sprite.x;
								spr.y = contacts.other.m_userData.sprite.y;								
								addChild(spr);
								destroyBody(contacts.other);	
								addScore(250);
							}

							if(contacts.other.m_userData.type == "GoalPeg")
							{
								spr = new BurstAnim();
								spr.x = contacts.other.m_userData.sprite.x;
								spr.y = contacts.other.m_userData.sprite.y;								
								addChild(spr);								
								destroyBody(contacts.other);	
								addScore(500);		
								goalPegHit();
							}						
						}
					} catch(e)
					{
					}
					
					contacts = contacts.next;
						
	
				}
			} // end for balls
			
			for(i=0; i<gameBalls.length; i++)
			{			
				while(gameBalls[i] == null && i < gameBalls.length)
					gameBalls.splice(i, 1);
				
			}
			

				

			
	
		}

	}
}