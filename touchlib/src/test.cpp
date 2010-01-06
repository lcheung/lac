
// Whole program should be encapsulated for easy incorporation into other programs.. 

#include <cv.h>
#include <cxcore.h>
#include <highgui.h>

#include<tchar.h>

#define RECTIFY_LEVEL	40

#include <CBlobTracker.h>

#include <image.h>

#include <filterbrightnesscontrast.h>


using namespace touchscreen;


IplImage *src_image = 0, *dst_image = 0;


int _tmain(int argc, _TCHAR* argv[])
{
    // NOTE: just uncomment this line in order to get the capture from the webcam
    //CvCapture* capture = cvCaptureFromCAM( CV_CAP_ANY );
    //CvCapture* capture = cvCaptureFromAVI("../tests/simple-2point.avi");
    CvCapture* capture = cvCaptureFromAVI("../tests/hard-5point.avi");
    if( !capture ) {
        fprintf( stderr, "ERROR: capture is NULL \n" );
        getchar();
        return -1;
    }


    // Image preprocessing filters
    BrightnessContrastFilter* bcfilter = new BrightnessContrastFilter("bc1");
    bcfilter->show(true);

    // Create named window in which the captured images will be presented
    cvNamedWindow( "mywindow", CV_WINDOW_AUTOSIZE );

    IplImage *dest = 0;
    IplImage *label_img = 0;

    CBlobTracker btracker;

    RgbPixel colors[8];

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


    // Show the image captured from the camera in the window and repeat
    while( 1 ) {

        IplImage* frame = cvQueryFrame( capture );
        if( !frame ) {
            fprintf( stderr, "ERROR: frame is null, quitting ...\n" );
            break;
        }

        if(!dest)
        {
            CvSize size;
            size.width = frame->width;
            size.height = frame->height;

            dest = cvCreateImage(size, 8, 1);
            label_img = cvCreateImage(size, 8, 1);

            printf ("Source image has depth: %d,  %d channels\n", dest->depth, dest->nChannels);
        }

        //cvCvtColor(frame, dest, CV_BGR2GRAY); // cimg -> gimg
        int i, j;

        BwImage imgA(dest);
        RgbImage  imgB(frame);

        for(i=0;i<frame->height;i++) 
            for(j=0;j<frame->width;j++) 
            {
                int val = imgB[i][j].r;

                val = val - RECTIFY_LEVEL;

                if(val < 0)
                    val = 0;

                imgA[i][j] = (unsigned char)val;
            }

            src_image = dest;
            dst_image = dest;


            bcfilter->process(frame);


            BwImage imgC(label_img);
            cvSet(label_img, cvScalar(0));
            btracker.findBlobs(imgA, imgC);
            btracker.ProcessResults();

            for(i=0;i<frame->height;i++) 
                for(j=0;j<frame->width;j++) {
                    RgbPixel bpix;
                    bpix.r = imgA[i][j];
                    bpix.g = imgA[i][j];
                    bpix.b = imgA[i][j];

                    imgB[i][j] = bpix;
                }

                // FIXME: To complete the test, we should create a basic
                // touchscreen app class which responds to finger events
                // and draws the positions on the screen instead of drawing them
                // directly as here.. Then we can expand that app to support
                // other kinds of things.. The app class can include the
                // camera capture calls. That way it will be easy to bring over
                // to irrlicht or ogre3d

                // for each blob
                for  (i=0; i<btracker.current.size(); ++i)
                {
                    RgbPixel p = colors[btracker.current[i].ID % 8];
                    cvLine( frame, cvPoint((int)btracker.current[i].center.X, (int)btracker.current[i].center.Y), 
                        cvPoint((int)btracker.current[i].center.X, (int)btracker.current[i].center.Y), CV_RGB(p.r, p.g , p.b), 4, 8, 0 );
                    // mark box around blob
                    cvRectangle( frame, cvPoint(btracker.current[i].box.upperLeftCorner.X, btracker.current[i].box.upperLeftCorner.Y), cvPoint ( btracker.current[i].box.lowerRightCorner.X, btracker.current[i].box.lowerRightCorner.Y ), CV_RGB(p.r, p.g , p.b), 1, 8, 0);
                    // print the blob centres

                }// each blob

                cvShowImage( "mywindow", frame );



                //cvZero( dst_image );
                // Do not release the frame!

                //If ESC key pressed, Key=0x10001B under OpenCV 0.9.7(linux version),
                //remove higher bits using AND operator
                if( (cvWaitKey(10) & 255) == 27 ) break;
    }

    // Release the capture device housekeeping
    cvReleaseCapture( &capture );
    cvDestroyWindow( "mywindow" );

    cvReleaseImage( &dest);
    cvReleaseImage( &label_img);
    return 0;
}

