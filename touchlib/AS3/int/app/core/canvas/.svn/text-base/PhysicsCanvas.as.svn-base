
package app.core.canvas {
	
	import flash.events.Event;
	
	import Box2D.Dynamics.*;
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Dynamics.Joints.*;
	import Box2D.Dynamics.Contacts.*;
	import Box2D.Common.*;
	import Box2D.Common.Math.*;

	
	import flash.utils.getTimer;
	import flash.display.*;
	
	import app.core.action.*;
	import app.core.element.*;	
	
	public class PhysicsCanvas extends Multitouchable
	{
		
		//======================
		// Member Data 
		//======================
		public var m_world:b2World;
		public var m_bomb:b2Body;
		public var m_mouseJoint:b2MouseJoint;
		public var m_iterations:int = 15;
		public var m_timeStep:Number = 1/30;
		public var m_physScale:Number = 1;
		// world mouse position

		// Sprite to draw in to
		public var m_sprite:Sprite;
		private var mousePVec:b2Vec2 = new b2Vec2();
				
		protected var leftWall:b2Body = null;
		protected var topWall:b2Body = null;		
		protected var rightWall:b2Body = null;
		protected var bottomWall:b2Body = null;				
		
		protected var wallAreaWidth:int = 800;
		protected var wallAreaHeight:int = 600;		
		
		public function PhysicsCanvas()
		{
			trace("Physics canvas init");
			
			var inputFixSprite:Sprite = new Sprite();
			inputFixSprite.graphics.lineStyle(0,0,0);
			inputFixSprite.graphics.beginFill(0,0);
			inputFixSprite.graphics.moveTo(-10000, -10000);
			inputFixSprite.graphics.lineTo(10000, -10000);
			inputFixSprite.graphics.lineTo(10000, 10000);
			inputFixSprite.graphics.lineTo(-10000, 10000);
			inputFixSprite.graphics.endFill();
			addChild(inputFixSprite);
			
			addEventListener(Event.ENTER_FRAME, updateFrame, false, 0, true);			
			
			var worldAABB:b2AABB = new b2AABB();
			worldAABB.minVertex.Set(-2000.0, -2000.0);
			worldAABB.maxVertex.Set(2000.0, 2000.0);
			
			// Define the gravity vector
			var gravity:b2Vec2 = new b2Vec2(0.0, 0.0);
			
			// Allow bodies to sleep
			var doSleep:Boolean = true;
			
			// Construct a world object
			m_world = new b2World(worldAABB, gravity, doSleep);
			
			
			var drawSprite:Sprite = new Sprite();
			addChild(drawSprite);					
			
			m_sprite = drawSprite;
			
			setWalls(800, 600);
		}
		
		public function destroyBody(b:b2Body)
		{
			if(b.m_userData && b.m_userData.sprite)
			{
				removeChild(b.m_userData.sprite);
				b.m_userData.sprite = null;
			}
			
			m_world.DestroyBody(b);									
		}
		
		public function clearWorld()
		{
			
			for (var bb:b2Body = m_world.m_bodyList; bb; bb = bb.m_next){
				if (bb.m_userData && bb.m_userData.sprite is Sprite){
					removeChild(bb.m_userData.sprite);
				} 
			}						
			
			
			var worldAABB:b2AABB = new b2AABB();
			worldAABB.minVertex.Set(-2000.0, -2000.0);
			worldAABB.maxVertex.Set(2000.0, 2000.0);
			
			m_world = new b2World(worldAABB, m_world.m_gravity, true);
			
			setWalls(wallAreaWidth, wallAreaHeight);
		}
		
		public function setWalls(areaWidth:int, areaHeight:int)
		{
			
			wallAreaWidth = areaWidth;
			wallAreaHeight = areaHeight;
			
			if(leftWall)
				m_world.DestroyBody(leftWall);			
			if(topWall)
				m_world.DestroyBody(topWall);			
			if(rightWall)
				m_world.DestroyBody(rightWall);			
			if(bottomWall)
				m_world.DestroyBody(bottomWall);
				
			//m_world.CleanBodyList();							
				
			var wallSd:b2BoxDef = new b2BoxDef();
			var wallBd:b2BodyDef = new b2BodyDef();
			wallBd.AddShape(wallSd);
			

			
			//left
			wallSd.extents.Set(100/m_physScale, (areaHeight-10)/m_physScale/2);
			wallBd.position.Set(-95 / m_physScale, areaHeight/m_physScale/2);
			leftWall = m_world.CreateBody(wallBd);
			leftWall.m_userData = { type: "WorldWall", orient: "left"};
			// Right		
			wallBd.position.Set((areaWidth+95) / m_physScale, areaHeight/m_physScale/2);
			rightWall = m_world.CreateBody(wallBd);
			rightWall.m_userData = { type: "WorldWall", orient: "right"};
			// Top
			wallSd.extents.Set(areaWidth/m_physScale/2, 100/m_physScale);
			wallBd.position.Set(areaWidth/m_physScale/2, -95/m_physScale);
			topWall = m_world.CreateBody(wallBd);
			topWall.m_userData = { type: "WorldWall", orient: "top"};			
			// Bottom
			wallBd.position.Set(areaWidth/m_physScale/2, (areaHeight+95)/m_physScale);
			bottomWall = m_world.CreateBody(wallBd);			
			bottomWall.m_userData = { type: "WorldWall", orient: "bottom"};						
			

		}
		
		public function setGravity( xgrav:Number, ygrav:Number )
		{
			m_world.m_gravity = new b2Vec2(xgrav, ygrav);
		}
		
		public function frameCallback()
		{
		}
		
		public function Update():void{
			
			m_sprite.graphics.clear();

			
			for(var i:int=0; i<blobs.length; i++)
			{

				m_sprite.graphics.beginFill(0xffffff, 0.5);						
				m_sprite.graphics.drawCircle(blobs[i].x, blobs[i].y, 20);
							m_sprite.graphics.endFill();
			}

			
			
			// Update mouse joint
			InputDrag();
			
			// Update physics
			var physStart:uint = getTimer();
			m_world.Step(m_timeStep, m_iterations);
			//Main.m_fpsCounter.updatePhys(physStart);
			
			// Render
			// joints
			for (var jj:b2Joint = m_world.m_jointList; jj; jj = jj.m_next){
				DrawJoint(jj);
			}
			// bodies
		
			// Go through body list and update sprite positions/rotations
			for (var bb:b2Body = m_world.m_bodyList; bb; bb = bb.m_next){
				if (bb.m_userData && bb.m_userData.sprite is Sprite){
					bb.m_userData.sprite.x = bb.m_position.x;
					bb.m_userData.sprite.y = bb.m_position.y;
					bb.m_userData.sprite.rotation = bb.m_rotation * (180/Math.PI);
				} else {
					for (var s:b2Shape = bb.GetShapeList(); s != null; s = s.GetNext()){
						DrawShape(s);
					}					
					
				}
			}			
			
			
		}
		
		public function updateFrame(e:Event)
		{
			Update();
			frameCallback();
		}
		
		//======================
		// Update mouseWorld
		//======================

		public function physDragBlob(id:int, mx:Number, my:Number)
		{
			trace("Handle blob created " + id);
			blobinfo = getBlobInfo(id);

			var xworld:Number = mx/m_physScale,
				yworld:Number = my/m_physScale;			
				
			var body:b2Body = GetBodyAtPos(xworld, yworld);
			
			if (body && !(body.m_userData && body.m_userData.grabbable == false))
			{
				var md:b2MouseJointDef = new b2MouseJointDef();
				md.body1 = m_world.m_groundBody;
				md.body2 = body;
				md.target.Set(xworld, yworld);
				md.maxForce = 20000.0 * body.m_mass;
				md.timeStep = m_timeStep;
				blobinfo.m_Joint = m_world.CreateJoint(md) as b2MouseJoint;
				body.WakeUp();
			}			
			
		}
		override public function handleBlobCreated(id:int, mx:Number, my:Number):void
		{
			physDragBlob(id, mx, my);


		}
		
		override public function handleBlobRemoved(id:int):void
		{
			trace("Handle blob removed");			
			blobinfo = getBlobInfo(id);		
			
			if (blobinfo.m_Joint)
			{
				trace("Destroying joint");				
				m_world.DestroyJoint(blobinfo.m_Joint);
				blobinfo.m_Joint = null;

			}			
		}		
		
		
		//======================
		// Input Drag 
		//======================
		public function InputDrag():void
		{
			for(var i:int=0; i<blobs.length; i++)
			{
				if(blobs[i].m_Joint)
				{				
					var xworld:Number = blobs[i].x/m_physScale,
						yworld:Number = blobs[i].y/m_physScale;
					
	
					var p2:b2Vec2 = new b2Vec2(xworld, yworld);
					blobs[i].m_Joint.SetTarget(p2);
				} else {
					physDragBlob(blobs[i].id, blobs[i].x, blobs[i].y);
				}
			}
			
		}
		
		
		
		//======================
		// GetBodyAtMouse
		//======================

		public function GetBodyAtPos(xworld:Number, yworld:Number, includeStatic:Boolean=false):b2Body
		{
	

			// Make a small box.
			mousePVec.Set(xworld, yworld);
			var aabb:b2AABB = new b2AABB();
			aabb.minVertex.Set(xworld - 0.02, yworld - 0.02);
			aabb.maxVertex.Set(xworld + 0.02, yworld + 0.02);
			
			// Query the world for overlapping shapes.
			var k_maxCount:int = 10;
			var shapes:Array = new Array();
			var count:int = m_world.Query(aabb, shapes, k_maxCount);
			var body:b2Body = null;
			for (var i:int = 0; i < count; ++i)
			{
				if (shapes[i].m_body.IsStatic() == false || includeStatic)
				{
					var inside:Boolean = shapes[i].TestPoint(mousePVec);
					if (inside)
					{
						body = shapes[i].m_body;
						break;
					}
				}
			}
			return body;

		}
		
		
		//======================
		// Draw Pairs
		//======================
		public function DrawPairs():void{
			
			var bp:b2BroadPhase = m_world.m_broadPhase;
			var invQ:b2Vec2 = new b2Vec2();
			invQ.Set(1.0 / bp.m_quantizationFactor.x, 1.0 / bp.m_quantizationFactor.y);
			
			for (var i:int = 0; i < bp.m_pairManager.m_pairCount; ++i)
			{
				var pair:b2Pair = bp.m_pairManager.m_pairs[ i ];
				var id1:uint = pair.proxyId1;
				var id2:uint = pair.proxyId2;
				var p1:b2Proxy = bp.m_proxyPool[ id1 ];
				var p2:b2Proxy = bp.m_proxyPool[ id2 ];
				
				var b1:b2AABB = new b2AABB();
				var b2:b2AABB = new b2AABB();
				b1.minVertex.x = bp.m_worldAABB.minVertex.x + invQ.x * bp.m_bounds[0][p1.lowerBounds[0]].value;
				b1.minVertex.y = bp.m_worldAABB.minVertex.y + invQ.y * bp.m_bounds[1][p1.lowerBounds[1]].value;
				b1.maxVertex.x = bp.m_worldAABB.minVertex.x + invQ.x * bp.m_bounds[0][p1.upperBounds[0]].value;
				b1.maxVertex.y = bp.m_worldAABB.minVertex.y + invQ.y * bp.m_bounds[1][p1.upperBounds[1]].value;
				b2.minVertex.x = bp.m_worldAABB.minVertex.x + invQ.x * bp.m_bounds[0][p2.lowerBounds[0]].value;
				b2.minVertex.y = bp.m_worldAABB.minVertex.y + invQ.y * bp.m_bounds[1][p2.lowerBounds[1]].value;
				b2.maxVertex.x = bp.m_worldAABB.minVertex.x + invQ.x * bp.m_bounds[0][p2.upperBounds[0]].value;
				b2.maxVertex.y = bp.m_worldAABB.minVertex.y + invQ.y * bp.m_bounds[1][p2.upperBounds[1]].value;
				
				var x1:b2Vec2 = b2Math.MulFV(0.5, b2Math.AddVV(b1.minVertex, b1.maxVertex) );
				var x2:b2Vec2 = b2Math.MulFV(0.5, b2Math.AddVV(b2.minVertex, b2.maxVertex) );
				
				m_sprite.graphics.lineStyle(1,0xff2222,1);
				m_sprite.graphics.moveTo(x1.x * m_physScale, x1.y * m_physScale);
				m_sprite.graphics.lineTo(x2.x * m_physScale, x2.y * m_physScale);
			}
			
		}
		
		//======================
		// Draw Contacts
		//======================
		public function DrawContacts():void{
			for (var c:b2Contact = m_world.m_contactList; c; c = c.m_next)
			{
				var ms:Array = c.GetManifolds();
				for (var i:int = 0; i < c.GetManifoldCount(); ++i)
				{
					var m:b2Manifold = ms[ i ];
					//this.graphics.lineStyle(3,0x11CCff,0.7);
					
					for (var j:int = 0; j < m.pointCount; ++j)
					{	
						m_sprite.graphics.lineStyle(m.points[j].normalImpulse,0x11CCff,0.7);
						var v:b2Vec2 = m.points[j].position;
						m_sprite.graphics.moveTo(v.x * m_physScale, v.y * m_physScale);
						m_sprite.graphics.lineTo(v.x * m_physScale, v.y * m_physScale);
						
					}
				}
			}
		}
		
		
		//======================
		// Draw Shape 
		//======================
		public function DrawShape(shape:b2Shape):void{
			switch (shape.m_type)
			{
			case b2Shape.e_circleShape:
				{
					var circle:b2CircleShape = shape as b2CircleShape;
					var pos:b2Vec2 = circle.m_position;
					var r:Number = circle.m_radius;
					var k_segments:Number = 16.0;
					var k_increment:Number = 2.0 * Math.PI / k_segments;
					m_sprite.graphics.lineStyle(1,0xffffff,1);
					m_sprite.graphics.moveTo((pos.x + r) * m_physScale, (pos.y) * m_physScale);
					var theta:Number = 0.0;
					
					for (var i:int = 0; i < k_segments; ++i)
					{
						var d:b2Vec2 = new b2Vec2(r * Math.cos(theta), r * Math.sin(theta));
						var v:b2Vec2 = b2Math.AddVV(pos , d);
						m_sprite.graphics.lineTo((v.x) * m_physScale, (v.y) * m_physScale);
						theta += k_increment;
					}
					m_sprite.graphics.lineTo((pos.x + r) * m_physScale, (pos.y) * m_physScale);
					
					m_sprite.graphics.moveTo((pos.x) * m_physScale, (pos.y) * m_physScale);
					var ax:b2Vec2 = circle.m_R.col1;
					var pos2:b2Vec2 = new b2Vec2(pos.x + r * ax.x, pos.y + r * ax.y);
					m_sprite.graphics.lineTo((pos2.x) * m_physScale, (pos2.y) * m_physScale);
				}
				break;
			case b2Shape.e_polyShape:
				{
					var poly:b2PolyShape = shape as b2PolyShape;
					var tV:b2Vec2 = b2Math.AddVV(poly.m_position, b2Math.b2MulMV(poly.m_R, poly.m_vertices[i]));
					m_sprite.graphics.lineStyle(1,0xffffff,1);
					m_sprite.graphics.moveTo(tV.x * m_physScale, tV.y * m_physScale);
					
					for (i = 0; i < poly.m_vertexCount; ++i)
					{
						v = b2Math.AddVV(poly.m_position, b2Math.b2MulMV(poly.m_R, poly.m_vertices[i]));
						m_sprite.graphics.lineTo(v.x * m_physScale, v.y * m_physScale);
					}
					m_sprite.graphics.lineTo(tV.x * m_physScale, tV.y * m_physScale);
				}
				break;
			}
		}
		
		
		//======================
		// Draw Joint 
		//======================
		public function DrawJoint(joint:b2Joint):void
		{
			var b1:b2Body = joint.m_body1;
			var b2:b2Body = joint.m_body2;
			
			var x1:b2Vec2 = b1.m_position;
			var x2:b2Vec2 = b2.m_position;
			var p1:b2Vec2 = joint.GetAnchor1();
			var p2:b2Vec2 = joint.GetAnchor2();
			
			m_sprite.graphics.lineStyle(1,0x44aaff,1/1);
			
			switch (joint.m_type)
			{
			case b2Joint.e_distanceJoint:
			case b2Joint.e_mouseJoint:
				m_sprite.graphics.moveTo(p1.x * m_physScale, p1.y * m_physScale);
				m_sprite.graphics.lineTo(p2.x * m_physScale, p2.y * m_physScale);
				break;
				
			case b2Joint.e_pulleyJoint:
				var pulley:b2PulleyJoint = joint as b2PulleyJoint;
				var s1:b2Vec2 = pulley.GetGroundPoint1();
				var s2:b2Vec2 = pulley.GetGroundPoint2();
				m_sprite.graphics.moveTo(s1.x * m_physScale, s1.y * m_physScale);
				m_sprite.graphics.lineTo(p1.x * m_physScale, p1.y * m_physScale);
				m_sprite.graphics.moveTo(s2.x * m_physScale, s2.y * m_physScale);
				m_sprite.graphics.lineTo(p2.x * m_physScale, p2.y * m_physScale);
				break;
				
			default:
				if (b1 == m_world.m_groundBody){
					m_sprite.graphics.moveTo(p1.x * m_physScale, p1.y * m_physScale);
					m_sprite.graphics.lineTo(x2.x * m_physScale, x2.y * m_physScale);
				}
				else if (b2 == m_world.m_groundBody){
					m_sprite.graphics.moveTo(p1.x * m_physScale, p1.y * m_physScale);
					m_sprite.graphics.lineTo(x1.x * m_physScale, x1.y * m_physScale);
				}
				else{
					m_sprite.graphics.moveTo(x1.x * m_physScale, x1.y * m_physScale);
					m_sprite.graphics.lineTo(p1.x * m_physScale, p1.y * m_physScale);
					m_sprite.graphics.lineTo(x2.x * m_physScale, x2.y * m_physScale);
					m_sprite.graphics.lineTo(p2.x * m_physScale, p2.y * m_physScale);
				}
			}
		}
	}
	
}