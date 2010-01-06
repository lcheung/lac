#ifndef __TOUCHSCREEN_FILTER_DSVLCAPTURE__
#define __TOUCHSCREEN_FILTER_DSVLCAPTURE__

#include <TouchlibFilter.h>

#include <windows.h>
#include <tchar.h>
#include <dshow.h>
#include <streams.h>
#include <process.h>

#include <DSVL.h>

// FIXME: we should put this in a namespace

class TOUCHLIB_FILTER_EXPORT DSVLCaptureFilter : public Filter
{
	public:
		DSVLCaptureFilter(char*);
		virtual ~DSVLCaptureFilter();
		bool isRunning();
		void kernel();

		virtual void getParameters(ParameterMap& pMap);
		virtual void setParameter(const char *name, const char *value);
	private:
		void init();

		DSVL_VideoSource *dsvl_vs;

		MemoryBufferHandle g_mbHandle;
		BYTE* g_pPixelBuffer;
		LONGLONG g_Timestamp;

		LONG cap_width;
		LONG cap_height;
		double cap_fps;

		IplImage *acquired;

};

#endif
