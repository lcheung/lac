// Simple test application.

#include <cv.h>
#include <cxcore.h>
#include <highgui.h>
#include <map>

#include <glut.h>

#ifdef WIN32
	#include <tchar.h>
	
	#pragma comment( lib, "glut32" )
#endif

#include "TouchScreenDevice.h"
#include "TouchData.h"
#include "mesh2d.h"
#include "physicalmesh.h"

using namespace touchlib;

#include <stdio.h>
#include <string>

#ifdef WIN32
#include <cvcam.h>
#endif

#include <textures.h>

void glutDrawCircle(float x, float y, float rad, float r, float g, float b);
void glutDrawBox(float x1, float y1, float x2, float y2, float r, float g, float b);
void glutDrawPlus(float x1, float y1, float s, float r, float g, float b);
void glutDrawMesh(mesh2df &mesh, COGLTexture &texture);

static bool keystate[256];
ITouchScreen *screen;
std::string backgroundLabel;

int screenWidth=1278, screenHeight=1024;

/////////////////////////////////////////////////////

class FingerElement
{
public:
	FingerElement()
	{
	}
	FingerElement(RgbPixel c, TouchData d)
	{
		color = c;
		data = d;

	}
	RgbPixel color;
	TouchData data;
	void draw()
	{
		float rad = 10;

		float X = (data.X*2.0f) - 1.0;
		float Y = (data.Y*2.0f) - 1.0;

		glutDrawBox(X-rad, Y-rad, X+rad, Y+rad, (float)color.r/255.0f, (float)color.g/255.0f, (float)color.b/255.0f);


	}
};

///////////////////////////////////////////////////////////////////////

void replaceExt(char *fname, char *ext)
{
	int i;

	int len = strlen(fname);
	for(i=0; i<3; i++)
	{
		fname[len - 3 + i] = ext[i];

	}
}

///////////////////////////////////////////////////////////////////////

// a mesh object that can be manipulated in a multitouch fashion
// translated, rotated, scaled. sheared?
// We could re-create the photo album with this class (if meshes could do bitmap graphics - to be added soon).
// or just allow simple manipulations of shapes.
class PhysicalMeshObj
{
public:
	PhysicalMeshObj()
	{
		myMesh.current.scale = vector2df(0.3, 0.3);
		myMesh.current.position = vector2df(0.3, -0.1);
		myMesh.current.rotation = 0.0f;
	}

	void readFile(char *szfile)
	{
		myMesh.readFile(szfile);

		replaceExt(szfile, "bmp");
		myTexture.LoadFromFile(szfile);
	}

	void fingerDown(FingerElement *f)
	{

		vector2df pos((f->data.X*2.0) - 1.0, (f->data.Y*2.0)-1.0);

		int t = myMesh.current.findTriangleWithin(pos);
		if(t != -1)
		{
			fingerList.push_back(f);
			printf("Got a click! %d", f->data.ID);
			attachedPoint.push_back(myMesh.findClosestPoint(pos));
		}
	
	}

	void fingerUp(FingerElement *f)
	{
		// remove from list or react.. 
		int i;

		for(i=0; i<fingerList.size(); i++)
		{
			if(fingerList[i] == f)
			{
				printf("Finger removed");
				fingerList.erase(fingerList.begin() + i);
				attachedPoint.erase(attachedPoint.begin() + i);
				return;
			}
		}
	}

	void update()
	{
		

		//if(fingerList.size() == 1)
		//{
			//vector2df pt (fingerList[0]->data.dX, fingerList[0]->data.dY);
			//myMesh.source.position += pt;


			//myMesh.current = myMesh.source;
			//return;
		//}

		//myMesh.current = myMesh.source;

		int i;


		for(int n=0; n<25; n++)
		{
			for(i=0; i<fingerList.size(); i++)
			{
				FingerElement *f = fingerList[i];

				vector2df pos((f->data.X*2.0) - 1.0, (f->data.Y*2.0)-1.0);

				myMesh.setPoint(attachedPoint[i], pos);

				//pos = myMesh.current.transformToLocal(pos);
				//myMesh.current.points[attachedPoint[i]] = pos.getInterpolated( myMesh.source.points[attachedPoint[i]], (float)n/25.0f);
			}
			myMesh.update();
		}
	}

