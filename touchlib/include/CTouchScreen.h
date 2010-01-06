#ifndef __TOUCHLIB_CTOUCHSCREEN__
#define __TOUCHLIB_CTOUCHSCREEN__

#include "ITouchScreen.h"
#include "ITouchEvent.h"
#include "TouchlibFilter.h"
#include "ITouchListener.h"
#include "mesh2d.h"
#include "IBlobTracker.h"


#include <vector>

namespace touchlib
{

	class CTouchEvent : public ITouchEvent
	{
	};

	class TimeoutExcp
	{
	};
//
	class TOUCHLIB_EXPORT CTouchScreen : public ITouchScreen, public ITouchListener
	{
	public:
		CTouchScreen();
		~CTouchScreen();

// ITouchScreen

		//! A client registers itself as a listener for touch events
		virtual void registerListener(ITouchListener *listener);

		// capture the frame and do the detection
		virtual bool process();

		// Gets the raw camera output
		virtual void getRawImage(char **img, int &width, int &height);

		// add a new filter on the end of the chain
		virtual std::string pushFilter(const char *type, const char * label = 0);

		//! find instances of filters in the chain
		virtual std::list<std::string> findFilters(const char *type);

		//! find first instance of a filter in the chain
		virtual std::string findFirstFilter(const char * type);

		//! load the filter graph from file
		virtual bool loadConfig(const char* filename);

		//! save the filter graph to file
		virtual void saveConfig(const char* filename);

		// set a filter parameter
		virtual void setParameter(std::string & label, char *param, char *value);

		// start the processing and video capturing
		virtual void beginProcessing();

		//! toggles displaying of debug info.
		// FIXME: if filters are already set up, then we should open their windows.
		virtual void setDebugMode(bool m) { debugMode = m; };

		//! get events
		virtual void getEvents();

		//! starts calibration
		virtual void beginCalibration();

		//! goes to the next step
		virtual void nextCalibrationStep();

		//! return to the last step
		virtual void revertCalibrationStep();

		//! 
		virtual float getScreenScale();
		virtual rect2df getScreenBBox() { return screenBB; };


		virtual void setScreenScale(float s);
		virtual void setScreenBBox(rect2df & bbox);


		virtual vector2df *getScreenPoints() { return screenPoints; };
		virtual vector2df *getCameraPoints() { return cameraPoints; };

		// start the processing and video capturing
		virtual void beginTracking() { bTracking = true; };

		// get an image from the filter chain
		virtual IplImage* getFilterImage(std::string & label);
		virtual IplImage* getFilterImage(int step);


		void setBlobTracker(IBlobTracker* blobTracker);

// ITouchListener
		//! Notify that a finger has just been made active. 
		virtual void fingerDown(TouchData data);

		//! Notify that a finger has moved. 
		virtual void fingerUpdate(TouchData data);

		//! A finger is no longer active..
		virtual void fingerUp(TouchData data);


//////////

		static THREAD_RETURN_TYPE _processEntryPoint(void*);

		void cameraToScreenSpace(float &x, float &y);
		void transformDimension(float &width, float &height, float centerX, float centerY);

		void initScreenPoints();
		void initCameraPoints();
	
		// returns -1 if none found..
		int findTriangleWithin(vector2df pt);



	private:
		void doTouchEvent(TouchData data);
		void doUpdateEvent(TouchData data);
		void doUntouchEvent(TouchData data);

		bool debugMode;
		bool volatile bTracking;

		static THREAD_HANDLE hThread;
		static THREAD_MUTEX_HANDLE eventListMutex;


		IBlobTracker* tracker;

		bool bCalibrating;		
		int calibrationStep;


#ifdef WIN32
#pragma warning( disable : 4251 )  // http://www.unknownroad.com/rtfm/VisualStudio/warningC4251.html
#endif

		BwImage frame;
		BwImage labelImg;

		int reject_distance_threshold;
		int reject_min_dimension;
		int reject_max_dimension;
		int ghost_frames;
		float minimumDisplacementThreshold;

		// FIXME: later we may consider a denser mesh, but for now we'll consider
		// the simpler case.
		vector2df screenPoints[GRID_POINTS];		// GRID_X * GRID_Y
		vector2df cameraPoints[GRID_POINTS];		// GRID_X * GRID_Y
		int triangles[GRID_INDICES];				// GRID_X * GRID_Y * 2t * 3i indices for the points

		rect2df screenBB;
		mesh2df screenMesh;

		std::vector<Filter *> filterChain;
		std::map<std::string,Filter*> filterMap;
		std::vector<ITouchListener *> listenerList;
		std::vector<ITouchEvent> eventList;

#ifdef WIN32
#pragma warning( default : 4251 )
#endif

	};
}

#endif
