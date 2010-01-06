#include <SimpleHighpassFilter.h>
#include <highgui.h>


// ----  initialization of non-integral constants  ----------------------------


const char *SimpleHighpassFilter::TRACKBAR_LABEL_BLUR 		= "blur";
const char *SimpleHighpassFilter::TRACKBAR_LABEL_NOISE_METHOD	= "noise method";
const char *SimpleHighpassFilter::TRACKBAR_LABEL_NOISE		= "noise";

const char *SimpleHighpassFilter::PARAMETER_BLUR		= "blur";
const char *SimpleHighpassFilter::PARAMETER_NOISE_METHOD	= "noiseMethod";
const char *SimpleHighpassFilter::PARAMETER_NOISE		= "noise";


// ----  implementations  -----------------------------------------------------


SimpleHighpassFilter::SimpleHighpassFilter(char *s) : Filter(s)
{
	blurLevel = DEFAULT_BLUR_LEVEL;
	blurLevelSlider = blurLevel;

        noiseMethodSlider = DEFAULT_NOISE_METHOD;
        setNoiseSmoothType(noiseMethodSlider);

	noiseLevel = DEFAULT_NOISE_LEVEL;
	noiseLevelSlider = noiseLevel;

	buffer = NULL;
}


SimpleHighpassFilter::~SimpleHighpassFilter()
{
	if (buffer != NULL)
		cvReleaseImage(&buffer);
}

void SimpleHighpassFilter::getParameters(ParameterMap &pMap)
{
	pMap[std::string(PARAMETER_BLUR)] = toString(blurLevel);
	pMap[std::string(PARAMETER_NOISE_METHOD)] = toString(noiseSmoothType);
	pMap[std::string(PARAMETER_NOISE)] = toString(noiseLevel);
}

void SimpleHighpassFilter::setParameter(const char *name, const char *value)
{
	if (strcmp(name, PARAMETER_BLUR) == 0) {
		blurLevel = (int) atof(value);
		blurLevelSlider = blurLevel;
		if (show)
			cvSetTrackbarPos(TRACKBAR_LABEL_BLUR, this->name.c_str(), blurLevel);
	} else if (strcmp(name, PARAMETER_NOISE_METHOD) == 0) {
		int noiseMethod = atoi(value);
		noiseMethodSlider = noiseMethod;
		setNoiseSmoothType(noiseMethod);

		if (show)
			cvSetTrackbarPos(TRACKBAR_LABEL_NOISE_METHOD, this->name.c_str(), noiseMethod);
	} else if (strcmp(name, PARAMETER_NOISE) == 0) {
		noiseLevel = (int) atof(value);
		noiseLevelSlider = noiseLevel;
		if (show)
			cvSetTrackbarPos(TRACKBAR_LABEL_NOISE, this->name.c_str(), noiseLevel);
	}
}

void SimpleHighpassFilter::setNoiseSmoothType(int noiseMethod)
{
	switch (noiseMethod) {
        	case NOISE_METHOD_MEDIAN:
                	noiseSmoothType = CV_MEDIAN;
                        break;
		case NOISE_METHOD_BLUR:
                	noiseSmoothType = CV_BLUR;
        		break;
	}
}

void SimpleHighpassFilter::showOutput(bool value, int windowx, int windowy)
{
	Filter::showOutput(value, windowx, windowy);

	if (value) {
		cvCreateTrackbar(TRACKBAR_LABEL_BLUR, name.c_str(), &blurLevelSlider, 255, NULL);
		cvCreateTrackbar(TRACKBAR_LABEL_NOISE_METHOD, name.c_str(), &noiseMethodSlider, 1, NULL);
		cvCreateTrackbar(TRACKBAR_LABEL_NOISE, name.c_str(), &noiseLevelSlider, 255, NULL);
	}

}

void SimpleHighpassFilter::kernel()
{
	if (show) {
		blurLevel = blurLevelSlider;
		noiseLevel = noiseLevelSlider;
		setNoiseSmoothType(noiseMethodSlider);
	}
	
	if (destination == NULL) {
		destination = cvCreateImage(cvGetSize(source), source->depth, source->nChannels);
		destination->origin = source->origin;  // same vertical flip as source
	}
	if (buffer == NULL) {
		buffer = cvCreateImage(cvGetSize(source), source->depth, source->nChannels);
		buffer->origin = source->origin;
	}

	// create the unsharp mask using a linear average filter
	int blurParameter = blurLevel*2+1;
	cvSmooth(source, buffer, CV_BLUR, blurParameter, blurParameter);
	//cvAbsDiff(source, buffer, buffer);
	cvSub(source, buffer, buffer);

	// filter out the noise using a median filter
	int noiseParameter = noiseLevel*2+1;
	cvSmooth(buffer, destination, noiseSmoothType, noiseParameter, noiseParameter);
}

