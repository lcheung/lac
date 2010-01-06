#define CMUCAM
#ifdef CMUCAM

#include <CMUCaptureFilter.h>


THREAD_HANDLE CMUCaptureFilter::hThread = 0;

CMUCaptureFilter::CMUCaptureFilter(char* s) : Filter(s)
{
	flipRGB = false;
	sMode = CMU320x240yuv422;
	sRate = CMURate15fps;
	mode = 1;
	rate = 3;
	format = 0;
	capture = NULL;
	lID.QuadPart = 0;
	mono = false;
	sharpness = -2;
	gain = -2;
	brightness = -2;
	exposure = -2;
	whitebalanceL = -2;
	whitebalanceH = -2;
	hue = -2;
	saturation = -2;
	gamma = -2;

}


CMUCaptureFilter::~CMUCaptureFilter()
{
	if(capture){
		capture->StopVideoStream();
		delete capture;
		capture = NULL;
	}
}


void CMUCaptureFilter::process(IplImage *frame)
{
	Filter::process(frame);
}

void CMUCaptureFilter::getParameters(ParameterMap& pMap)
{
	if(sMode.size())
		pMap[std::string("mode")] = sMode;
	if(sRate.size())
		pMap[std::string("rate")] = sRate;
	pMap[std::string("flipRGB")] = std::string(flipRGB?"true":"false");
	if(sVendor.size())
		pMap[std::string("vendor")] = sVendor;
	if(sName.size())
		pMap[std::string("name")] = sName;
	if(lID.QuadPart != 0)
		pMap[std::string("uniqueID")] = toString(lID.HighPart)+ " " + toString(lID.LowPart);

	// get all the weird stuff
	int l,h;
	if(getFeature(FEATURE_BRIGHTNESS,l,h))
		pMap[std::string("brightness")] = toString(l);
	if(getFeature(FEATURE_SHARPNESS,l,h))
		pMap[std::string("sharpness")] = toString(l);
	if(getFeature(FEATURE_WHITE_BALANCE,l,h)){
		pMap[std::string("whitebalanceL")] = toString(l);
		pMap[std::string("whitebalanceH")] = toString(h);
	}
	if(getFeature(FEATURE_HUE,l,h))
		pMap[std::string("hue")] = toString(l);
	if(getFeature(FEATURE_SATURATION,l,h))
		pMap[std::string("saturation")] = toString(l);
	if(getFeature(FEATURE_GAMMA,l,h))
		pMap[std::string("gamma")] = toString(l);
	if(getFeature(FEATURE_GAIN,l,h))
		pMap[std::string("gain")] = toString(l);
	if(getFeature(FEATURE_AUTO_EXPOSURE,l,h))
		pMap[std::string("exposure")] = toString(l);
}

