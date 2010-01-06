#include <HighpassFilter.h>
#include <highgui.h>

HighpassFilter::HighpassFilter(char* s) : Filter(s)
{
    element = cvCreateStructuringElementEx( 3, 3, 0, 0, CV_SHAPE_ELLIPSE, 0 );
    element2 = cvCreateStructuringElementEx( 5, 5, 2, 2, CV_SHAPE_ELLIPSE, 0 );

	filterLevel = 5;
	filterLevel_slider = filterLevel;

	scale = 32;
	scale_slider = scale;

	noErodeDialate = false;
}


HighpassFilter::~HighpassFilter()
{
    cvReleaseStructuringElement(&element);
    cvReleaseStructuringElement(&element2);
}

void HighpassFilter::getParameters(ParameterMap& pMap)
{
	pMap[std::string("filter")] = toString(filterLevel);
	pMap[std::string("scale")] = toString(scale);

	if(noErodeDialate)
		pMap[std::string("mode")] = "1";
}


void HighpassFilter::setParameter(const char *name, const char *value)
{
	if(strcmp(name, "filter") == 0)
	{
		filterLevel = (int) atof(value);
		filterLevel_slider = filterLevel;
		if(show)
			cvSetTrackbarPos("filter", this->name.c_str(), filterLevel);
	}

	if(strcmp(name, "scale") == 0)
	{
		scale = (int) atof(value);
		scale_slider = scale;
		if(show)
			cvSetTrackbarPos("scale", this->name.c_str(), scale);
	}

	if(strcmp(name, "mode") == 0)
	{
		if(strcmp(value, "1") == 0)
		{
			noErodeDialate = true;

		}
	}
}

// Create toolbars
void HighpassFilter::showOutput(bool value, int windowx, int windowy)
{
	Filter::showOutput(value, windowx, windowy);

	if(value)
	{
		cvCreateTrackbar( "filter", name.c_str(), &filterLevel_slider, 12, NULL);
		cvCreateTrackbar( "scale", name.c_str(), &scale_slider, 48, NULL);
	}
}

void HighpassFilter::kernel()
{

	filterLevel = filterLevel_slider;
	scale = scale_slider;
	
    // derived class responsible for allocating storage for filtered image
    if( !destination )
    {
        destination = cvCreateImage(cvGetSize(source), source->depth, source->nChannels);
        destination->origin = source->origin;  // same vertical flip as source

		outra = cvCreateImage( cvGetSize(source), IPL_DEPTH_16S, 1 );
		outra->origin = source->origin;

		outra2 = cvCreateImage( cvGetSize(source), IPL_DEPTH_16S, 1 );
		outra2->origin = source->origin;
    }
   
	cvConvertScale( source, outra );
	//CV_MEDIAN
	cvSmooth( outra, outra2, CV_GAUSSIAN, (filterLevel*2) + 3, (filterLevel*2) + 3, 0, 0 );

	cvSub(outra, outra2, outra2);

	if(noErodeDialate)
	{
		cvConvertScale( outra2, destination, ((double)scale+1.0),  0);
	    cvErode(destination,destination,element,1);
		cvSmooth( destination, destination, CV_GAUSSIAN, 11, 11, 0, 0 );
	    cvDilate(destination,destination,element,1);
	} else {
		cvConvertScale( outra2, destination, ((double)scale+1.0),  32);
	    cvErode(destination,destination,element,2);
		cvSmooth( destination, destination, CV_GAUSSIAN, 7, 7, 0, 0 );
	    cvDilate(destination,destination,element2,1);
	    cvDilate(destination,destination,element,1);
	}

}



