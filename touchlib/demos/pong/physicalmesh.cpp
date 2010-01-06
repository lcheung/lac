#include "physicalmesh.h"

using namespace touchlib;

// Physically simulated mesh. Doesn't work that great,
// hopefully later we can implement Takeo's 'as-rigid-as-possible' mesh code.

PhysicalMesh::PhysicalMesh()
{
	source.scale = vector2df(0.1, 0.1);
	current.scale = vector2df(0.1, 0.1);

	angleK = 0.5;
	lenK = 0.5;
}

void PhysicalMesh::readFile(char *szfile)
{
	source.readOBJFile(szfile);
	current = source;
}

int PhysicalMesh::findClosestPoint(touchlib::vector2df &pt)
{

	return current.findClosestPoint(pt);
}

// sets the position of a point
void PhysicalMesh::setPoint(int p, touchlib::vector2df &to)
{
	if(p < 0 || p > current.points.size())
		return;

	current.points[p] = current.transformToLocal(to);
}

void PhysicalMesh::update()
{
	// correct angles and lengths.
	current.calculateAngles();

	// FIXME: if a triangle is 'flipped' then we need to reverse course..

	bool bFlip = false;

	int i, j;

	vector2df delta;
	int num_tris = (int)current.triangles.size();
	float dist_dif, dist, dist_src;
	for(i=0; i<num_tris; i+=3)
	{
		vector2df AB = current.points[current.triangles[i]] - current.points[current.triangles[i+1]];
		vector2df BC = current.points[current.triangles[i+2]] - current.points[current.triangles[i+1]];

		//if(AB.crossProduct(BC) > 0.0f)
			//bFlip = true;

		float angle_dif1, angle_dif2, angle_dif3;
		angle_dif1 = source.angles[i] - current.angles[i];
		angle_dif2 = source.angles[i+1] - current.angles[i+1];
		angle_dif3 = source.angles[i+2] - current.angles[i+2];

		//if(!bFlip)
		//{

		if(fabs(angle_dif1) >= fabs(angle_dif2) && fabs(angle_dif1) >= fabs(angle_dif3))
		{
			// 1
			current.points[current.triangles[i+1]].rotateBy(angle_dif1*-0.5*angleK, current.points[current.triangles[i]]);
			current.points[current.triangles[i+2]].rotateBy(angle_dif1*0.5*angleK, current.points[current.triangles[i]]);
		} 
		else if(fabs(angle_dif2) >= fabs(angle_dif1) && fabs(angle_dif2) >= fabs(angle_dif3))
		{
			// 2
			current.points[current.triangles[i+2]].rotateBy(angle_dif2*-0.5*angleK, current.points[current.triangles[i+1]]);
			current.points[current.triangles[i]].rotateBy(angle_dif2*0.5*angleK, current.points[current.triangles[i+1]]);
		} 
		else if(fabs(angle_dif3) >= fabs(angle_dif1) && fabs(angle_dif3) >= fabs(angle_dif2))
		{
			// 3
			current.points[current.triangles[i]].rotateBy(angle_dif3*-0.5*angleK, current.points[current.triangles[i+2]]);
			current.points[current.triangles[i+1]].rotateBy(angle_dif3*0.5*angleK, current.points[current.triangles[i+2]]);
		}

		//}



	}

	current.calculateLengths();

	int num_edges = (int)current.edges.size();
	for(i=0; i<num_edges; i+=2)
	{


		dist_dif = source.lengths[i/2] - current.lengths[i/2];


		delta = current.edgevectors[i/2];

		current.points[current.edges[i]] += delta * (dist_dif * 0.5 * lenK);
		current.points[current.edges[i+1]] += delta * (dist_dif * -0.5 * lenK);


	}



}

/*
		// 1
		delta = current.points[current.triangles[i]] - current.points[current.triangles[i+1]];
		dist = delta.getLength();
		dist_src = (source.points[source.triangles[i]] - source.points[source.triangles[i+1]]).getLength();

		dist_dif = dist_src - dist;

		if(bFlip)
			dist_dif = -(dist);

		current.points[current.triangles[i]] += delta * (dist_dif * 0.5 * lenK);
		current.points[current.triangles[i+1]]  += delta * (dist_dif * -0.5 * lenK);

		// 2
		delta = current.points[current.triangles[i+1]] - current.points[current.triangles[i+2]];
		dist = delta.getLength();
		dist_src = (source.points[source.triangles[i+1]] - source.points[source.triangles[i+2]]).getLength();

		dist_dif = dist_src - dist;

		if(bFlip)
			dist_dif = -(dist);

		current.points[current.triangles[i+1]] += delta * (dist_dif * 0.5 * lenK);
		current.points[current.triangles[i+2]]  += delta * (dist_dif * -0.5 * lenK);

		// 3
		delta = current.points[current.triangles[i+2]] - current.points[current.triangles[i]];
		dist = delta.getLength();
		dist_src = (source.points[source.triangles[i+2]] - source.points[source.triangles[i]]).getLength();

		dist_dif = dist_src - dist;

		if(bFlip)
			dist_dif = -(dist);

		current.points[current.triangles[i+2]] += delta * (dist_dif * 0.5 * lenK);
		current.points[current.triangles[i]]  += delta * (dist_dif * -0.5 * lenK);
 */