	void draw()
	{
		glutDrawMesh(myMesh.current, myTexture);
	}

private:
	PhysicalMesh myMesh;
	COGLTexture myTexture;
	// The list of fingers that are interacting with this object..
	std::vector<FingerElement *> fingerList;
	std::vector<int> attachedPoint;
};



///////////////////////////////////////////////////////////////////////

// a mesh object that can be manipulated in a multitouch fashion
// translated, rotated, scaled. sheared?
// We could re-create the photo album with this class (if meshes could do bitmap graphics - to be added soon).
// or just allow simple manipulations of shapes.
class MeshObj
{
public:
	MeshObj()
	{
		myMesh.scale = vector2df(0.25, 0.25);
		myMesh.position = vector2df(0.3, -0.1);
		myMesh.rotation = 30.0f;
	}

	void readFile(char *szfile)
	{
		myMesh.readOBJFile(szfile);

		replaceExt(szfile, "bmp");
		myTexture.LoadFromFile(szfile);
	}

	void fingerDown(FingerElement *f)
	{
		// check to see whether this finger is touching
		// this object. If it is, add it to the list
		vector2df pos((f->data.X*2.0) - 1.0, (f->data.Y*2.0)-1.0);

		int t = myMesh.findTriangleWithin(pos);
		if(t != -1)
		{
			fingerList.push_back(f);
			printf("Got a click! %d", f->data.ID);
		}
	}

	void fingerUp(FingerElement *f)
	{
		// remove from list or react.. 
		int i;

		for(i=0; i<fingerList.size(); i++)
		{
			if(fingerList[i] == f)
			{
				printf("Finger removed");
				fingerList.erase(fingerList.begin() + i);
				return;
			}
		}
	}

	void update()
	{
		// look at how the finger positions changed over the last frame
		// to figure out rotation, scale changes.

		// If one point, we can only do translate
		// if two points we can do scale, translate, rotate
		// ignore any more than 2 points (use first two) 

		// look at dX and dY to figure out what the last positions were.

		vector2df translation(0.0, 0.0);
		float rotation = 0.0;
		vector2df scale(1.0, 1.0);

		if(fingerList.size() == 1)
		{
			translation.X = fingerList[0]->data.dX;
			translation.Y = fingerList[0]->data.dY;
		} else if(fingerList.size() >= 2)
		{
			vector2df A,B,C,D;

			// two 'lines'.. AB and CD
			// CD = last frame.. 

			A = vector2df(fingerList[0]->data.X, fingerList[0]->data.Y);
			B = vector2df(fingerList[1]->data.X, fingerList[1]->data.Y);

			C = A - vector2df(fingerList[0]->data.dX, fingerList[0]->data.dY);
			D = B - vector2df(fingerList[1]->data.dX, fingerList[1]->data.dY);

			vector2df mid1, mid2;

			mid1 = (A + B) * 0.5;
			mid2 = (C + D) * 0.5;

			translation = mid1 - mid2;

			vector2df AB, CD;

			AB = (A-B);
			CD = (C-D);

			
			float s = AB.getLength() / CD.getLength();

			//s = sqrtf(s);
			s = powf(s, 0.25f);

			scale = vector2df(s, s);

			rotation = AB.getAngleTrig() - CD.getAngleTrig();
			rotation *= 0.5;

			//myMesh.offset = mid2 - (myMesh.position + translation);
		}

		myMesh.position += translation;
		myMesh.scale *= scale;
		myMesh.rotation += rotation;

		if(myMesh.scale.X < 0.01)
			myMesh.scale.X = 0.01;
		if(myMesh.scale.Y < 0.01)
			myMesh.scale.Y = 0.01;



	}

