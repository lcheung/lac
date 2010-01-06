
#include <BrightnessContrastFilter.h>

#include "highgui.h"


BrightnessContrastFilter::BrightnessContrastFilter(char* s) : Filter(s)
{
    brightness = (float) DEFAULT_BRIGHTNESS;
    contrast = (float) DEFAULT_CONTRAST;

    // mapping from input to output values via lookup table, recalculated when brightness or contrast changed
    lutmat = cvCreateMatHeader( 1, 256, CV_8UC1 );
    cvSetData( lutmat, lut, 0 );
    updateLUT();

	brightness_slider = 128;
	contrast_slider = 128;

}


BrightnessContrastFilter::~BrightnessContrastFilter()
{
}


void BrightnessContrastFilter::setBrightness(float value)
{
	brightness = value; 
	updateLUT(); 
	brightness_slider = (value * 128.0) + 128.0;
	if(show)	
		cvSetTrackbarPos("brightness", name.c_str(), brightness_slider);
}


void BrightnessContrastFilter::setContrast(float value)
{
	contrast = value; 
	updateLUT();
	contrast_slider = (value * 128.0) + 128.0;
	if(show)
		cvSetTrackbarPos("contrast", name.c_str(), contrast_slider);
}


void BrightnessContrastFilter::getParameters(ParameterMap& pMap)
{
	pMap[std::string("brightness")] = toString(brightness);
	pMap[std::string("contrast")] = toString(contrast);
}


void BrightnessContrastFilter::setParameter(const char *name, const char *value)
{
	if(strcmp(name, "brightness") == 0)
	{
		setBrightness(atof(value));
	} else if(strcmp(name, "contrast") == 0)
	{
		setContrast(atof(value));
	}

}


void BrightnessContrastFilter::updateLUT( void )
{
    int i;
    float max_value = 0;


    /*
    * The algorithm is by Werner D. Streidt
    * (http://visca.com/ffactory/archives/5-99/msg00021.html)
    */
    if( contrast > 0 )
    {
        float delta = 127.*contrast;
        float a = 255./(255. - delta*2);
        float b = a*(brightness*100 - delta);
        for( i = 0; i < 256; i++ )
        {
            int v = cvRound(a*i + b);
            if( v < 0 )
                v = 0;
            if( v > 255 )
                v = 255;
            lut[i] = (uchar)v;
        }
    }
    else
    {
        float delta = -128.*contrast;
        float a = (256.-delta*2)/255.;
        float b = a*brightness*100. + delta;
        for( i = 0; i < 256; i++ )
        {
            int v = cvRound(a*i + b);
            if( v < 0 )
                v = 0;
            if( v > 255 )
                v = 255;
            lut[i] = (uchar)v;
        }
    }

    cvSetData( lutmat, lut, 0 );
}



void BrightnessContrastFilter::showOutput(bool value, int windowx, int windowy)
{
	Filter::showOutput(value, windowx, windowy);

	if(value)
	{
		cvCreateTrackbar( "brightness", name.c_str(), &brightness_slider, 255, NULL);
		cvCreateTrackbar( "contrast", name.c_str(), &contrast_slider, 255, NULL);

	}
}


void BrightnessContrastFilter::kernel()
{
	float tmp_brightness = 2.0 * (((float)brightness_slider / 255.0f) - 0.5);
	float tmp_contrast = 2.0 * (((float)contrast_slider / 255.0f) - 0.5);

	if(brightness != tmp_brightness || contrast != tmp_contrast)
	{
		brightness = tmp_brightness;
		contrast = tmp_contrast;
		updateLUT();
	}

    // derived class responsible for allocating storage for filtered image
    if( !destination )
    {
        destination = cvCreateImage(cvSize(source->width,source->height), source->depth, source->nChannels);
        destination->origin = source->origin;  // same vertical flip as source
    }
 
    cvLUT( source, destination, lutmat ); 
}
