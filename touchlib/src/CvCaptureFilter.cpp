
#include <CvCaptureFilter.h>

#include <cv.h>
#include <cxcore.h>
#include <highgui.h>

CvCapture * CvCaptureFilter::capture = 0;
IplImage* CvCaptureFilter::acquiredImage = 0;
THREAD_HANDLE CvCaptureFilter::hThread = 0;

CvCaptureFilter::CvCaptureFilter(char* s) : Filter(s)
{

}


CvCaptureFilter::~CvCaptureFilter()
{
	destination = NULL;		// needed so that Filter base class doesn't try to delete
	// FIXME: not threadsafe.. we should put a mutex around capture..
    cvReleaseCapture( &capture );
	capture = 0;
}

void CvCaptureFilter::acquireImage(void *param)
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

void CvCaptureFilter::process(IplImage *frame)
{
	Filter::process(frame);

	acquiredImage = NULL;
	destination = NULL;
}

void CvCaptureFilter::getParameters(ParameterMap& pMap)
{
	pMap[std::string("source")] = std::string(source);
}

void CvCaptureFilter::setParameter(const char *name, const char *value)
{
	if(!capture) 
	{
		if(strcmp(name, "source") == 0)
		{
			strcpy(source, value);

			if(strcmp(value, "cam") == 0)
			{
				capture = cvCaptureFromCAM( CV_CAP_ANY );
				//cvSetCaptureProperty(capture, CV_CAP_PROP_FRAME_WIDTH, 640);
				//cvSetCaptureProperty(capture, CV_CAP_PROP_FRAME_HEIGHT, 480);
				//cvSetCaptureProperty(capture, CV_CAP_PROP_FRAME_WIDTH_HEIGHT, 640480);

				//cvSetCaptureProperty(capture, CV_CAP_PROP_FPS, 30);

			}
			else
				capture = cvCaptureFromAVI(value);
		}

		//hThread = (HANDLE)_beginthread(acquireImage, 0, NULL);
	}
}

bool CvCaptureFilter::isRunning()
{
	return destination != NULL;
}

void CvCaptureFilter::kernel()
{
	destination = cvQueryFrame( capture );

	// rewind the movie.
	if(!destination)
		cvSetCaptureProperty(capture, CV_CAP_PROP_POS_MSEC, 0);
}
