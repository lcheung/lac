
#include <CaptureFilter.h>

#if defined(_WIN32) || defined(WIN32) || defined(__WIN32__)
	#include <windows.h>
#endif

#include <cv.h>
#include <cxcore.h>
#include <highgui.h>

CvCapture * CaptureFilter::capture = 0;
IplImage* CaptureFilter::acquiredImage = 0;
//HANDLE CaptureFilter::hThread = 0;

CaptureFilter::CaptureFilter(char* s) : Filter(s)
{

}


CaptureFilter::~CaptureFilter()
{
	destination = NULL;		// needed so that Filter base class doesn't try to delete
	// FIXME: not threadsafe.. we should put a mutex around capture..
    cvReleaseCapture( &capture );
	capture = 0;
}

void CaptureFilter::acquireImage(void *param)
{
	/*
	while(1)
	{
		if(capture) 
		{
			acquiredImage = cvQueryFrame( capture );

			// rewind the movie.
			if(!acquiredImage)
				cvSetCaptureProperty(capture, CV_CAP_PROP_POS_MSEC, 0);

			Sleep(32);			
		} else
		{
			_endthread();
		}		

	}
	*/
}

void CaptureFilter::process(IplImage *frame)
{
	Filter::process(frame);

	acquiredImage = NULL;
	destination = NULL;
}

void CaptureFilter::getParameters(ParameterMap& pMap)
{
	pMap[std::string("source")] = std::string(source);
}

void CaptureFilter::setParameter(const char *name, const char *value)
{
	if(!capture) 
	{
		if(strcmp(name, "source") == 0)
		{
			strcpy(source, value);

			if(strcmp(value, "cam") == 0)
			{
				capture = cvCaptureFromCAM( CV_CAP_ANY );

				//cvSetCaptureProperty(capture, CV_CAP_PROP_FRAME_WIDTH_HEIGHT, 640480);


			}
			else
				capture = cvCaptureFromAVI(value);
		}

		//hThread = (HANDLE)_beginthread(acquireImage, 0, NULL);
	}
}

bool CaptureFilter::isRunning()
{
	return destination != NULL;
}

void CaptureFilter::kernel()
{
	destination = cvQueryFrame( capture );

	// rewind the movie.
	if(!destination)
		cvSetCaptureProperty(capture, CV_CAP_PROP_POS_MSEC, 0);
}
