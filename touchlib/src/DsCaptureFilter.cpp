
#include <DsCaptureFilter.h>

#define DEFAULT_CAPTURE_WIDTH 320
#define DEFAULT_CAPTURE_HEIGHT 240
#define DEFAULT_CAPTURE_RATE 15

IplImage* DsCaptureFilter::acquiredImage = 0;

DsCaptureFilter::DsCaptureFilter(char* s) : CBaseVideoRenderer(__uuidof(CLSID_Sampler), NAME("Frame Sampler"), 0, 0), Filter(s)
{
	graph = NULL;
	mediaControl = NULL;
	mediaEvent = NULL;

	captureWidth = DEFAULT_CAPTURE_WIDTH;
	captureHeight = DEFAULT_CAPTURE_HEIGHT;
	captureRate = DEFAULT_CAPTURE_RATE;

	started = false;
}


DsCaptureFilter::~DsCaptureFilter()
{
	// Do not forget to release after use
	if(mediaControl)
		mediaControl->Release();

	if(graph)
		graph->Release();

	if(newFrameEvent)
		CloseHandle(newFrameEvent);

	CoUninitialize();
}


// Very basic setup of capture filter, we should do error checking
bool DsCaptureFilter::initialize()
{
    IBaseFilter* sourceFilter  = NULL;
	IPin* sourcePin = NULL;

	HRESULT hr = CoInitialize(0);

	hr = CoCreateInstance(CLSID_FilterGraph, 0, CLSCTX_INPROC,IID_IGraphBuilder, (void **)&graph);
 
	hr = graph->QueryInterface(IID_IMediaControl, (void **)&mediaControl);

    //sampler = new Sampler(0, &hr); 
    IPin* renderPin  = NULL; 
	hr = this->FindPin(L"In", &renderPin);
    hr = graph->AddFilter((IBaseFilter*)this, L"Sampler");

	if(strcmp(source, "cam") == 0) // Capture from camera
	{
		ICreateDevEnum* devs = NULL;
		hr = CoCreateInstance (CLSID_SystemDeviceEnum, 0, CLSCTX_INPROC, IID_ICreateDevEnum, (void **) &devs);

		IEnumMoniker* cams = NULL;
		hr = devs?devs->CreateClassEnumerator (CLSID_VideoInputDeviceCategory, &cams, 0):0;

		IMoniker* mon  = NULL;
		hr = cams?cams->Next (1, &mon, 0):0;

		hr = mon?mon->BindToObject(0,0,IID_IBaseFilter, (void**)&sourceFilter):0;
		hr = graph->AddFilter(sourceFilter, L"Capture Source");
	} 
	else // Capture from AVI
	{
		WCHAR filename[256];
		MultiByteToWideChar(0, 0, source, -1, filename, sizeof(filename));
		hr = graph->AddSourceFilter(filename, L"File Source", &sourceFilter);
		hr = sourceFilter?sourceFilter->FindPin(L"Output", &sourcePin):0;

		hr = graph?graph->QueryInterface(IID_IMediaEvent, (void **)&mediaEvent):0;
		hr = graph?graph->QueryInterface(IID_IMediaSeeking, (void **)&mediaSeek):0;
	}

	IEnumPins* pins = NULL;
	hr = sourceFilter?sourceFilter->EnumPins(&pins):0;
	hr = pins?pins->Next(1,&sourcePin, 0):0;

    hr = graph->Connect(sourcePin, renderPin);

	newFrameEvent = CreateEvent(0, FALSE, FALSE, "NewFrameEvent");

	return true;
}


void DsCaptureFilter::acquireImage(void *param)
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

void DsCaptureFilter::process(IplImage *frame)
{
	Filter::process(frame);

	acquiredImage = NULL;
	destination = NULL;
}

void DsCaptureFilter::getParameters(ParameterMap& pMap)
{
	pMap[std::string("source")] = std::string(source);
	pMap[std::string("format")] = toString(captureWidth)+"x"+
								  toString(captureHeight)+"@"+
								  toString(captureRate);
}

void DsCaptureFilter::setParameter(const char *name, const char *value)
{
	// I dont like this, the user is not notified about any errors that occur
	// during this very fragile process of setting up capture... 
	// Perhaps we should have a CTouchScreen initialize() which sets up the capture
	// filter to remedy this. (Nick)
	if(!graph) 
	{
		if(strcmp(name, "source") == 0)
		{
			strcpy(source, value);
			initialize();
		}
		if(strcmp(name, "format") == 0)
		{
			sscanf(value, "%dx%d@%d", &captureWidth, &captureHeight, &captureRate);
		}
	}
}

bool DsCaptureFilter::isRunning()
{
	return destination != NULL;
}

void DsCaptureFilter::kernel()
{
	HRESULT hr;
	long eventCode;
	LONG_PTR param1, param2;

	if(!started)
	{
		mediaControl->Run();
		started = true;
	}
	destination = NULL;

	if(mediaEvent)
	{
		mediaEvent->GetEvent(&eventCode, &param1, &param2, 0);
		// if we have reached the end of the video, start it over
		if(eventCode == EC_COMPLETE)
		{
			LONGLONG cur = 0;
			hr = mediaSeek->SetPositions(&cur, AM_SEEKING_AbsolutePositioning, NULL, AM_SEEKING_NoPositioning);
			hr = mediaControl->Run();
		}
		mediaEvent->FreeEventParams(eventCode, param1, param2);
	}

	// Wait for a frame to arrive
	DWORD dw = WaitForSingleObject(newFrameEvent, INFINITE);

	destination = acquiredImage;
}

HRESULT DsCaptureFilter::CheckMediaType(const CMediaType *media )
{    
    VIDEOINFO* vi; 
	
	if(!IsEqualGUID( *media->Subtype(), MEDIASUBTYPE_RGB24) || !(vi = (VIDEOINFO *)media->Format()) )
		return E_FAIL;

	// If capturing from camera, specify the format
	if(strcmp(source, "cam") == 0)
	{
		if(vi->bmiHeader.biWidth != captureWidth)
			return E_FAIL;
		if(vi->bmiHeader.biHeight != captureHeight)
			return E_FAIL;
	}

	DsCaptureFilter::acquiredImage = ::cvCreateImageHeader(cvSize(vi->bmiHeader.biWidth, vi->bmiHeader.biHeight), 8, 3);
    
    return  S_OK;
}

HRESULT DsCaptureFilter::DoRenderSample(IMediaSample *sample)
{
    BYTE* data; 
	sample->GetPointer(&data);

	DsCaptureFilter::acquiredImage->imageData = (char*)data;
	SetEvent(newFrameEvent);

    return  S_OK;
}
