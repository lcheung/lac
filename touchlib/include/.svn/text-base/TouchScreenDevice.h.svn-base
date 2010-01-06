#ifndef __TOUCHLIB_TOUCHSCREENDEVICE__
#define __TOUCHLIB_TOUCHSCREENDEVICE__

#include <touchlib_platform.h>
#include <ITouchScreen.h>

namespace touchlib
{
	class CTouchScreen;

	class TOUCHLIB_EXPORT TouchScreenDevice 
	{
	public:
		static ITouchScreen *getTouchScreen();
		static void destroy();
	private:
		static CTouchScreen *tscreen;
	};
}

#endif
