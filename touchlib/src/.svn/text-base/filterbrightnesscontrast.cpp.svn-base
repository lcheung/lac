
#include <filterbrightnesscontrast.h>


BrightnessContrastFilter::BrightnessContrastFilter(char* s) : Filter(s)
{
    _brightness = (float) DEFAULT_BRIGHTNESS;
    _contrast = (float) DEFAULT_CONTRAST;

    // mapping from input to output values via lookup table, recalculated when brightness or contrast changed
    _lutmat = cvCreateMatHeader( 1, 256, CV_8UC1 );
    updateLUT();

}


BrightnessContrastFilter::~BrightnessContrastFilter()
{
}



void BrightnessContrastFilter::updateLUT( void )
{
    int i;
    float max_value = 0;
    uchar lut[256*4];

    /*
    * The algorithm is by Werner D. Streidt
    * (http://visca.com/ffactory/archives/5-99/msg00021.html)
    */
    if( _contrast > 0 )
    {
        double delta = 127.*_contrast;
        double a = 255./(255. - delta*2);
        double b = a*(_brightness*100 - delta);
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
        double delta = -128.*_contrast;
        double a = (256.-delta*2)/255.;
        double b = a*_brightness*100. + delta;
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

    cvSetData( _lutmat, lut, 0 );
}


void BrightnessContrastFilter::kernel()
{
    // derived class responsible for allocating storage for filtered image
    if( !_destination )
    {
        _destination = cvCreateImage(cvSize(_source->width,_source->height), _source->depth, _source->nChannels);
        _destination->origin = _source->origin;  // same vertical flip as source
    }
 
    cvLUT( _source, _destination, _lutmat ); 
}