void CMUCaptureFilter::setParameter(const char *name, const char *value)
{
	if(strcmp(name, "sharpness") == 0){
		sharpness = atoi(value);
	}else if(strcmp(name, "gain") == 0){
		gain = atoi(value);
	}else if(strcmp(name, "brightness") == 0){
		brightness = atoi(value);
	}else if(strcmp(name, "exposure") == 0){
		exposure = atoi(value);
	}else if(strcmp(name, "whitebalanceL") == 0){
		whitebalanceL = atoi(value);
	}else if(strcmp(name, "whitebalanceH") == 0){
		whitebalanceH = atoi(value);
	}else if(strcmp(name, "hue") == 0){
		hue = atoi(value);
	}else if(strcmp(name, "saturation") == 0){
		saturation = atoi(value);
	}else if(strcmp(name, "gamma") == 0){
		gamma = atoi(value);
	}else if(strcmp(name,"vendor") == 0){
		sVendor = value;
	}else if(strcmp(name,"name") == 0){
		sName = value;
	}else if(strcmp(name,"uniqueID") == 0){
		sscanf(value,"%li %li",&lID.HighPart,&lID.LowPart);
	}else if(strcmp(name,"flipRGB") == 0){
		if(strcmp(value,"true") == 0)
			flipRGB = true;
		else
			flipRGB = false;
	}else if(strcmp(name,"mode") == 0){
		sMode = value;
		if(strcmp(value, CMU160x120yuv444 ) == 0){
			mode = 0;
			format = 0;
		}else if(strcmp(value, CMU320x240yuv422 ) == 0){
			mode = 1;
			format = 0;
		}else if(strcmp(value, CMU640x480yuv411 ) == 0){
			mode = 2;
			format = 0;
		}else if(strcmp(value, CMU640x480yuv422 ) == 0){
			mode = 3;
			format = 0;
		}else if(strcmp(value, CMU640x480rgb ) == 0){
			mode = 4;
			format = 0;
		}else if(strcmp(value, CMU640x480mono ) == 0){
			mode = 5;
			format = 0;
			mono = true;
		}else if(strcmp(value, CMU640x480mono16 ) == 0){
			mode = 6;
			format = 0;
		}else if(strcmp(value, CMU800x600yuv422 ) == 0){
			mode = 0;
			format = 1;
		}else if(strcmp(value, CMU800x600rgb ) == 0){
			mode = 1;
			format = 1;
		}else if(strcmp(value, CMU800x600mono ) == 0){
			mode = 2;
			format = 1;
			mono = true;
		}else if(strcmp(value, CMU1024x768yuv422 ) == 0){
			mode = 3;
			format = 1;
		}else if(strcmp(value, CMU1024x768rgb ) == 0){
			mode = 4;
			format = 1;
		}else if(strcmp(value, CMU1024x768mono ) == 0){
			mode = 5;
			format = 1;
			mono = true;
		}else if(strcmp(value, CMU800x600mono16 ) == 0){
			mode = 6;
			format = 1;
		}else if(strcmp(value, CMU1024x768mono16 ) == 0){
			mode = 7;
			format = 1;
		}else if(strcmp(value, CMU1280x960yuv422 ) == 0){
			mode = 0;
			format = 2;
		}else if(strcmp(value, CMU1280x960rgb ) == 0){
			mode = 1;
			format = 2;
		}else if(strcmp(value, CMU1280x960mono ) == 0){
			mode = 2;
			format = 2;
			mono = true;
		}else if(strcmp(value, CMU1600x1200yuv422 ) == 0){
			mode = 3;
			format = 2;
		}else if(strcmp(value, CMU1600x1200rgb ) == 0){
			mode = 4;
			format = 2;
		}else if(strcmp(value, CMU1600x1200mono ) == 0){
			mode = 5;
			format = 2;
			mono = true;
		}else if(strcmp(value, CMU1280x960mono16 ) == 0){
			mode = 6;
			format = 2;
		}else if(strcmp(value, CMU1600x1200mono16 ) == 0){
			mode = 7;
			format = 2;
		}
	} else if(strcmp(name,"rate") == 0){
		sRate = value;
		if(strcmp(value, CMURate2fps ) == 0){
			rate = 0;
		}else if(strcmp(value, CMURate4fps ) == 0){
			rate = 1;
		}else if(strcmp(value, CMURate7fps ) == 0){
			rate = 2;
		}else if(strcmp(value, CMURate15fps ) == 0){
			rate = 3;
		}else if(strcmp(value, CMURate30fps ) == 0){
			rate = 4;
		}else if(strcmp(value, CMURate60fps ) == 0){
			rate = 5;
		}else if(strcmp(value, CMURate120fps ) == 0){
			rate = 6;
		}else if(strcmp(value, CMURate240fps ) == 0){
			rate = 7;
		}
	}
}

bool CMUCaptureFilter::isRunning()
{
	return destination != NULL;
}

