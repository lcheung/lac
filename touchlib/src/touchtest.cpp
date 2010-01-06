#include <cv.h>
#include <cxcore.h>
#include <highgui.h>

#ifdef WIN32
#include <tchar.h>
#endif

#include "TouchScreenDevice.h"

using namespace touchlib;


class TestApp : public ITouchListener
{
public:
	TestApp()
	{
		colors[0].r = 255;
		colors[0].g = 0;
		colors[0].b = 0;

		colors[1].r = 255;
		colors[1].g = 255;
		colors[1].b = 0;

		colors[2].r = 0;
		colors[2].g = 0;
		colors[2].b = 255;

		colors[3].r = 255;
		colors[3].g = 0;
		colors[3].b = 255;

		colors[4].r = 128;
		colors[4].g = 255;
		colors[4].b = 255;

		colors[5].r = 128;
		colors[5].g = 128;
		colors[5].b = 255;

		colors[6].r = 128;
		colors[6].g = 128;
		colors[6].b = 0;

		colors[7].r = 128;
		colors[7].g = 64;
		colors[7].b = 0;

        CvSize size;
        size.width = 640;
        size.height = 640;

		// Create named window in which the captured images will be presented
		cvNamedWindow( "mywindow", CV_WINDOW_AUTOSIZE );
        window_img = cvCreateImage(size, 8, 3);
	}

	~TestApp()
	{
		cvDestroyWindow( "mywindow" );
	    cvReleaseImage( &window_img);
	}

	//! Notify that a finger has just been made active. 
	virtual void fingerDown(TouchData data)
	{
		float rad = sqrtf(data.Area)/2;
		float X = data.X;
		float Y = data.Y;
		cvLine( window_img, cvPoint(X, Y), cvPoint(X,Y), CV_RGB(255, 0, 0), 4, 8, 0 );
        cvRectangle( window_img, cvPoint(X-rad, Y-rad), cvPoint ( X+rad, Y+rad), CV_RGB(200, 0, 0), 1, 8, 0);
	}

	//! Notify that a finger has moved 
	virtual void fingerUpdate(TouchData data)
	{
		RgbPixel p = colors[data.ID % 8];

		float rad = sqrtf(data.Area)/2;
		float X = data.X;
		float Y = data.Y;

        cvLine( window_img, cvPoint(X, Y), cvPoint(X,Y), CV_RGB(p.r, p.g, p.b), 4, 8, 0 );
		cvRectangle( window_img, cvPoint(X-rad, Y-rad), cvPoint ( X+rad, Y+rad ), CV_RGB(p.r, p.g, p.b), 1, 8, 0);
	}

	//! A finger is no longer active..
	virtual void fingerUp(TouchData data)
	{
	}

	void draw()
	{
		//printf("Draw\n");
        cvShowImage( "mywindow", window_img );
        //cvSet(window_img, cvScalar(0));		
	}
private:
    RgbPixel colors[8];
    IplImage *window_img;
};

#ifdef  WIN32
int _tmain(int argc, _TCHAR* argv[])
#else
  int main(int argc, char ** argv)
#endif
{
	// FIXME: in the future we will call a static method on TouchScreenDevice
	// in order to get an ITouchScreen (singleton pattern) as opposed to directly
	// creating it here.. 

	ITouchScreen *screen = TouchScreenDevice::getTouchScreen();
	TestApp app;


	screen->pushFilter("capture", "capture1");
	screen->pushFilter("mono", "mono2");
	screen->pushFilter("backgroundremove", "background3");
	screen->pushFilter("smooth", "smooth4");
	screen->pushFilter("brightnesscontrast", "bc5");
	screen->pushFilter("rectify", "rectify6");

	screen->setParameter("rectify6", "level", "25");

	//screen->setParameter("capture1", "source", "cam");
	//screen->setParameter("capture1", "source", "../tests/simple-2point.avi");
	screen->setParameter("capture1", "source", "../tests/hard-5point.avi");

	screen->setParameter("bc5", "brightness", "0.1");
	screen->setParameter("bc5", "contrast", "0.4");

	screen->registerListener((ITouchListener *)&app);

	// Note: Begin processing should only be called after the screen is set up
	screen->beginProcessing();

	bool ok=true;
	do
	{
		screen->getEvents();
		app.draw();
		//printf("*");
        if( (cvWaitKey(10) & 255) == 27 ) break;
	} while( 1 );

	TouchScreenDevice::destroy();
	return 0;
}

