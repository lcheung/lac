
#include <RectifyFilter.h>
#include <highgui.h>

#include <Image.h>

RectifyFilter::RectifyFilter(char* s) : Filter(s)
{
    level = (unsigned int) DEFAULT_RECTIFYLEVEL;
	level_slider = level;

	bAutoSet = false;
}


RectifyFilter::~RectifyFilter()
{
}

void RectifyFilter::getParameters(ParameterMap& pMap)
{
	pMap[std::string("level")] = bAutoSet ? std::string("auto") : toString(level);
}

void RectifyFilter::setParameter(const char *name, const char *value)
{
	if(strcmp(name, "level") == 0)
	{
		if(strcmp(value, "auto") == 0)
		{
			bAutoSet = true;
			printf("Auto set\n");
		} else
		{
			level = (int) atof(value);
			level_slider = level;
			if(show)
			  cvSetTrackbarPos("level", this->name.c_str(), level);
		}
	}
	
}

void RectifyFilter::showOutput(bool value, int windowx, int windowy)
{
	Filter::showOutput(value, windowx, windowy);

	if(value)
	{
		cvCreateTrackbar( "level", name.c_str(), &level_slider, 255, NULL);
	}
}

void RectifyFilter::kernel()
{
	level = level_slider;
    // derived class responsible for allocating storage for filtered image
    if( !destination )
    {
        destination = cvCreateImage(cvSize(source->width,source->height), source->depth, 1);
        destination->origin = source->origin;  // same vertical flip as source
    }

	if(bAutoSet)
	{
		touchlib::BwImage img(source);

		int h, w;
		h = img.getHeight();
		w = img.getWidth();

		unsigned char highest = 0;

		for(int y=0; y<h; y++)
			for(int x=0; x<w; x++)
			{
				if(img[y][x] > highest)
					highest = img[y][x];
			}

		setLevel((unsigned int)highest);
		bAutoSet = false;
	}

    cvThreshold(source, destination, level, 255, CV_THRESH_TOZERO);		//CV_THRESH_BINARY

}
