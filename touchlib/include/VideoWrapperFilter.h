#ifndef __TOUCHSCREEN_FILTER_VIDEOWRAPPER__
#define __TOUCHSCREEN_FILTER_VIDEOWRAPPER__

#include <TouchlibFilter.h>

#ifdef WIN32
	#include <dshow.h>
	#include <streams.h>
#endif

#include <VideoWrapper.h>

// FIXME: we should put this in a namespace

class TOUCHLIB_FILTER_EXPORT VideoWrapperFilter : public Filter
{
	public:
		VideoWrapperFilter(char*);
		virtual ~VideoWrapperFilter();
		bool isRunning();
		void kernel();

		virtual void getParameters(ParameterMap& pMap);
		virtual void setParameter(const char *name, const char *value);
	private:
		void init();
		void validate( VWResult result, char* szMsg);

		char videostring[255];

		IplImage capimg;

		VWHVideo g_hVideo;

		int g_nCapWidth;
		int g_nCapHeight;
		int g_nCapDepth;
		VWPixelFormat format;
		IplImage *acquired;


		long _brightness1;
		long _contrast1;
		long _hue1;
		long _saturation1;
		long _gamma1;
		long _colorenable1;
		long _whitebalance1;
		long _backlightcompensation1;
		long _gain1;
		long _exposure1;
		long _iris1;
		long _focus1;
		long _zoom1;
		long _pan1;
		long _tilt1;
		long _shutter1;
		long _trigger_delay1;


		long _brightness2;
		long _contrast2;
		long _hue2;
		long _saturation2;
		long _gamma2;
		long _colorenable2;
		long _whitebalance2;
		long _backlightcompensation2;
		long _gain2;
		long _exposure2;
		long _iris2;
		long _focus2;
		long _zoom2;
		long _pan2;
		long _tilt2;
		long _shutter2;
		long _trigger_delay2;

};

#endif