int CMUCaptureFilter::Init()
{
	capture = new C1394Camera();
	capture->RefreshCameraList();
	int count = capture->GetNumberCameras();	
	if(!count){
		capture = NULL;
		return CAM_ERROR;
	}

	char *buffer = new char[255];
	int lastWorking = -1;
	bool searchCam = false;
	if(sVendor.size() || sName.size() || lID.QuadPart)
		searchCam = true;

	bool gotCam = false;
	for(int i=0;i<count;i++){				
		if(capture->SelectCamera(i) == CAM_SUCCESS){
			lastWorking = i;
			if(searchCam){
				if(lID.QuadPart){
					LARGE_INTEGER cID;
					capture->GetCameraUniqueID(&cID);					
					if(cID.QuadPart == lID.QuadPart){
						gotCam = true;
						break;
					}
				}
				if(sName.size()){
					capture->GetCameraName(buffer,255);
					buffer = _strlwr(buffer);
					if(sName == buffer){
						gotCam = true;
						break;
					}					
				}
				if(sVendor.size()){
					capture->GetCameraVendor(buffer,255);
					buffer = _strlwr(buffer);
					if(sVendor == buffer){
						gotCam = true;
						break;
					}					
				}
			}else{
				gotCam = true;
				break;
			}
		}
	}	
	delete buffer;
	if(!gotCam && lastWorking != -1){
		capture->SelectCamera(lastWorking);
	}else{
		if(!gotCam)
			goto bailout;
	}
	if(capture->InitCamera(true) != CAM_SUCCESS)
		goto bailout;
#ifdef _DEBUG
	printf("CMU Camera init succeeded\n");
#endif
	if(capture->SetVideoMode(mode) != CAM_SUCCESS)
		goto bailout;
#ifdef _DEBUG
	printf("CMU SetVideoMode succeeded, desired: %d, acquired: %d\n",mode,capture->GetVideoMode());
#endif
	if(capture->SetVideoFormat(format) != CAM_SUCCESS)
		goto bailout;
#ifdef _DEBUG
	printf("CMU SetVideoFormat succeeded, desired: %d, acquired: %d\n",format,capture->GetVideoFormat());
#endif
	if(capture->SetVideoFrameRate(rate) != CAM_SUCCESS)
		goto bailout;
#ifdef _DEBUG
	printf("CMU SetVideoFrameRate succeeded, desired: %d, acquired: %d\n",rate,capture->GetVideoFrameRate());
#endif
	capture->GetVideoFrameDimensions(&w,&h);
#ifdef _DEBUG
	printf("CMU VideoFrameDimensions: %d %d\n",w,h);
#endif

	CvSize size;
	size.height = h;
	size.width = w;
	int channels = mono?1:3;
	destination = cvCreateImage(size,IPL_DEPTH_8U, channels);
	rawImage = cvCreateImage(size,IPL_DEPTH_8U, channels);
	capture->StartImageAcquisition();

	// grab some frames to clear out any junk
	for(int i=0;i<10;i++)
		capture->AcquireImageEx(true,0);

	// set all the weird stuff
	setFeature(FEATURE_BRIGHTNESS,brightness);
	setFeature(FEATURE_SHARPNESS,sharpness);
	setFeature(FEATURE_WHITE_BALANCE,whitebalanceL,whitebalanceH);
	setFeature(FEATURE_HUE,hue);
	setFeature(FEATURE_SATURATION,saturation);
	setFeature(FEATURE_GAMMA,gamma);
	setFeature(FEATURE_GAIN,gain);
	setFeature(FEATURE_AUTO_EXPOSURE,exposure);	
		
	return CAM_SUCCESS;

	bailout:
	if(capture){
		delete capture;
		capture = NULL;
	}
	return CAM_ERROR;
}

void CMUCaptureFilter::setFeature(CAMERA_FEATURE id, int valueL, int valueH)
{
	if(valueL == -2)
		return;

	if(capture->HasFeature(id)){
		C1394CameraControl *c = capture->GetCameraControl(id);
		if(c){
			if(valueL == -1){
				c->SetAutoMode(true);
			}else{
				c->SetAutoMode(false);
				c->SetValue(valueL,valueH);
			}
		}
	}
}


bool CMUCaptureFilter::getFeature(CAMERA_FEATURE id, int &valueL, int &valueH)
{
	if(capture->HasFeature(id)){
		C1394CameraControl *c = capture->GetCameraControl(id);
		if(c){
			valueH = 0;
			if(c->StatusAutoMode()){
				valueL = -1;
			}else{
				unsigned short l,h;
				c->GetValue(&l,&h);
				valueL = l;
				valueH = h;
			}
			return true;
		}
	}
	return false;
}

void CMUCaptureFilter::kernel()
{
	if(!capture){
		if(Init() != CAM_SUCCESS)
			return;
	}
	int dropped = 0;
	if(capture->AcquireImageEx(true,&dropped) == CAM_SUCCESS){
		if(mono){
			unsigned long len = destination->imageSize;
			memcpy(destination->imageData,capture->GetRawData(&len),len);
		}else{
			if(flipRGB){			
				capture->getRGB((unsigned char*)rawImage->imageData,rawImage->imageSize);
				cvCvtColor(rawImage,destination,CV_RGB2BGR); 
			}else{				
				capture->getRGB((unsigned char*)destination->imageData,destination->imageSize);					
			}
		}
	}
}

#endif