

#ifndef __TOUCHSCREEN_FILTER_DSCAPTURE__
#define __TOUCHSCREEN_FILTER_DSCAPTURE__

#include <TouchlibFilter.h>

#include <windows.h>
#include <tchar.h>
#include <dshow.h>
#include <streams.h>
#include <process.h>

// This code is based on the minimalist frame grabber: 
// http://www.codeproject.com/useritems/VideoImageGrabber.asp

struct __declspec(  uuid("{71771540-2017-11cf-ae26-0020afd79767}")  ) CLSID_Sampler;


// FIXME: we should put this in a namespace

class TOUCHLIB_FILTER_EXPORT DsCaptureFilter : public CBaseVideoRenderer, public Filter
{
	private:
		static void acquireImage(void *param);
		static IplImage* acquiredImage;
		bool initialize();

		IGraphBuilder *graph;
		IMediaControl *mediaControl;
		IMediaEvent *mediaEvent;
		IMediaSeeking *mediaSeek;

		HANDLE newFrameEvent;
		bool started;

		int captureWidth;
		int captureHeight;
		int captureRate;

		char source[256];

	public:
		DsCaptureFilter(char*);
		virtual ~DsCaptureFilter();
		bool isRunning();
		void kernel();

		virtual void process(IplImage* frame);

		virtual void getParameters(ParameterMap& pMap);
		virtual void setParameter(const char *name, const char *value);

		// CBaseVideoRenderer methods

	    HRESULT CheckMediaType(const CMediaType *media);
	    HRESULT DoRenderSample(IMediaSample *sample);
	    
};

#endif // __TOUCHSCREEN_FILTER_CAPTURE__
