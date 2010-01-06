﻿/*
* Copyright (c) 2006-2007 Erin Catto http://www.gphysics.com
*
* This software is provided 'as-is', without any express or implied
* warranty.  In no event will the authors be held liable for any damages
* arising from the use of this software.
* Permission is granted to anyone to use this software for any purpose,
* including commercial applications, and to alter it and redistribute it
* freely, subject to the following restrictions:
* 1. The origin of this software must not be misrepresented; you must not
* claim that you wrote the original software. If you use this software
* in a product, an acknowledgment in the product documentation would be
* appreciated but is not required.
* 2. Altered source versions must be plainly marked as such, and must not be
* misrepresented as being the original software.
* 3. This notice may not be removed or altered from any source distribution.
*/

package Box2D.Dynamics.Joints{

	
import Box2D.Common.Math.*


public class b2MouseJointDef extends b2JointDef
{
	public function b2MouseJointDef()
	{
		type = b2Joint.e_mouseJoint;
		maxForce = 0.0;
		frequencyHz = 5.0;
		dampingRatio = 0.7;
		timeStep = 1.0 / 60.0;
	}

	public var target:b2Vec2 = new b2Vec2();
	public var maxForce:Number;
	public var frequencyHz:Number;
	public var dampingRatio:Number;
	public var timeStep:Number;
};

}