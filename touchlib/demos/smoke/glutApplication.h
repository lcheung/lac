
// Adapted from the public domain glutMaster source written by George Stetten and Korin Crawford
// http://www.stetten.com/george/glutmaster/glutmaster.html


#ifndef __GLUT_APPLICATION__
#define __GLUT_APPLICATION__

#include "glutMaster.h"
#include "TouchScreenDevice.h"
#include "fluid2d.h"
#include <Image.h>
#include <map>

using namespace touchlib;


class glutApplication : public GlutWindow, public ITouchListener
{
public:

	glutApplication(GlutMaster* setGlutMaster, int setWidth, int setHeight, int setInitPositionX, int setInitPositionY, ITouchScreen* screen, Fluid2D* fluid, char* title);
	~glutApplication();

	void CallBackDisplayFunc(void);
	void CallBackKeyboardFunc(unsigned char key, int x, int y);
	void SetScreen(ITouchScreen* setScreen);
	void CallBackReshapeFunc(int w, int h);   
	void CallBackIdleFunc(void);
	void DrawField(void);
	void StartSpinning(GlutMaster * glutMaster);
	void fingerDown(TouchData data);
	void fingerUpdate(TouchData data);
	void fingerUp(TouchData data);
	void draw();

private:

	GlutMaster* glutMaster;

	int height, width;
	int initPositionX, initPositionY;
	int drawvelocities;
	int wireframe;
	int drawfingers;

	ITouchScreen* screen;
	Fluid2D* fluid;

	typedef std::map<int, RgbPixelFloat> ColorMap;
	ColorMap colormap;

	typedef std::map<int, TouchData> FingerMap;
	FingerMap fingermap;

	std::string bgLabel;
};


#endif