	void draw()
	{
		glutDrawMesh(myMesh, myTexture);
	}

private:
	mesh2df myMesh;
	COGLTexture myTexture;
	// The list of fingers that are interacting with this object..
	std::vector<FingerElement *> fingerList;

};

class BallObj
{
public:
	BallObj()
	{
		radius = 0.05;
	}

	void setup(vector2df &pos, vector2df &vel)
	{
		position = pos;
		velocity = vel;
	}
	// clip
	bool collideWith(BallObj &other)
	{
		// distance
		float dist = position.getDistanceFrom(other.position);
		if(dist < (radius + other.radius))
		{
			float dif = (radius + other.radius) - dist;
			vector2df delta = other.position - position;
			position -= delta * (dif * 0.5);
			other.position += delta * (dif * 0.5);
			// * dot product of velocities
			velocity -= delta * (velocity.getLength() + other.velocity.getLength());
			other.velocity += delta * (velocity.getLength() + other.velocity.getLength());
			return true;
		} else
			return false;
	}

	void update()
	{
 		float scale = screen->getScreenScale();

		// check for collisions with outside edge too.. 
		position += velocity;

		if(position.X > 1.0f * scale) 
		{
			position.X = 1.0f * scale;
			velocity.X *= -1.0f;
		}
		if(position.Y > 1.0f * scale) 
		{
			position.Y = 1.0f * scale;
			velocity.Y *= -1.0f;
		}
		if(position.X < -1.0f * scale) 
		{
			position.X = -1.0f * scale;
			velocity.X *= -1.0f;
		}
		if(position.Y < -1.0f * scale) 
		{
			position.Y = -1.0f * scale;
			velocity.Y *= -1.0f;
		}

		velocity *= 0.999f;

		
	}

	void applyForce(vector2df center, vector2df force)
	{

		float dist = position.getDistanceFrom(center);

		if(dist < radius * 2.0)
		{
	
			velocity += force * 0.2;
				/// ((dist * dist) + 1.0f));
		}
	}
	void draw()
	{
		glutDrawCircle(position.X, position.Y, radius, 0.8, 0.0, 0.0);
	}

	vector2df position;
	vector2df velocity;
private:
	float radius;

};

void print_bitmap_string(float x, float y, char* s)
{
   glClearColor(0.0, 0.0, 0.0, 0.0);
   glColor4f(1.0, 1.0, 1.0, 1.0);
   glRasterPos2f(x, y);

   if (s && strlen(s)) {
      while (*s) {
         glutBitmapCharacter(GLUT_BITMAP_HELVETICA_18, *s);
         s++;
      }
   }
}


///////////////////////////////////////////////////////////////

class PongApp : public ITouchListener
{
public:
	PongApp()
	{
		score1 = 0;
		score2 = 0;

	}

	~PongApp()
	{
	}

