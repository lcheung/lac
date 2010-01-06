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

package Box2D.Collision.Shapes{



import Box2D.Common.Math.*;
import Box2D.Common.*;
import Box2D.Collision.Shapes.*;



public class b2PolyDef extends b2ShapeDef
{
	public function b2PolyDef()
	{
		type = b2Shape.e_polyShape;
		vertexCount = 0;
		
		for (var i:int = 0; i < b2Settings.b2_maxPolyVertices; i++){
			vertices[i] = new b2Vec2();
		}
	}

	public var vertices:Array = new Array(b2Settings.b2_maxPolyVertices);
	public var vertexCount:int;
};

}