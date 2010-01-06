
#ifdef WIN32
#pragma once
#define WIN32_LEAN_AND_MEAN 
#define _WIN32_WINNT  0x0500
#endif

#include <map>
#include <cv.h>
#include <highgui.h>

#include "TouchScreenDevice.h"
#include "TouchData.h"

using namespace touchlib;

#include <stdio.h>
#include <string>


ITouchScreen *screen;


///////////////////////////////////////////////////////////////


class TouchApp : public ITouchListener
{
public:


	TouchApp()
	{

	}

	~TouchApp()
	{

	}

	//! Notify that a finger has just been made active. 
	virtual void fingerDown(TouchData data)
	{
		fprintf(stderr,"Press detected: ID: %d %f, %f\n", data.ID, data.X, data.Y);

	}

	//! Notify that a finger has moved 
	virtual void fingerUpdate(TouchData data)
	{
		// 		fprintf(stderr,"Move detected: ID %d %f %f, %f %f\n",data.ID,data.X,data.Y, data.dX,data.dY);

	}

	//! A finger is no longer active..
	virtual void fingerUp(TouchData data)
	{
		fprintf(stderr,"Finger Up: ID %d %f %f\n",data.ID,data.X,data.Y);
	}

};

/////////////////////////////////////////////////////////////////////////

TouchApp app;
bool ok=true;


int main(int argc, char * argv[])
{

	char * config = "config.xml";
	// Check if command arguments are specified
	if (argc == 2)
		config = argv[1];
	
	screen = TouchScreenDevice::getTouchScreen();
	//screen->setDebugMode(false);
	if(!screen->loadConfig(config))
	{
		screen->pushFilter("dsvlcapture", "capture1");
		screen->pushFilter("mono", "mono2");
		screen->pushFilter("smooth", "smooth3");
		screen->pushFilter("backgroundremove", "background4");

		screen->pushFilter("brightnesscontrast", "bc5");
		screen->pushFilter("rectify", "rectify6");
		
		std::string rectify6 = "rectify6";
		screen->setParameter(rectify6, "level", "25");
		std::string capture1 = "capture1";
		screen->setParameter(capture1, "source", "cam");
		
		std::string bc5 = "bc5";
		screen->setParameter(bc5, "brightness", "0.1");
		screen->setParameter(bc5, "contrast", "0.4");

	}

	screen->registerListener((ITouchListener *)&app);
	// Note: Begin processing should only be called after the screen is set up
	//

	 SLEEP(200);
	 
	 std::string background4 = "background4";
	 screen->setParameter(background4, "capture", "");


	screen->beginProcessing();
	screen->beginTracking();

	do
	{

		int keypressed = cvWaitKey(32) & 255;

		if(keypressed != 255 && keypressed > 0)
			fprintf(stderr,"KP: %d\n", keypressed);
        if( keypressed == 27) break;		// ESC = quit
        if( keypressed == 98)				// b = recapture background
		{
			screen->setParameter(background4, "capture", "");
			
		}
        if( keypressed == 114)				// r = auto rectify..
		{
			std::string rectify6 = "rectify6";
			screen->setParameter(rectify6, "level", "auto");
		}

		screen->getEvents();



	} while( ok );


	TouchScreenDevice::destroy();
	return 0;
}
