#ifndef __TOUCHLIB_ITOUCHEVENTLISTENER__
#define __TOUCHLIB_ITOUCHEVENTLISTENER__

#include <touchlib_platform.h>
#include "ITouchEvent.h"

namespace touchlib 
{
	//! Clients should implement this class
	class TOUCHLIB_EXPORT ITouchEventListener
	{
	public:
		//! Notify that a finger has just been made active. 
		virtual void fingerDown(ITouchEvent *Event) = 0;

		//! Notify that a known finger has been moved 
		virtual void fingerUpdate(ITouchEvent *Event) = 0;

		//! Notify that a previously known finger is no longer active..
		virtual void fingerUp(ITouchEvent *Event) = 0;
	};
}

#endif  // __TOUCHLIB_ITOUCHEVENTLISTENER__
