

#ifndef __TOUCHSCREEN_FILTER_CMUCAPTURE__
#define __TOUCHSCREEN_FILTER_CMUCAPTURE__

#include <TouchlibFilter.h>

#include <1394Camera.h>
#include <cv.h>

#define CMU160x120yuv444 "160x120yuv444"
#define CMU320x240yuv422 "320x240yuv422"
#define CMU640x480yuv411 "640x480yuv411"
#define CMU640x480yuv422 "640x480yuv422"
#define CMU640x480rgb "640x480rgb"
#define CMU640x480mono "640x480mono"
#define CMU640x480mono16 "640x480mono16"
#define CMU800x600yuv422 "800x600yuv422"
#define CMU800x600rgb "800x600rgb"
#define CMU800x600mono "800x600mono"
#define CMU1024x768yuv422 "1024x768yuv422"
#define CMU1024x768rgb "1024x768rgb"
#define CMU1024x768mono "1024x768mono"
#define CMU800x600mono16 "800x600mono16"
#define CMU1024x768mono16 "1024x768mono16"
#define CMU1280x960yuv422 "1280x960yuv422"
#define CMU1280x960rgb "1280x960rgb"
#define CMU1280x960mono "1280x960mono"
#define CMU1600x1200yuv422 "1600x1200yuv422"
#define CMU1600x1200rgb "1600x1200rgb"
#define CMU1600x1200mono "1600x1200mono"
#define CMU1280x960mono16 "1280x960mono16"
#define CMU1600x1200mono16 "1600x1200mono16"

#define CMURate2fps "2fps"
#define CMURate4fps "4fps"
#define CMURate7fps "7fps"
#define CMURate15fps "15fps"
#define CMURate30fps "30fps"
#define CMURate60fps "60fps"
#define CMURate120fps "120fps"
#define CMURate240fps "240fps"

class TOUCHLIB_FILTER_EXPORT CMUCaptureFilter : public Filter
{
	private:
		C1394Camera* capture;		
		static THREAD_HANDLE hThread;		
		unsigned long w,h;
		IplImage * rawImage;
		bool flipRGB;
		int mode;
		int format;
		int rate;
		bool mono;
		int Init();
		std::string sMode,sRate,sVendor,sName;
		LARGE_INTEGER lID;

		// camera features
		int sharpness;
		int gain;
		int brightness;
		int exposure;
		int whitebalanceL,whitebalanceH;
		int hue;
		int saturation;
		int gamma;		

		void setFeature(CAMERA_FEATURE id, int valueL, int valueH = 0);
		bool getFeature(CAMERA_FEATURE id, int &valueL, int &valueH);

	public:
		CMUCaptureFilter(char*);
		~CMUCaptureFilter();
		bool isRunning();
		void kernel();

		virtual void process(IplImage* frame);

		virtual void getParameters(ParameterMap& pMap);
		virtual void setParameter(const char *name, const char *value);

};

#endif // __TOUCHSCREEN_FILTER_CMUCAPTURE__
