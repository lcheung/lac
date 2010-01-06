
#include <MonoFilter.h>


MonoFilter::MonoFilter(char* s) : Filter(s)
{

}


MonoFilter::~MonoFilter()
{


}


void MonoFilter::kernel()
{
    // derived class responsible for allocating storage for filtered image
	if(!source)
		return;

    if( !destination )
    {
        destination = cvCreateImage(cvSize(source->width,source->height), IPL_DEPTH_8U, 1);
        destination->origin = source->origin;  // same vertical flip as source

	} 

	// Note: the destination must have one channel.
	if(source->nChannels != 1 && destination->nChannels == 1) 
	{
		if(strcmpi(source->colorModel, "BGRA") == 0)
			cvCvtColor(source, destination, CV_BGRA2GRAY);
		else if(strcmpi(source->colorModel, "BGR") == 0)
			cvCvtColor(source, destination, CV_BGR2GRAY);
		else if(strcmpi(source->colorModel, "RGB") == 0) 
			cvCvtColor(source, destination, CV_RGB2GRAY);

		
	}
}
