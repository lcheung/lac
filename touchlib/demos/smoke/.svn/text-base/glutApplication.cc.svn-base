

// Adapted from the public domain glutMaster source written by George Stetten and Korin Crawford
// http://www.stetten.com/george/glutmaster/glutmaster.html

#include <stdlib.h>
#include "glutApplication.h"
#include <iostream>
#include <math.h>
  

glutApplication::glutApplication(GlutMaster* setGlutMaster, int setWidth, int setHeight, int setInitPositionX, int setInitPositionY, ITouchScreen* setScreen, Fluid2D* setFluid, char* title)
{
	glutMaster = setGlutMaster;

	width  = setWidth;               
	height = setHeight;
	initPositionX = setInitPositionX;
	initPositionY = setInitPositionY;

	screen = setScreen;

	screen->registerListener((ITouchListener*)this);
	bgLabel = screen->findFirstFilter("backgroundremove");		

	fluid = setFluid;

	drawvelocities = 0;
	wireframe = 0;
	drawfingers = 1;

	glutInitDisplayMode(GLUT_RGBA | GLUT_DEPTH | GLUT_DOUBLE);
	glutInitWindowSize(width, height);
	glutInitWindowPosition(initPositionX, initPositionY);
	glViewport(0, 0, width, height);   // This may have to be moved to after the next line on some platforms

	glutMaster->CallGlutCreateWindow(title, this);

	glMatrixMode(GL_PROJECTION);
	gluOrtho2D(0.0, (GLfloat)width, 0.0, (GLfloat)height);
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();


}


glutApplication::~glutApplication()
{
	glutDestroyWindow(windowID);
}



void glutApplication::CallBackDisplayFunc(void)
{
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
	DrawField();
	glFlush();
	glutSwapBuffers();
}


void glutApplication::CallBackKeyboardFunc(unsigned char key, int x, int y)
{
	switch( key )
	{
	case 'w': wireframe = 1 - wireframe; break;
	case 'v': drawvelocities = 1 - drawvelocities; break;
	case 'c': drawfingers = 1 - drawfingers; break;
	case 'q': exit(1); break;
	case 'b': screen->setParameter(bgLabel, "capture", ""); fingermap.clear(); break;  // fixme: this is hackish and failure prone
	case 'f': glutFullScreen(); break;
	}
}


void glutApplication::CallBackReshapeFunc(int w, int h)
{
	glViewport(0.0f, 0.0f, (GLfloat)w, (GLfloat)h);
	glMatrixMode(GL_PROJECTION);  
	glLoadIdentity();
	gluOrtho2D(0.0, (GLfloat)w, 0.0, (GLfloat)h);
	width = w;
	height = h;
}


void glutApplication::CallBackIdleFunc(void)
{
	screen->getEvents();
	fluid->Evolve();
	CallBackDisplayFunc();
	SLEEP(1);
}


void glutApplication::StartSpinning(GlutMaster * glutMaster)
{
	glutMaster->SetIdleToCurrentWindow();
	glutMaster->EnableIdleFunction();
}


// Draw the fluid using triangle strips.
void glutApplication::DrawField(void)
{
	int i, j, idx;
	const int n = fluid->getMeshSize();
	fftw_real  wn = (fftw_real)width / (fftw_real)(n - 1);   /* Grid element width */
	fftw_real  hn = (fftw_real)height / (fftw_real)(n - 1);  /* Grid element height */
	float     px, py;

	const fftw_real* r = fluid->getDensityFieldR();
	const fftw_real* g = fluid->getDensityFieldG();
	const fftw_real* b = fluid->getDensityFieldB();
	const fftw_real* u = fluid->getVelocityFieldX();
	const fftw_real* v = fluid->getVelocityFieldY();

	if (wireframe)
	{
		glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
	} else {
		glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
	}

	for (j = 0; j < n - 1; j++)
	{
		glBegin(GL_TRIANGLE_STRIP);

		i = 0;
		px =  (fftw_real)i * wn;
		py = (fftw_real)j * hn;
		idx = (j * n) + i;
		glColor3f(r[idx], g[idx], b[idx]);
		glVertex2f(px, py);

		for (i = 0; i < n - 1; i++) {
			px =(fftw_real)i * wn;
			py =(fftw_real)(j + 1) * hn;
			idx = ((j + 1) * n) + i;
			glColor3f(r[idx], g[idx], b[idx]);
			glVertex2f(px, py);

			px =(fftw_real)(i + 1) * wn;
			py =(fftw_real)j * hn;
			idx = (j * n) + (i + 1);
			glColor3f(r[idx], g[idx], b[idx]);
			glVertex2f(px, py);
		}

		px =(fftw_real)(n - 1) * wn;
		py =(fftw_real)(j + 1) * hn;
		idx = ((j + 1) * n) + (n - 1);
		glColor3f(r[idx], g[idx], b[idx]);
		glVertex2f(px, py);

		glEnd();
	}

	if (drawvelocities)
	{
		glBegin(GL_LINES);
		for (i = 0; i < n; i++) {
			for (j = 0; j < n; j++) {
				idx = (j * n) + i;
				glColor3f(1, 0, 0);
				glVertex2f( (fftw_real)i * wn,  (fftw_real)j * hn);
				glVertex2f(((fftw_real)i * wn) + 1000 * u[idx], ( (fftw_real)j * hn) + 1000 * v[idx]);
			}
		}
		glEnd();
	}

	if( drawfingers )
	{
		const int SEGMENTS = 12;
		const float DEG2RAD = 2*3.14159/SEGMENTS;
		const float RADIUS = 10.0;

		glColor3f(1.0f,1.0f,1.0f);  // white circles

		FingerMap::iterator iter;
		for( iter=fingermap.begin(); iter != fingermap.end(); ++iter )
		{
			int id = (*iter).first;
			TouchData data = (*iter).second;

			glBegin(GL_LINE_LOOP);
 
			for (int i=0; i < SEGMENTS; i++)
			{
				float degInRad = i*DEG2RAD;
				glVertex2f(data.X*width + cos(degInRad)*RADIUS, data.Y*height + sin(degInRad)*RADIUS);  // wasteful to recalculate sin/cos
			}
 
			glEnd();
		}
	}
}


//! Notify that a finger has just been made active. 
void glutApplication::fingerDown(TouchData data)
{
	data.Y = 1.0 - data.Y;
	data.dY = -data.dY;

	// choose random colour for this finger
	RgbPixelFloat cf;
	const float div = 1.0 / (RAND_MAX);	
	cf.r = (float) rand() * div;
	cf.g = (float) rand() * div;
	cf.b = (float) rand() * div;
	colormap[data.ID] = cf;

	// store event
	fingermap[data.ID] = data;

}


//! Notify that a finger has just been made active. 
void glutApplication::fingerUpdate(TouchData data)
{
	data.Y = 1.0 - data.Y;
	data.dY = -data.dY;

	float X = data.X;
	float Y =  data.Y;
	float dX = data.dX;
	float dY = data.dY;

	//std::cout << data.X << "  " << data.Y << "  " << data.dX << "  " << data.dY << "  "  << std::endl;

	dX *= 1000.0;
	dY *= 1000.0;

	fluid->Drag(X, Y, dX, dY, colormap[data.ID].r, colormap[data.ID].g, colormap[data.ID].b );

	// store event (for drawing finger locations)
	fingermap[data.ID] = data;

}


//! A finger is no longer active..
void glutApplication::fingerUp(TouchData data)
{
	colormap.erase( data.ID );
	fingermap.erase( data.ID );
}


void glutApplication::draw()
{
}
