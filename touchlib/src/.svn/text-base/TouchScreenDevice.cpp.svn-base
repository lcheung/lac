#include "TouchScreenDevice.h"
#include <CTouchScreen.h>

using namespace touchlib;

CTouchScreen *TouchScreenDevice::tscreen = 0;

ITouchScreen *TouchScreenDevice::getTouchScreen()
{
	if(!tscreen)
	{
		tscreen = new CTouchScreen();	
	}
	return tscreen;
}

void TouchScreenDevice::destroy()
{

	if(tscreen)
		delete tscreen;
}
