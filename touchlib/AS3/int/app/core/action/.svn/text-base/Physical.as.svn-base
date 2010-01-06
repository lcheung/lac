package app.core.action
{
	import flash.display.*;		
	import flash.events.*;
	import flash.events.*;		
	import flash.geom.Point;
		
	import Box2D.Dynamics.*
	import Box2D.Dynamics.Joints.*
	import Box2D.Dynamics.Contacts.*
	import Box2D.Collision.Shapes.*
	import Box2D.Common.Math.*
	import Box2D.Common.*
	
	import caurina.transitions.Tweener;
	
	public class Physical extends Multitouchable
	{
		
		
		public var m_mass:Number;
		public var m_invMass:Number;
		
		public var m_worldScale:Number = 1.0;
		
		public var m_linearVelocity:b2Vec2;
		public var m_angularVelocity:Number;
	
		public var m_force:b2Vec2;
		public var m_torque:Number;
		
		public var m_position:b2Vec2;
		
		public var lastScaleAmt:Number;
		
		public var m_stretch:Number;
		
		public var scalefactor:Number = 0.0;
		
		public var scaleBehavior:String = "Discrete";
		public var scaleGestureOccurring:Boolean = false;
		
		private var centroid:Point
		

		
		public function Physical()
		{
			m_worldScale = 1.0;
				centroid = new Point();			
			m_mass = 1.0;
			m_invMass = 1/m_mass;
			
			m_angularVelocity = 0.0;
			m_linearVelocity = new b2Vec2(0,0);
			
			m_force = new b2Vec2(0,0);
			m_torque = 0;
			
			m_stretch = 0;
			lastScaleAmt = 1.0;
			
			m_position = new b2Vec2(0,0);
			
			addEventListener(Event.ENTER_FRAME, this.physicalUpdate);
		}
		
		public function applyForce(force:b2Vec2, point:b2Vec2) : void
		{
			
			
			var vec1:b2Vec2 = b2Math.SubtractVV(b2Math.MulFV(m_worldScale, point), m_position);

			force = b2Math.MulFV(m_worldScale, force);						
			m_force.Add( force );			

			m_torque += b2Math.b2CrossVV(vec1, force);
		}
		
		override public function handleBlobCreated(id:int, mx:Number, my:Number):void
		{
			trace("Blob created " + id);
			var blobinf:Object = getBlobInfo(id);
			if(blobinf.clicked)
			{
				blobinf.origRelativePt = new Point(mx, my);			
				
//				parent.swapChildrenAt(parent.getChildIndex(this), parent.numChildren-1);

				var p:DisplayObjectContainer = parent; 
				p.removeChild(this);
				p.addChild(this);
			}
		}
		
		public function beginScaleGesture()
		{
			scaleGestureOccurring = true;
		}		
		


		public function physicalUpdate(e:Event)
		{
			var i:int, j:int;
			
			if(width > height)
				this.m_worldScale = 100 / width;
			else
				this.m_worldScale = 100 / height;					

			m_position =  b2Math.MulFV(m_worldScale, new b2Vec2(x,y));			
			
			// dragging / rotation code
			for(i=0; i<blobs.length; i++)
			if(blobs[i].clicked)
			{

				var blobpt:Point;
				var bloborigpt:Point;
				
				
				blobpt = parent.globalToLocal(this.localToGlobal(new Point(blobs[i].x, blobs[i].y )));				
				// FIXME: this could be done on blob creation..
				bloborigpt = parent.globalToLocal(this.localToGlobal(new Point(blobs[i].origRelativePt.x, blobs[i].origRelativePt.y )));

				var point:b2Vec2 = new b2Vec2(bloborigpt.x, bloborigpt.y);
				var force:b2Vec2 = new b2Vec2((blobpt.x - bloborigpt.x), (blobpt.y - bloborigpt.y));				

//				var force:b2Vec2 = new b2Vec2(blobs[i].dX, blobs[i].dY);

				applyForce(force, point);
			}

			rotated( m_torque * m_invMass * 0.01);
			dragged(  m_force.x * m_invMass ,  m_force.y * m_invMass );
			
			m_force.x *= 0.1;
			m_force.y *= 0.1;
			m_torque *= 0.1;
			

			// scaling - maybe there's a better way?			
			var blobschecked:int = 0;
			var divisor:Number = 0;

			var avgOrigDist:Number = 0.0;
			var avgCurDist:Number = 0.0;
			var dist:Number = 0;
			var dx:Number = 0;
			var dy:Number = 0;
		
			if(blobs.length > 1)
			{

				centroid.x = 0;
				centroid.y = 0;
					
				for(i=0; i<blobs.length && blobschecked < 4; i++)
				if(blobs[i].clicked)
				{
					for(j=i+1; j<blobs.length && blobschecked < 4; j++)
					if(blobs[j].clicked)
					{
						// not the real distance.. (for speed).
						dx = blobs[i].origX - blobs[j].origX;
						dy = blobs[i].origY - blobs[j].origY;
						dist = Math.sqrt(dx*dx + dy*dy);
						avgOrigDist += dist;

						dx = blobs[i].x - blobs[j].x;
						dy = blobs[i].y - blobs[j].y;
						dist = Math.sqrt(dx*dx + dy*dy);
						avgCurDist += dist;

						divisor += 1;
					}

					centroid.x += blobs[i].x;
					centroid.y += blobs[i].y;

					blobschecked += 1;
				}
				
				avgOrigDist /= divisor;
				avgCurDist /= divisor;
				
				if(avgOrigDist == 0)
					avgOrigDist = 1.0;
				
				centroid.x /= blobschecked;
				centroid.y /= blobschecked;
			}
			
			if(blobschecked > 1)
			{

				m_stretch += 0.4 * ((avgCurDist / avgOrigDist) - lastScaleAmt);

				if(Math.abs(m_stretch) > 0.001)
					scaled(m_stretch, centroid.x, centroid.y, (avgCurDist / avgOrigDist));
				else 
					m_stretch = 0.0;
				m_stretch *= 0.4;

				lastScaleAmt = (avgCurDist / avgOrigDist);

			} else {
				lastScaleAmt = 1.0;
		
				if(Math.abs(m_stretch) > 0.001)
					scaled(m_stretch, centroid.x, centroid.y, 0);
				else 
					m_stretch = 0.0;
					
				m_stretch *= 0.9;
			}
		}
		
		// override these methods to change the default behavior and/or handle events.. 
		public function dragged(dx:Number, dy:Number)
		{
			this.x += dx;
			this.y += dy;
		}
		
		public function rotated(dr:Number)
		{
			this.rotation += dr;
		}
		
		override public function handleBlobRemoved(id:int):void
		{
			if(blobs.length == 1)
			{
				trace("Blob removed " + id);
				scaleGestureOccurring = false;
			}
		}
	
		public function scaled(amt:Number, posX:Number, posY:Number, rawScale:Number)
		{
			if(amt == 0)
				return;
				
			if(scaleBehavior == "Continuous")
			{
				
				if(amt < -0.1)
					amt = -0.1;
				if(amt > 0.1)
					amt = 0.1;
					
				var oldScale:Number = scaleX;
								
	//			if(scaleX + amt > 6.0)
	//				return;				
	
				trace("Scaled " + amt);
				
				if(scaleX + amt < 0.25)
					scaleX = 0.25;
				else if (scaleX + amt > 6.0)
					scaleX = 6.0
				else
					this.scaleX += amt;
	
				scaleY = scaleX;
				
					
				m_force.x += (posX - this.x) * (scaleX - oldScale);
				m_force.y += (posY - this.y) * (scaleX - oldScale);
			} else if(scaleBehavior == "Discrete")
			{
				
				trace(rawScale);
				if(rawScale == 0 || scaleGestureOccurring)
					return;
				
				if( rawScale > 1.5 )
				{
				    scaleGestureOccurring = true;
					Tweener.addTween(this, {scaleX: scaleX*2, scaleY: scaleY*2, delay:0, time:0.5, transition:"easeinoutquad" });	
				} else if (rawScale < 0.75)
				{
					scaleGestureOccurring = true;
					Tweener.addTween(this, {scaleX: scaleX*0.5, scaleY: scaleY*0.5, delay:0, time:0.5, transition:"easeinoutquad" });	
	
	
				}				
				
			}
		}
	}
	

}