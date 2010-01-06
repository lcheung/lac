
#ifndef __TOUCHLIB_ITOUCHEVENT__
#define __TOUCHLIB_ITOUCHEVENT__

#include <touchlib_platform.h>

#include <TouchData.h>

enum touchEventType
{
	TOUCH_PRESS=0,
	TOUCH_UPDATE,
	TOUCH_RELEASE
};


class ITouchEvent
{
public:

	touchEventType type;
	TouchData data;

};

#endif  // __TOUCHLIB_ITOUCHEVENT__
