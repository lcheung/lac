
#include <ScalerFilter.h>
#include <highgui.h>

#include <Image.h>

ScalerFilter::ScalerFilter(char* s) : Filter(s)
{
    level = (unsigned int) DEFAULT_RECTIFYLEVEL;
	level_slider = level;

}

ScalerFilter::~ScalerFilter()
{
}

void ScalerFilter::getParameters(ParameterMap& pMap)
{
	pMap[std::string("level")] = toString(level);
}

void ScalerFilter::setParameter(const char *name, const char *value)
{
	if(strcmp(name, "level") == 0)
	{
		level = (int) atof(value);
		level_slider = level;
		if(show)
			cvSetTrackbarPos("level", this->name.c_str(), level);
	}
}

void ScalerFilter::showOutput(bool value, int windowx, int windowy)
{
	Filter::showOutput(value, windowx, windowy);

	if(value)
	{
		cvCreateTrackbar( "level", name.c_str(), &level_slider, 255, NULL);
	}
}

void ScalerFilter::kernel()
{
	if (show) {
		level = level_slider;
	}

    // derived class responsible for allocating storage for filtered image
    if( !destination )
    {
        destination = cvCreateImage(cvSize(source->width,source->height), source->depth, 1);
        destination->origin = source->origin;  // same vertical flip as source
    }

	cvMul(source, source, destination, (float)level / 128.0f);

}
