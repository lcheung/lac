#include <stdio.h>
#include <VideoWrapperFilter.h>


VideoWrapperFilter::VideoWrapperFilter(char *s) : Filter(s)
{
#if defined(_WIN32) || defined(WIN32) || defined(__WIN32__)
	strcpy(videostring, "vc: 0 320 30 I420 1");
#elif defined(__APPLE__)
	strcpy(videostring, "qt: 0 640 30 rgb 0");
#endif
	g_hVideo = 0;

	destination = NULL;
	acquired = NULL;


	 _brightness1= 0;
	 _contrast1= 0;
	 _hue1= 0;
	 _saturation1= 0;
	 _gamma1= 0;
	 _colorenable1= 0;
	 _whitebalance1= 0;
	 _backlightcompensation1= 0;
	 _gain1= 0;
	 _exposure1= 0;
	 _iris1= 0;
	 _focus1= 0;
	 _zoom1= 0;
	 _pan1= 0;
	 _tilt1= 0;
	 _shutter1= 0;
	 _trigger_delay1= 0;


	 _brightness2= 0;
	 _contrast2= 0;
	 _hue2= 0;
	 _saturation2= 0;
	 _gamma2= 0;
	 _colorenable2= 0;
	 _whitebalance2= 0;
	 _backlightcompensation2= 0;
	 _gain2= 0;
	 _exposure2= 0;
	 _iris2= 0;
	 _focus2= 0;
	 _zoom2= 0;
	 _pan2= 0;
	 _tilt2= 0;
	 _shutter2= 0;
	 _trigger_delay2= 0;
	init();


}

VideoWrapperFilter::~VideoWrapperFilter()
{
	cvReleaseImageHeader(&acquired);

	acquired = NULL;

	validate( VIDEO_stopVideo(g_hVideo), "VIDEO_stopVideo failed");
	validate( VIDEO_close(g_hVideo), "VIDEO_close failed");
}


// a simple function to print to the console.
static void myprint(char *buf)
{
	printf("VWTest: %s\n", buf);
}


