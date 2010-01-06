#include <stdio.h>
#include <DSVLCaptureFilter.h>



DSVLCaptureFilter::DSVLCaptureFilter(char *s) : Filter(s)
{
	dsvl_vs = NULL;

	g_pPixelBuffer = NULL;
	g_Timestamp = _INVALID_TIMESTAMP;

	cap_width = 0;
	cap_height = 0;
	cap_fps = 0.0;

	acquired = NULL;

	CoInitialize(NULL);
	dsvl_vs = new DSVL_VideoSource();

	if(FAILED(dsvl_vs->BuildGraphFromXMLFile("DSVL_config.xml")))
	{
		return;
	}

	if(FAILED(dsvl_vs->GetCurrentMediaFormat(&cap_width,&cap_height,&cap_fps,NULL)))
	{
		return;
	}

	PIXELFORMAT pxf;
	if(FAILED(dsvl_vs->GetCurrentMediaFormat(&cap_width,&cap_height,&cap_fps,&pxf)))
	{
		return;
	}

	//if(pxf != PIXELFORMAT_RGB32)
	//{
		//MessageBox(NULL,"DSVL filter supports only PIXELFORMAT_RGB32","glutSample",MB_OK);
		//exit(0);
	//}


	if(FAILED(dsvl_vs->EnableMemoryBuffer(1))) 
	{
		return;
	}
		// three concurrent threads will concurrently query for samples
	if(FAILED(dsvl_vs->Run())) 
		return;


  CvSize size;
  size.width = cap_width;
  size.height = cap_height;

  acquired = cvCreateImageHeader(size, IPL_DEPTH_8U, 3);
  destination = cvCreateImage(size, IPL_DEPTH_8U, 3);

  strcpy(acquired->colorModel, "BGR");
  strcpy(acquired->channelSeq, "BGR");
}

DSVLCaptureFilter::~DSVLCaptureFilter()
{

	if(acquired) {
		acquired->imageData = 0;
		cvReleaseImageHeader(&acquired);

	}

	acquired = NULL;

	dsvl_vs->Stop();
	dsvl_vs->ReleaseGraph();
	delete dsvl_vs;
}




void DSVLCaptureFilter::init()
{

}


void DSVLCaptureFilter::getParameters(ParameterMap& pMap)
{
	//pMap[toString("videostring")] = toString(videostring);

}


void DSVLCaptureFilter::setParameter(const char *name, const char *value)
{
	//if(strcmp(name, "videostring") == 0)
	//{
		//strcpy(videostring, value);
		//init();
	//} 
}

bool DSVLCaptureFilter::isRunning()
{
	return destination != NULL;
}

void DSVLCaptureFilter::kernel()
{
	//DWORD wait_result = dsvl_vs->WaitForNextSample(100/60);//);
	DWORD wait_result = dsvl_vs->WaitForNextSample(200); // Fix by AlexP, http://nuigroup.com/forums/viewthread/2135/
	//if(wait_result == WAIT_OBJECT_0)
	{

		
		//dsvl_vs->Lock();
		if(SUCCEEDED(dsvl_vs->CheckoutMemoryBuffer(&g_mbHandle, &g_pPixelBuffer)))
		{

			acquired->imageData = (char *)g_pPixelBuffer;
			cvCopy(acquired, destination);
			g_Timestamp = dsvl_vs->GetCurrentTimestamp();
			dsvl_vs->CheckinMemoryBuffer(g_mbHandle);
		}
	}
}