	void glInit()
	{
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);

		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST_MIPMAP_NEAREST);

		char szfile[] = "../media/2dtest.obj";
		//testObj.readFile(szfile);
 		float scale = screen->getScreenScale();
		goal1 = rect2df(vector2df(-1,-0.25)*scale, vector2df(-0.95,0.25)*scale);
		goal2 = rect2df(vector2df(0.95,-0.25)*scale, vector2df(1.0,0.25)*scale);



		glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_REPLACE);
	}

	//! Notify that a finger has just been made active. 
	virtual void fingerDown(TouchData data)
	{
		RgbPixel c;
		c.r = 255;
		c.g = 255;
		c.b = 255;

		fingerList[data.ID] = FingerElement(c, data);
		
		printf("Press detected: %f, %f\n", data.X, 1.0-data.Y);

		//testObj.fingerDown(&fingerList[data.ID]);
	}

	//! Notify that a finger has moved 
	virtual void fingerUpdate(TouchData data)
	{
		fingerList[data.ID].data = data;

		vector2df pos(data.X, 1.0-data.Y);
		vector2df dir(data.dX, 1.0-data.dY);

		pos *= 2.0;
		pos -= vector2df(1.0, 1.0);

		testball.applyForce(pos, dir);

	}

	//! A finger is no longer active..
	virtual void fingerUp(TouchData data)
	{
		//testObj.fingerUp(&fingerList[data.ID]);

		std::map<int, FingerElement>::iterator iter;


		for(iter=fingerList.begin(); iter != fingerList.end(); iter++)
		{
			if(iter->second.data.ID == data.ID)
			{
				fingerList.erase(iter);

				return;
			}
		}


	}

	void clearFingers()
	{
		fingerList.clear();
	}

	void resetBall()
	{
		testball.position = vector2df(0,0);
		testball.velocity = vector2df(0,0);
	}

	void draw()
	{
 		float scale = screen->getScreenScale();
		//testObj.update();
		testball.update();

		glutDrawBox(-(1.0f * (scale)), -(1.0f * (scale)), (1.0f * (scale)), (1.0f * (scale)), 0.0, 0.2, 0.0);

		glutDrawBox(goal1.upperLeftCorner.X, goal1.upperLeftCorner.Y, goal1.lowerRightCorner.X, goal1.lowerRightCorner.Y, 1.0, 1.0, 0.0);
		glutDrawBox(goal2.upperLeftCorner.X, goal2.upperLeftCorner.Y, goal2.lowerRightCorner.X, goal2.lowerRightCorner.Y, 1.0, 1.0, 0.0);


		// check for goals.. increment score.. show score. 

		if(goal1.isPointInside(testball.position))
		{
			score2++;
			resetBall();
		}
		if(goal2.isPointInside(testball.position))
		{
			score1++;
			resetBall();
		}

		char scorestr[255];

		sprintf(scorestr, "%d   %d", score1, score2);

		print_bitmap_string(0, -0.8, scorestr);


		glutDrawBox(-(1.0f * (scale)), -(1.0f * (scale)), (1.0f * (scale)), (1.0f * (scale)), 0.0, 0.2, 0.0);

		vector2df *screenpts = screen->getScreenPoints();

		/*
		int i;
		for(i=0; i<GRID_POINTS; i++)
		{
			glutDrawPlus((screenpts[i].X*2.0f)-1.0f, (screenpts[i].Y*2.0f)-1.0f, 0.02, 0.0, 1.0, 0.0);
		}
		*/

		std::map<int, FingerElement>::iterator iter;

		for(iter=fingerList.begin(); iter != fingerList.end(); iter++)
		{
			iter->second.draw();
		}
		testball.draw();
		//testObj.draw();
		
	}
private:
	// Keep track of all finger presses.
	std::map<int, FingerElement> fingerList;

	//PhysicalMeshObj testObj;
	//MeshObj testObj;
	BallObj testball;
	rect2df goal1;
	rect2df goal2;

	int score1;
	int score2;
};

/////////////////////////////////////////////////////////////////////////

PongApp app;

void glutKeyboardUpCallback( unsigned char key, int x, int y )
{
    printf( "keyup=%i\n", key );
    keystate[key] = false;
}


void glutKeyboardCallback( unsigned char key, int x, int y )
{
    printf( "keydn=%i\n", key );
    keystate[key] = true;

	if(key == 27)			// esc
	{
		glutLeaveGameMode();
		screen->saveConfig("config.xml");
		TouchScreenDevice::destroy();
		exit(1);
	}
    else if( key == 98)				// b = recapture background
	{		
		if(backgroundLabel.size() == 0){
				printf("ERROR: no background filter defined\n");
		}else{
			screen->setParameter(backgroundLabel, "capture", "");
			app.clearFingers();
		}
	}
}