void VideoWrapperFilter::init()
{
  VIDEO_setPrintFunction(myprint);

  
//#if defined(_WIN32) || defined(WIN32) || defined(__WIN32__)
//  CoInitialize(NULL);
//#endif

  char g_pbuf[256];

    // open camera
  validate( VIDEO_openVideo(videostring, &g_hVideo), "VIDEO_openVideo failed.\n");

  if(!g_hVideo)
	  return;

  // start video
  validate( VIDEO_startVideo(g_hVideo), "VIDEO_startVideo failed.\n");

  // get video size
  validate( VIDEO_getWidth(g_hVideo, &g_nCapWidth), "VIDEO_getWidth failed.\n");
  validate( VIDEO_getHeight(g_hVideo, &g_nCapHeight), "VIDEO_getHeight failed.\n");
  validate( VIDEO_getDepth(g_hVideo, &g_nCapDepth), "VIDEO_getHeight failed.\n");  
  // get pixel format
 
  validate( VIDEO_getPixelFormat(g_hVideo, &format), "VIDEO_getPixelFormat failed.\n");
  
  // display video properties
  sprintf(g_pbuf,"VideoWrapper: video is %d x %d, and format is %d. Depth is %d\n", g_nCapWidth,g_nCapHeight, format, g_nCapDepth);
  printf(g_pbuf);

  // set loop-- this only has an effect on the "replay" camera
  // used to play back captured video.
  VIDEO_replaySetPlaybackLoop( g_hVideo, TRUE);

  if(acquired)
	  	cvReleaseImageHeader(&acquired);

  if(destination)
	  	cvReleaseImage(&acquired);
  CvSize size;
  size.width = g_nCapWidth;
  size.height = g_nCapHeight;

  switch(format)
  {
  case VW_PF_RGB:
	  acquired = cvCreateImageHeader(size, IPL_DEPTH_8U, 3);
	  destination = cvCreateImage(size, IPL_DEPTH_8U, 3);

	  strcpy(acquired->colorModel, "rgb");
	  strcpy(acquired->channelSeq, "rgb");
	  break;
  case VW_PF_RGBA:
	  acquired = cvCreateImageHeader(size, IPL_DEPTH_8U, 4);
	  destination = cvCreateImage(size, IPL_DEPTH_8U, 4);

	  strcpy(acquired->colorModel, "rgba");
	  strcpy(acquired->channelSeq, "rgba");
	  break;
  case VW_PF_LUMINANCE:
	  break;
  case VW_PF_LUMINANCE_ALPHA:
	  break;
  case VW_PF_BGR_EXT:
	  acquired = cvCreateImageHeader(size, IPL_DEPTH_8U, 3);
	  destination = cvCreateImage(size, IPL_DEPTH_8U, 3);
	  strcpy(acquired->colorModel, "bgr");
	  strcpy(acquired->channelSeq, "bgr");
	  break;
  case VW_PF_BGRA_EXT:
	  acquired = cvCreateImageHeader(size, IPL_DEPTH_8U, 4);
	  destination = cvCreateImage(size, IPL_DEPTH_8U, 4);

	  strcpy(acquired->colorModel, "bgra");
	  strcpy(acquired->channelSeq, "bgra");
	  break;
  }

	//VIDEO_showPropertiesDialog(g_hVideo);

	VWBool bauto = 0;
	/*
	VIDEO_getPropertyLong( g_hVideo, VWCAMPROP_BRIGHTNESS, &_brightness1, &_brightness2, &bauto);
	VIDEO_getPropertyLong( g_hVideo, VWCAMPROP_CONTRAST, &_contrast1, &_contrast2, &bauto);
	VIDEO_getPropertyLong( g_hVideo, VWCAMPROP_HUE, &_hue1, &_hue2, &bauto);
	VIDEO_getPropertyLong( g_hVideo, VWCAMPROP_SATURATION, &_saturation1, &_saturation2, &bauto);
	VIDEO_getPropertyLong( g_hVideo, VWCAMPROP_GAMMA, &_gamma1, &_gamma2, &bauto);
	VIDEO_getPropertyLong( g_hVideo, VWCAMPROP_COLORENABLE, &_colorenable1, &_colorenable2, &bauto);
	VIDEO_getPropertyLong( g_hVideo, VWCAMPROP_WHITEBALANCE, &_whitebalance1, &_whitebalance2, &bauto);
	VIDEO_getPropertyLong( g_hVideo, VWCAMPROP_BACKLIGHTCOMPENSATION, &_backlightcompensation1, &_backlightcompensation2, &bauto);
	VIDEO_getPropertyLong( g_hVideo, VWCAMPROP_GAIN, &_gain1, &_gain2, &bauto);
	VIDEO_getPropertyLong( g_hVideo, VWCAMPROP_EXPOSURE, &_exposure1, &_exposure2, &bauto);
	VIDEO_getPropertyLong( g_hVideo, VWCAMPROP_IRIS, &_iris1, &_iris2, &bauto);
	VIDEO_getPropertyLong( g_hVideo, VWCAMPROP_FOCUS, &_focus1, &_focus2, &bauto);
	VIDEO_getPropertyLong( g_hVideo, VWCAMPROP_ZOOM, &_zoom1, &_zoom2, &bauto);
	VIDEO_getPropertyLong( g_hVideo, VWCAMPROP_PAN, &_pan1, &_pan2, &bauto);
	VIDEO_getPropertyLong( g_hVideo, VWCAMPROP_TILT, &_tilt1, &_tilt2, &bauto);
	VIDEO_getPropertyLong( g_hVideo, VWCAMPROP_SHUTTER, &_shutter1, &_shutter2, &bauto);
	VIDEO_getPropertyLong( g_hVideo, VWCAMPROP_TRIGGER_DELAY, &_trigger_delay1, &_trigger_delay2, &bauto);
*/


}

void VideoWrapperFilter::validate( VWResult result, char* szMsg)															
{																							
	if( result != VW_SUCCESS && result != VW_E_NOT_IMPLEMENTED)			
	{																						
		printf( szMsg);
		printf( VIDEO_getErrDescription( result));
		//exit(0);																			
	}																						
}

