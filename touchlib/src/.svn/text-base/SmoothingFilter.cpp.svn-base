
#include <SmoothingFilter.h>


SmoothingFilter::SmoothingFilter(char* s) : Filter(s)
{
}


SmoothingFilter::~SmoothingFilter()
{
}

// The smooth filter really needs the blur size as a param
void SmoothingFilter::kernel()
{
    // derived class responsible for allocating storage for filtered image
    if( !destination )
    {
        destination = cvCreateImage(cvSize(source->width,source->height), source->depth, source->nChannels);
        destination->origin = source->origin;  // same vertical flip as source
    }

	cvSmooth( source, destination, CV_MEDIAN, 5, 5);		//CV_BLUR
}
