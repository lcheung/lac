#ifndef __TOUCHLIB_ICAPTURE__
#define __TOUCHLIB_ICAPTURE__

#include <Image.h>
#include <touchlib_platform.h>

namespace TOUCHLIB_CORE_EXPORT touchlib 
{
	class ICapture
	{
	public:
		virtual IBwImage *getFrame() = 0;

	};
}

#endif  // __TOUCHLIB_ICAPTURE__