////////////////////////////
// Some glut helper functions.. we may want to move these to a separate c file.

// FIXME: we need to be able to do textured meshes too.

void glutDrawMesh(mesh2df &mesh, COGLTexture &texture)
{


	unsigned int num_tris = mesh.triangles.size();
	unsigned int vertex;
	unsigned int num_edges = mesh.edges.size();

	unsigned int i;

	// FIXME: correct for aspect ratio..

	glEnable(GL_TEXTURE_2D);

	texture.SetActive();


	glBegin(GL_TRIANGLES);

	for(i=0; i<num_tris; i++)
	{
		vector2df uv = mesh.uv[mesh.uv_triangles[i]];
		glTexCoord2f(uv.X, uv.Y);

		vertex = mesh.triangles[i];
		//glColor3f(mesh.colors[vertex].r, mesh.colors[vertex].g, mesh.colors[vertex].b);

		// transform.
		vector2df p = mesh.points[vertex];
		p += mesh.offset;
		p.rotateBy(mesh.rotation, vector2df(0.0, 0.0));
		p.X *= mesh.scale.X;
		p.Y *= mesh.scale.Y;

		p += mesh.position;
		p -= mesh.offset;

		glVertex2f(p.X, p.Y);

	}
	glEnd();
	glDisable(GL_TEXTURE_2D);
/*
	// draw all the edges (wireframe mode)
	glBegin(GL_LINES);
	glLineWidth(2.0);

	// FIXME: this should only be for debugging? pass a bool.
	for(i=0; i<num_edges; i++)
	{
		vertex = mesh.edges[i];
		glColor3f(1.0, 1.0, 1.0);

		// transform.
		vector2df p = mesh.points[vertex];
		p.rotateBy(mesh.rotation, vector2df(0.0, 0.0));
		p.X *= mesh.scale.X;
		p.Y *= mesh.scale.Y;
		p += mesh.position;

		glVertex2f(p.X, p.Y);
	}

	glEnd();
	*/

}

void glutDrawCircle(float x, float y, float rad, float r, float g, float b)
{
	const int SEGMENTS = 12;
	const float DEG2RAD = 2.0f*3.14159f/(float)SEGMENTS;

	glBegin(GL_LINE_LOOP);
	glColor3f(r, g, b);
	for (int i=0; i < SEGMENTS; i++)
	{
		float degInRad = i*DEG2RAD;
		glVertex2f(x + cosf(degInRad)*rad, y + sinf(degInRad)*rad);  
	}

	glEnd();
}

void glutDrawBox(float x1, float y1, float x2, float y2, float r, float g, float b)
{
	glBegin(GL_LINE_STRIP);
	glLineWidth(2.0);
	glColor3f(r, g, b);

	glVertex2f(x1,y1);
	glColor3f(r, g, b);
	glVertex2f(x2,y1);
	glColor3f(r, g, b);
	glVertex2f(x2,y2);
	glColor3f(r, g, b);
	glVertex2f(x1,y2);
	glColor3f(r, g, b);
	glVertex2f(x1,y1);

	glEnd();
}

void glutDrawPlus(float x1, float y1, float s, float r, float g, float b)
{
	glBegin(GL_LINES);
	//glLineWidth(2.0);

	float sx = s;
	float sy = s;


	glColor3f(r, g, b);
	glVertex2f(x1,y1-sy);
	glColor3f(r, g, b);
	glVertex2f(x1,y1+sy);

	glColor3f(r, g, b);
	glVertex2f(x1-sx,y1);
	glColor3f(r, g, b);
	glVertex2f(x1+sx,y1);

	glEnd();

}

void glutDisplayCallback( void )
{

	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();

	screen->getEvents();
	app.draw();

	glFlush();
	glutSwapBuffers();

	glutPostRedisplay();
}

