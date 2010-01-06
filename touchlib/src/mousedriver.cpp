#pragma once
#define WIN32_LEAN_AND_MEAN 
#define _WIN32_WINNT  0x0500

#include <windows.h>

#include <cv.h>
#include <cxcore.h>
#include <highgui.h>
#include <map>

#include <tchar.h>


#pragma comment( lib, "user32" )

#include "TouchScreenDevice.h"
#include "TouchData.h"

using namespace touchlib;

#include <stdio.h>

#include <cvcam.h>


static bool keystate[256];
bool ok=true;
ITouchScreen *screen;



class TestApp : public ITouchListener
{
public:
	TestApp()
	{
	}

	~TestApp()
	{

	}

	//! Notify that a finger has just been made active. 
	virtual void fingerDown(TouchData data)
	{
		//fingerList[data.ID] = FingerElement(colors[0], data);
		
		printf("Press detected: %f, %f\n", data.X, data.Y);

			INPUT aInput;

		aInput.type = INPUT_MOUSE;
		aInput.mi.dwFlags = MOUSEEVENTF_LEFTDOWN | MOUSEEVENTF_ABSOLUTE | MOUSEEVENTF_MOVE;
		aInput.mi.dwExtraInfo = 0;
		aInput.mi.mouseData = 0;
		aInput.mi.time = 0;
		aInput.mi.dx = (data.X * 65535.0f);
		aInput.mi.dy = (data.Y * 65535.0f);

		int aResult = SendInput(1, &aInput, sizeof(INPUT) );
		
	}

	//! Notify that a finger has moved 
	virtual void fingerUpdate(TouchData data)
	{
		//fingerList[data.ID].data = data;

			INPUT aInput;

			aInput.type = INPUT_MOUSE;
			aInput.mi.dwFlags = MOUSEEVENTF_ABSOLUTE | MOUSEEVENTF_MOVE;
			aInput.mi.dwExtraInfo = 0;
			aInput.mi.mouseData = 0;
			aInput.mi.time = 0;
			aInput.mi.dx = (data.X * 65536.0f);
			aInput.mi.dy = (data.Y * 65535.0f);

			int aResult = SendInput(1, &aInput, sizeof(INPUT) );
		
	}

	//! A finger is no longer active..
	virtual void fingerUp(TouchData data)
	{
		INPUT aInput;

		aInput.type = INPUT_MOUSE;
		aInput.mi.dwFlags = MOUSEEVENTF_LEFTUP;
		aInput.mi.dwExtraInfo = 0;
		aInput.mi.mouseData = 0;
		aInput.mi.time = 0;
		int aResult = SendInput(1, &aInput, sizeof(INPUT) );

	}

private:
	//std::map<int, FingerElement> fingerList;

};



TestApp app;

int _tmain(int argc, char * argv[])
{
	screen = TouchScreenDevice::getTouchScreen();
	cvNamedWindow( "mywindow", CV_WINDOW_AUTOSIZE );

	screen->setDebugMode(false);
	std::string recLabel,bgLabel;
	if(!screen->loadConfig("config.xml"))
	{
		std::string capLabel = screen->pushFilter("dsvlcapture");
		screen->pushFilter("mono");
		screen->pushFilter("smooth");
		bgLabel = screen->pushFilter("backgroundremove");

		std::string bcLabel = screen->pushFilter("brightnesscontrast");
		recLabel = screen->pushFilter("rectify");

		screen->setParameter(recLabel, "level", "25");

		screen->setParameter(capLabel, "source", "cam");
		//screen->setParameter("capture1", "source", "../tests/simple-2point.avi");
		//screen->setParameter("capture1", "source", "../tests/hard-5point.avi");

		screen->setParameter(bcLabel, "brightness", "0.1");
		screen->setParameter(bcLabel, "contrast", "0.4");

		screen->saveConfig("config.xml");
	}else{
		recLabel = screen->findFirstFilter("rectify");				
		bgLabel = screen->findFirstFilter("backgroundremove");		
	}

	screen->registerListener((ITouchListener *)&app);
	// Note: Begin processing should only be called after the screen is set up

	screen->beginProcessing();
	
	SLEEP(1000);
	screen->setParameter(bgLabel, "mask", (char*)screen->getCameraPoints());
	screen->setParameter(bgLabel, "capture", "");
	screen->beginTracking();

	do
	{
		//printf("Doing keypress\n");
		int keypressed = cvWaitKey(16) & 255;

		if(keypressed != 255 && keypressed > 0)
			printf("KP: %d\n", keypressed);
        if( keypressed == 27) break;		// ESC = quit
        if( keypressed == 98)				// b = recapture background
		{
			screen->setParameter(bgLabel, "capture", "");
			//app.clearFingers();
		}
        if( keypressed == 114)				// r = auto rectify..
		{
			screen->setParameter(recLabel, "level", "auto");
		}

  		screen->getEvents();
		SLEEP(16);

	} while( ok );
	cvDestroyWindow( "mywindow" );
	//screen->saveConfig("config.xml");
	TouchScreenDevice::destroy();
	return 0;
}