void VideoWrapperFilter::getParameters(ParameterMap& pMap)
{
	pMap[toString("videostring")] = toString(videostring);
/*
	pMap[toString("brightness1")] = toString(_brightness1);
	pMap[toString("contrast1")] = toString(_contrast1);
	pMap[toString("hue1")] = toString(_hue1);
	pMap[toString("saturation1")] = toString(_saturation1);
	pMap[toString("gamma1")] = toString(_gamma1);
	pMap[toString("colorenable1")] = toString(_colorenable1);
	pMap[toString("whitebalance1")] = toString(_whitebalance1);
	pMap[toString("backlightcompensation1")] = toString(_backlightcompensation1);
	pMap[toString("gain1")] = toString(_gain1);
	pMap[toString("exposure1")] = toString(_exposure1);
	pMap[toString("iris1")] = toString(_iris1);
	pMap[toString("focus1")] = toString(_focus1);
	pMap[toString("zoom1")] = toString(_zoom1);
	pMap[toString("pan1")] = toString(_pan1);
	pMap[toString("tilt1")] = toString(_tilt1);
	pMap[toString("shutter1")] = toString(_shutter1);
	pMap[toString("trigger_delay1")] = toString(_trigger_delay1);

	pMap[toString("brightness2")] = toString(_brightness2);
	pMap[toString("contrast2")] = toString(_contrast2);
	pMap[toString("hue2")] = toString(_hue2);
	pMap[toString("saturation2")] = toString(_saturation2);
	pMap[toString("gamma2")] = toString(_gamma2);
	pMap[toString("colorenable2")] = toString(_colorenable2);
	pMap[toString("whitebalance2")] = toString(_whitebalance2);
	pMap[toString("backlightcompensation2")] = toString(_backlightcompensation2);
	pMap[toString("gain2")] = toString(_gain2);
	pMap[toString("exposure2")] = toString(_exposure2);
	pMap[toString("iris2")] = toString(_iris2);
	pMap[toString("focus2")] = toString(_focus2);
	pMap[toString("zoom2")] = toString(_zoom2);
	pMap[toString("pan2")] = toString(_pan2);
	pMap[toString("tilt2")] = toString(_tilt2);
	pMap[toString("shutter2")] = toString(_shutter2);
	pMap[toString("trigger_delay2")] = toString(_trigger_delay2);
	*/
}


void VideoWrapperFilter::setParameter(const char *name, const char *value)
{
	if(strcmp(name, "videostring") == 0)
	{
	
		strcpy(videostring, value);

		if(g_hVideo)
		{
			validate( VIDEO_stopVideo(g_hVideo), "VIDEO_stopVideo failed");
			validate( VIDEO_close(g_hVideo), "VIDEO_close failed");
		}
		init();
	} else
	{
		/*
	VIDEO_setPropertyLong( hVideo,VWCAMPROP_BRIGHTNESS, _brightness1, _brightness2);
	VIDEO_setPropertyLong( hVideo,VWCAMPROP_CONTRAST, _contrast1, _contrast2);
	VIDEO_setPropertyLong( hVideo,VWCAMPROP_HUE, _hue1, _hue2);
	VIDEO_setPropertyLong( hVideo,VWCAMPROP_SATURATION, _saturation1, _saturation2);
	VIDEO_setPropertyLong( hVideo,VWCAMPROP_GAMMA, _gamma1, _gamma2);
	VIDEO_setPropertyLong( hVideo,VWCAMPROP_COLORENABLE, _colorenable1, _colorenable2);
	VIDEO_setPropertyLong( hVideo,VWCAMPROP_WHITEBALANCE, _whitebalance1, _whitebalance2);
	VIDEO_setPropertyLong( hVideo,VWCAMPROP_BACKLIGHTCOMPENSATION, _backlightcompensation1, _backlightcompensation2);
	VIDEO_setPropertyLong( hVideo,VWCAMPROP_GAIN, _gain1, _gain2);
	VIDEO_setPropertyLong( hVideo,VWCAMPROP_EXPOSURE, _exposure1, _exposure2);
	VIDEO_setPropertyLong( hVideo,VWCAMPROP_IRIS, _iris1, _iris2);
	VIDEO_setPropertyLong( hVideo,VWCAMPROP_FOCUS, _focus1, _focus2);
	VIDEO_setPropertyLong( hVideo,VWCAMPROP_ZOOM, _zoom1, _zoom2);
	VIDEO_setPropertyLong( hVideo,VWCAMPROP_PAN, _pan1, _pan2);
	VIDEO_setPropertyLong( hVideo,VWCAMPROP_TILT, _tilt1, _tilt2);
	VIDEO_setPropertyLong( hVideo,VWCAMPROP_SHUTTER, _shutter1, _shutter2);
	VIDEO_setPropertyLong( hVideo,VWCAMPROP_TRIGGER_DELAY, _trigger_delay1, _trigger_delay2);
	*/
	}
}

bool VideoWrapperFilter::isRunning()
{
	return destination != NULL;
}

void VideoWrapperFilter::kernel()
{
	//destination = cvQueryFrame( capture );

	timeval t;
	if(!g_hVideo)
		return;

	VIDEO_getFrame(g_hVideo, (unsigned char**) (&acquired->imageData), &t);

	//while( != VW_SUCCESS ) //
	//{
		//Sleep(8);
	//}

	if(acquired->imageData)
	{
		//destination = acquired;
		cvCopy(acquired, destination);
	} // else
		//destination = NULL;

	VIDEO_releaseFrame( g_hVideo );
}
