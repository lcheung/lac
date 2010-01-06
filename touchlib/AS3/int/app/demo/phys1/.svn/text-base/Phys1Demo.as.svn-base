package app.demo.phys1
{

	import flash.display.*;
	import flash.filters.*;
	import flash.geom.*;
	import flash.events.*;
	import app.core.action.*;
	import app.core.element.*;
	import app.core.canvas.PhysicsCanvas;
	
	
	import Box2D.Dynamics.*;
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Dynamics.Joints.*;
	import Box2D.Dynamics.Contacts.*;
	import Box2D.Common.*;
	import Box2D.Common.Math.*;
			

	public class Phys1Demo extends PhysicsCanvas
	{

		
		function Phys1Demo()
		{
			
			trace("Phys1 demo init");

			
			if(this.stage)
			{
				addedToStage(new Event(Event.ADDED_TO_STAGE));
			} else {
				this.addEventListener(Event.ADDED_TO_STAGE, addedToStage, false, 0, true);
			}			

			
			TUIO.init( this, 'localhost', 3000, '', true );
			TestRagdoll();
			
			setGravity(0, 300);
		}
		
		
		public function TestBridge(){
			
			// Set Text field
			
			var ground:b2Body = m_world.m_groundBody;
			var i:int;
			
			// Bridge
			{
				var sd:b2BoxDef = new b2BoxDef();
				sd.extents.Set(24 / m_physScale, 5 / m_physScale);
				sd.density = 20.0;
				sd.friction = 0.2;
				
				var bd:b2BodyDef = new b2BodyDef();
				bd.AddShape(sd);
				
				var jd:b2RevoluteJointDef = new b2RevoluteJointDef();
				const numPlanks:int = 10;
				
				var prevBody:b2Body = ground;
				for (i = 0; i < numPlanks; ++i)
				{
					bd.position.Set((100 + 22 + 44 * i) / m_physScale, 250 / m_physScale);
					var body:b2Body = m_world.CreateBody(bd);
					
					jd.anchorPoint.Set((100 + 44 * i) / m_physScale, 250 / m_physScale);
					jd.body1 = prevBody;
					jd.body2 = body;
					m_world.CreateJoint(jd);
					
					prevBody = body;
				}
				
				jd.anchorPoint.Set((100 + 44 * numPlanks) / m_physScale, 250 / m_physScale);
				jd.body1 = prevBody;
				jd.body2 = ground;
				m_world.CreateJoint(jd);
			}
			
			
			
			
			
			
			
			
			// Spawn in a bunch of crap
			for (i = 0; i < 5; i++){
				var bodyDef:b2BodyDef = new b2BodyDef();
				var boxDef:b2BoxDef = new b2BoxDef();
				boxDef.density = 1.0;
				// Override the default friction.
				boxDef.friction = 0.3;
				boxDef.restitution = 0.1;
				boxDef.extents.Set((Math.random() * 5 + 10) / m_physScale, (Math.random() * 5 + 10) / m_physScale);
				bodyDef.position.Set((Math.random() * 400 + 120) / m_physScale, (Math.random() * 150 + 50) / m_physScale);
				bodyDef.rotation = Math.random() * Math.PI;
				bodyDef.AddShape(boxDef);
				m_world.CreateBody(bodyDef);
				
			}
			for (i = 0; i < 5; i++){
				var bodyDefC:b2BodyDef = new b2BodyDef();
				var circDef:b2CircleDef = new b2CircleDef();
				circDef.density = 1.0;
				circDef.radius = (Math.random() * 5 + 10) / m_physScale;
				// Override the default friction.
				circDef.friction = 0.3;
				circDef.restitution = 0.1;
				bodyDefC.position.Set((Math.random() * 400 + 120) / m_physScale, (Math.random() * 150 + 50) / m_physScale);
				bodyDefC.rotation = Math.random() * Math.PI;
				bodyDefC.AddShape(circDef);
				m_world.CreateBody(bodyDefC);
				
			}
			for (i = 0; i < 15; i++){
				var bodyDefP:b2BodyDef = new b2BodyDef();
				var polyDef:b2PolyDef = new b2PolyDef();
				if (Math.random() > 0.66){
					polyDef.vertexCount = 4;
					polyDef.vertices[0].Set((-30 -Math.random()*30) / m_physScale, ( 30 +Math.random()*30) / m_physScale);
					polyDef.vertices[1].Set(( -5 -Math.random()*30) / m_physScale, (-30 -Math.random()*30) / m_physScale);
					polyDef.vertices[2].Set((  5 +Math.random()*30) / m_physScale, (-30 -Math.random()*30) / m_physScale);
					polyDef.vertices[3].Set(( 20 +Math.random()*30) / m_physScale, ( 30 +Math.random()*30) / m_physScale);
				}
				else if (Math.random() > 0.5){
					polyDef.vertexCount = 5;
					polyDef.vertices[0].Set(0, (10 +Math.random()*10) / m_physScale);
					polyDef.vertices[2].Set((-5 -Math.random()*10) / m_physScale, (-10 -Math.random()*10) / m_physScale);
					polyDef.vertices[3].Set(( 5 +Math.random()*10) / m_physScale, (-10 -Math.random()*10) / m_physScale);
					polyDef.vertices[1].Set((polyDef.vertices[0].x + polyDef.vertices[2].x), (polyDef.vertices[0].y + polyDef.vertices[2].y));
					polyDef.vertices[1].Multiply(Math.random()/2+0.8);
					polyDef.vertices[4].Set((polyDef.vertices[3].x + polyDef.vertices[0].x), (polyDef.vertices[3].y + polyDef.vertices[0].y));
					polyDef.vertices[4].Multiply(Math.random()/2+0.8);
				}
				else{
					polyDef.vertexCount = 3;
					polyDef.vertices[0].Set(0, (10 +Math.random()*10) / m_physScale);
					polyDef.vertices[1].Set((-5 -Math.random()*10) / m_physScale, (-10 -Math.random()*10) / m_physScale);
					polyDef.vertices[2].Set(( 5 +Math.random()*10) / m_physScale, (-10 -Math.random()*10) / m_physScale);
				}
				polyDef.density = 1.0;
				polyDef.friction = 0.3;
				polyDef.restitution = 0.1;
				bodyDefP.position.Set((Math.random() * 400 + 120) / m_physScale, (Math.random() * 150 + 50) / m_physScale);
				bodyDefP.rotation = Math.random() * Math.PI;
				bodyDefP.AddShape(polyDef);
				m_world.CreateBody(bodyDefP);
			}
			
		}		
		
		public function TestRagdoll(){
			
			// Set Text field
			
			var bd:b2BodyDef;
			var circ:b2CircleDef = new b2CircleDef();
			var box:b2BoxDef = new b2BoxDef();
			var jd:b2RevoluteJointDef = new b2RevoluteJointDef();
			
			// Add 5 ragdolls along the top
			for (var i:int = 0; i < 4; i++){
				var startX:Number = 100 + 145 * i;
				var startY:Number = 20 + Math.random() * 50;
				
				// BODIES
				
				// Head
				circ.radius = 12.5 / m_physScale;
				circ.density = 1.0;
				circ.friction = 0.4;
				circ.restitution = 0.3;
				bd = new b2BodyDef();
				bd.AddShape(circ);
				bd.position.Set(startX / m_physScale, startY / m_physScale);
				var head:b2Body = m_world.CreateBody(bd);
				
				// Torso1
				box.extents.Set(15 / m_physScale, 10 / m_physScale);
				box.density = 1.0;
				box.friction = 0.4;
				box.restitution = 0.1;
				bd = new b2BodyDef();
				bd.AddShape(box);
				bd.position.Set(startX / m_physScale, (startY + 28) / m_physScale);
				var torso1:b2Body = m_world.CreateBody(bd);
				// Torso2
				bd = new b2BodyDef();
				bd.AddShape(box);
				bd.position.Set(startX / m_physScale, (startY + 43) / m_physScale);
				var torso2:b2Body = m_world.CreateBody(bd);
				// Torso3
				bd = new b2BodyDef();
				bd.AddShape(box);
				bd.position.Set(startX / m_physScale, (startY + 58) / m_physScale);
				var torso3:b2Body = m_world.CreateBody(bd);
				
				// UpperArm
				box.extents.Set(18 / m_physScale, 6.5 / m_physScale);
				box.density = 1.0;
				box.friction = 0.4;
				box.restitution = 0.1;
				bd = new b2BodyDef();
				bd.AddShape(box);
				// L
				bd.position.Set((startX - 30) / m_physScale, (startY + 20) / m_physScale);
				var upperArmL:b2Body = m_world.CreateBody(bd);
				// R
				bd.position.Set((startX + 30) / m_physScale, (startY + 20) / m_physScale);
				var upperArmR:b2Body = m_world.CreateBody(bd);
				
				// LowerArm
				box.extents.Set(17 / m_physScale, 6 / m_physScale);
				box.density = 1.0;
				box.friction = 0.4;
				box.restitution = 0.1;
				bd = new b2BodyDef();
				bd.AddShape(box);
				// L
				bd.position.Set((startX - 57) / m_physScale, (startY + 20) / m_physScale);
				var lowerArmL:b2Body = m_world.CreateBody(bd);
				// R
				bd.position.Set((startX + 57) / m_physScale, (startY + 20) / m_physScale);
				var lowerArmR:b2Body = m_world.CreateBody(bd);
				
				// UpperLeg
				box.extents.Set(7.5 / m_physScale, 22 / m_physScale);
				box.density = 1.0;
				box.friction = 0.4;
				box.restitution = 0.1;
				bd = new b2BodyDef();
				bd.AddShape(box);
				// L
				bd.position.Set((startX - 8) / m_physScale, (startY + 85) / m_physScale);
				var upperLegL:b2Body = m_world.CreateBody(bd);
				// R
				bd.position.Set((startX + 8) / m_physScale, (startY + 85) / m_physScale);
				var upperLegR:b2Body = m_world.CreateBody(bd);
				
				// LowerLeg
				box.extents.Set(6 / m_physScale, 20 / m_physScale);
				box.density = 1.0;
				box.friction = 0.4;
				box.restitution = 0.1;
				bd = new b2BodyDef();
				bd.AddShape(box);
				// L
				bd.position.Set((startX - 8) / m_physScale, (startY + 119) / m_physScale);
				var lowerLegL:b2Body = m_world.CreateBody(bd);
				// R
				bd.position.Set((startX + 8) / m_physScale, (startY + 119) / m_physScale);
				var lowerLegR:b2Body = m_world.CreateBody(bd);
				
				
				// JOINTS
				jd.enableLimit = true;
				
				// Head to shoulders
				jd.lowerAngle = -40 / (180/Math.PI);
				jd.upperAngle = 40 / (180/Math.PI);
				jd.anchorPoint.Set(startX / m_physScale, (startY + 15) / m_physScale);
				jd.body1 = torso1;
				jd.body2 = head;
				m_world.CreateJoint(jd);
				
				// Upper arm to shoulders
				// L
				jd.lowerAngle = -85 / (180/Math.PI);
				jd.upperAngle = 130 / (180/Math.PI);
				jd.anchorPoint.Set((startX - 18) / m_physScale, (startY + 20) / m_physScale);
				jd.body1 = torso1;
				jd.body2 = upperArmL;
				m_world.CreateJoint(jd);
				// R
				jd.lowerAngle = -130 / (180/Math.PI);
				jd.upperAngle = 85 / (180/Math.PI);
				jd.anchorPoint.Set((startX + 18) / m_physScale, (startY + 20) / m_physScale);
				jd.body1 = torso1;
				jd.body2 = upperArmR;
				m_world.CreateJoint(jd);
				
				// Lower arm to upper arm
				// L
				jd.lowerAngle = -130 / (180/Math.PI);
				jd.upperAngle = 10 / (180/Math.PI);
				jd.anchorPoint.Set((startX - 45) / m_physScale, (startY + 20) / m_physScale);
				jd.body1 = upperArmL;
				jd.body2 = lowerArmL;
				m_world.CreateJoint(jd);
				// R
				jd.lowerAngle = -10 / (180/Math.PI);
				jd.upperAngle = 130 / (180/Math.PI);
				jd.anchorPoint.Set((startX + 45) / m_physScale, (startY + 20) / m_physScale);
				jd.body1 = upperArmR;
				jd.body2 = lowerArmR;
				m_world.CreateJoint(jd);
				
				// Shoulders/stomach
				jd.lowerAngle = -15 / (180/Math.PI);
				jd.upperAngle = 15 / (180/Math.PI);
				jd.anchorPoint.Set(startX / m_physScale, (startY + 35) / m_physScale);
				jd.body1 = torso1;
				jd.body2 = torso2;
				m_world.CreateJoint(jd);
				// Stomach/hips
				jd.anchorPoint.Set(startX / m_physScale, (startY + 50) / m_physScale);
				jd.body1 = torso2;
				jd.body2 = torso3;
				m_world.CreateJoint(jd);
				
				// Torso to upper leg
				// L
				jd.lowerAngle = -25 / (180/Math.PI);
				jd.upperAngle = 45 / (180/Math.PI);
				jd.anchorPoint.Set((startX - 8) / m_physScale, (startY + 72) / m_physScale);
				jd.body1 = torso3;
				jd.body2 = upperLegL;
				m_world.CreateJoint(jd);
				// R
				jd.lowerAngle = -45 / (180/Math.PI);
				jd.upperAngle = 25 / (180/Math.PI);
				jd.anchorPoint.Set((startX + 8) / m_physScale, (startY + 72) / m_physScale);
				jd.body1 = torso3;
				jd.body2 = upperLegR;
				m_world.CreateJoint(jd);
				
				// Upper leg to lower leg
				// L
				jd.lowerAngle = -25 / (180/Math.PI);
				jd.upperAngle = 115 / (180/Math.PI);
				jd.anchorPoint.Set((startX - 8) / m_physScale, (startY + 107) / m_physScale);
				jd.body1 = upperLegL;
				jd.body2 = lowerLegL;
				m_world.CreateJoint(jd);
				// R
				jd.lowerAngle = -115 / (180/Math.PI);
				jd.upperAngle = 25 / (180/Math.PI);
				jd.anchorPoint.Set((startX + 8) / m_physScale, (startY + 107) / m_physScale);
				jd.body1 = upperLegR;
				jd.body2 = lowerLegR;
				m_world.CreateJoint(jd);

			}
			

			// Add 10 random circles for them to hit
			for (var j:int = 0; j < 5; j++){
				circ.radius = (Math.random() * 30 + 30) / m_physScale;
				circ.density = 0.0;
				circ.friction = 0.4;
				circ.restitution = 0.3;
				bd = new b2BodyDef();
				bd.AddShape(circ);
				bd.position.Set((Math.random() * 540 + 50) / m_physScale, (Math.random() * 200 + 150) / m_physScale);
				m_world.CreateBody(bd);
			}
			
			
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
			
			setWalls(wd, ht);
			
		// fixme: scale to fit.. 
			
		}



	}
}