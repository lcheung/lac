#ifndef __TOUCHLIB_ITOUCHSCREEN__
#define __TOUCHLIB_ITOUCHSCREEN__

#include "ITouchListener.h"
#include "ITouchEvent.h"
#include "IBlobTracker.h"

#include "Image.h"
#include "vector2d.h"
#include "mesh2d.h"
#include <list>

namespace touchlib
{
	#define GRID_X	4
	#define GRID_Y	3
	#define GRID_POINTS	((GRID_X+1) * (GRID_Y+1))
	#define GRID_INDICES (GRID_X * GRID_Y * 3 * 2)

	class TOUCHLIB_EXPORT ITouchScreen
	{
	public:
		//! A client registers itself as a listener for touch events
		virtual void registerListener(ITouchListener *listener) = 0;

		//! capture the frame and do the detection
		virtual bool process() = 0;

		//! Gets the raw camera output
		virtual void getRawImage(char **img, int &width, int &height) = 0;

		//! add a new filter on the end of the chain
		virtual std::string pushFilter(const char *type, const char * label = 0) = 0;

		//! find instances of filters in the chain
		virtual std::list<std::string> findFilters(const char *type) = 0;

		//! find first instance of a filter in the chain
		virtual std::string findFirstFilter(const char * type) = 0;

		//! load the filter graph from file
		virtual bool loadConfig(const char* filename) = 0;

		//! save the filter graph to file
		virtual void saveConfig(const char* filename) = 0;

		//! set a filter parameter
		virtual void setParameter(std::string & label, char *param, char *value) = 0;

		// get an image from the filter chain
		virtual IplImage* getFilterImage(std::string & label) = 0;
		virtual IplImage* getFilterImage(int step) = 0;


		//! start the processing and video capturing
		virtual void beginProcessing() = 0;

		//! toggles displaying of debug info.
		virtual void setDebugMode(bool m) = 0;

		//! get events
		virtual void getEvents() = 0;

		//! starts calibration
		virtual void beginCalibration() = 0;

		//! goes to the next step
		virtual void nextCalibrationStep() = 0;

		//! return to the last step
		virtual void revertCalibrationStep() = 0;

		//!
		virtual float getScreenScale() = 0;
		virtual rect2df getScreenBBox() = 0;

		//! access calibration data.. this may get refactored.
		virtual void setScreenScale(float s) = 0;
		virtual void setScreenBBox(rect2df & bbox) = 0;

		virtual vector2df *getScreenPoints() = 0;
		virtual vector2df *getCameraPoints() = 0;

		// start the processing and video capturing
		virtual void beginTracking() = 0;

		/**
		 * Sets the blob tracker.
		 */
		virtual void setBlobTracker(IBlobTracker* blobTracker) = 0;
	};

}

#endif  // __TOUCHLIB_ITOUCHSCREEN__
