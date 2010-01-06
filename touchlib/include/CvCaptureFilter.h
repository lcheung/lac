

#ifndef __TOUCHSCREEN_FILTER_CAPTURE__
#define __TOUCHSCREEN_FILTER_CAPTURE__

#include <TouchlibFilter.h>

#include <cv.h>
#include <cxcore.h>
#include <highgui.h>

// FIXME: we should put this in a namespace

class TOUCHLIB_FILTER_EXPORT CvCaptureFilter : public Filter
{
	private:
		static CvCapture* capture;
		static void acquireImage(void *param);
		static IplImage* acquiredImage;
		static THREAD_HANDLE hThread;
		char source[255];
	public:
		CvCaptureFilter(char*);
		virtual ~CvCaptureFilter();
		bool isRunning();
		void kernel();

		virtual void process(IplImage* frame);

		virtual void getParameters(ParameterMap& pMap);
		virtual void setParameter(const char *name, const char *value);

};

#endif // __TOUCHSCREEN_FILTER_CAPTURE__
