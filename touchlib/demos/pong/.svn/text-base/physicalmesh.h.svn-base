#ifndef __TOUCHLIB_PHYSICALMESH__
#define __TOUCHLIB_PHYSICALMESH__


#include "mesh2d.h"


class PhysicalMesh
{
public:
	PhysicalMesh();

	void readFile(char *szfile);

	int findClosestPoint(touchlib::vector2df &pt);

	// sets the position of a point
	void setPoint(int p, touchlib::vector2df &to);

	void update();

	touchlib::mesh2df current;
	touchlib::mesh2df source;
private:


	float lenK;
	float angleK;

};

#endif