//
#include <ResizeFilter.h>


ResizeFilter::ResizeFilter(char* s) : Filter(s)
{
	ownsImage = false;

	sizeX = DEFAULT_RESIZEWIDTH;
	sizeY = DEFAULT_RESIZEHEIGHT;
}


ResizeFilter::~ResizeFilter()
{
	if(ownsImage)
		cvReleaseImage(&destination);
}

void ResizeFilter::getParameters(ParameterMap& pMap)
{
	pMap[std::string("sizeX")] = toString(sizeX);
	pMap[std::string("sizeY")] = toString(sizeY);
}


void ResizeFilter::setParameter(const char *name, const char *value)
{
	if(strcmp(name, "sizeX") == 0)
	{
		sizeX  = (int) atof(value);

		if(destination)
			cvReleaseImage(&destination);

        destination = cvCreateImage(cvSize(sizeX,sizeY), 8, 1);
	}
	if(strcmp(name, "sizeY") == 0)
	{
		sizeY  = (int) atof(value);

		if(destination)
			cvReleaseImage(&destination);

        destination = cvCreateImage(cvSize(sizeX,sizeY), 8, 1);
	}
}

// We are assuming 8 bit depth, 1 channel.. so this filter should happen after the mono filter..
void ResizeFilter::kernel()
{
    // derived class responsible for allocating storage for filtered image
    if( !destination )
    {
        destination = cvCreateImage(cvSize(sizeX,sizeY), 8, 1);
        destination->origin = source->origin;  // same vertical flip as source

		ownsImage = true;
	} 

	cvResize(source, destination, CV_INTER_LINEAR);

}
