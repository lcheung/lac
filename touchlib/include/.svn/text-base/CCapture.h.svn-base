#ifndef __TOUCHLIB_CCAPTURE__
#define __TOUCHLIB_CCAPTURE__

#include <cv.h>
#include <cxcore.h>
#include <highgui.h>

#include "BrightnessContrastFilter.h"
#include "Image.h"
#include <touchlib_platform.h>

// Ideally this class should encapsulate all the OpenCV related stuff
// In order to this we will need to break the dependence in Image.h on openCV
// we'll do this later if we find we want to support other image libraries than OpenCV.

namespace touchlib 
{
	class TOUCHLIB_CORE_EXPORT CCapture
	{
	public:
		CCapture();
		~CCapture();
		virtual IBwImage *getFrame();

	private:
		BrightnessContrastFilter* bcfilter;
		CvCapture* capture;

	    IplImage *bwimg;
		BwImage frame;

	};
}

#endif