float mouseX=0.0f, mouseY=0.0f;
void glutMouseCallback(int button, int state, int x, int y)
{


	if(button == GLUT_LEFT_BUTTON)
	{
		TouchData tmp;
		if(state == GLUT_DOWN)
		{

			mouseX = tmp.X = (float)x / (float)screenWidth;
			mouseY = tmp.Y = 1.0 - ((float)y / (float)screenHeight);
			tmp.dX = 0;
			tmp.dY = 0;
			tmp.ID = 1;
			app.fingerDown(tmp);

		}
		if(state == GLUT_UP)
		{


			mouseX = tmp.X = (float)x / (float)screenWidth;
			mouseY = tmp.Y = 1.0 - ((float)y / (float)screenHeight);
			tmp.dX = 0;
			tmp.dY = 0;

			tmp.ID = 1;
			app.fingerUp(tmp);
		}
	}
	printf("Mouse %d/%d, %d/%d\n", x, screenWidth, y, screenHeight);
}

void glutMouseMoveCallback(int x, int y)
{
	TouchData tmp;

	tmp.X = (float)x / (float)screenWidth;
	tmp.Y = 1.0 - ((float)y / (float)screenHeight);
	tmp.dX = tmp.X - mouseX;
	tmp.dY = (tmp.Y - mouseY);

	mouseX = tmp.X;
	mouseY = tmp.Y;


	tmp.ID = 1;
	app.fingerUpdate(tmp);

}


void startGLApp(int argc, char * argv[])
{

	glutInit( &argc, argv );

	// set RGBA mode with double and depth buffers
	glutInitDisplayMode( GLUT_RGB | GLUT_DEPTH | GLUT_DOUBLE);	

	// 640x480, 16bit pixel depth, 60Hz refresh rate
	glutGameModeString( "800x600:16@60" );

	// start fullscreen game mode

	screenWidth = glutGameModeGet(GLUT_GAME_MODE_WIDTH);
	screenHeight = glutGameModeGet(GLUT_GAME_MODE_HEIGHT);

	glutEnterGameMode();

	app.glInit();

	// setup callbacks
	glutKeyboardFunc( glutKeyboardCallback );
	glutKeyboardUpFunc( glutKeyboardUpCallback );
	glutDisplayFunc( glutDisplayCallback );
	glutMouseFunc( glutMouseCallback );
	glutMotionFunc( glutMouseMoveCallback );

	screen->beginTracking();

	// enter main loop
	glutMainLoop();

	//screen->saveConfig("config.xml");
	TouchScreenDevice::destroy();
}

#ifdef WIN32
int _tmain(int argc, char * argv[])
#else
int main(int argc, char * argv[])
#endif
{

	screen = TouchScreenDevice::getTouchScreen();
	screen->setDebugMode(false);
	if(!screen->loadConfig("config.xml"))
	{
		std::string label;
		label = screen->pushFilter("dsvlcapture");
		screen->setParameter(label, "source", "cam");
		screen->pushFilter("mono");
		screen->pushFilter("smooth");
		screen->pushFilter("backgroundremove");
		label = screen->pushFilter("brightnesscontrast");
		screen->setParameter(label, "brightness", "0.1");
		screen->setParameter(label, "contrast", "0.4");
		label = screen->pushFilter("rectify");
		screen->setParameter(label, "level", "25");
				
		screen->saveConfig("config.xml");
	}

	backgroundLabel = screen->findFirstFilter("backgroundremove");		
	
	SLEEP(1000);
	screen->setParameter(backgroundLabel, "mask", (char*)screen->getCameraPoints());
	screen->setParameter(backgroundLabel, "capture", "");
	
	screen->registerListener((ITouchListener *)&app);

	// Note: Begin processing should only be called after the screen is set up
	screen->beginProcessing();

	startGLApp(argc, argv);

	TouchScreenDevice::destroy();
	return 0;
}

