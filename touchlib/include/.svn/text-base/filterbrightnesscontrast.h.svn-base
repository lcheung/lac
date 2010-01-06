

#ifndef __TOUCHSCREEN_FILTER_BRIGHTNESSCONTRAST__
#define __TOUCHSCREEN_FILTER_BRIGHTNESSCONTRAST__

#include <filter.h>

#define DEFAULT_BRIGHTNESS 0.0
#define DEFAULT_CONTRAST 0.2


class BrightnessContrastFilter : public Filter
{

public:

    BrightnessContrastFilter(char*);
    void kernel();
    ~BrightnessContrastFilter();

    void setBrightness(float value) {_brightness = value; updateLUT();}
    void setContrast(float value) {_contrast = value; updateLUT();}
    float getContrast(void) {return _contrast;}
    float getBrightness(void) {return _brightness;}

private:

    void BrightnessContrastFilter::updateLUT( void );

    float _brightness;
    float _contrast;
    CvMat* _lutmat;

};

#endif // __TOUCHSCREEN_FILTER_BRIGHTNESSCONTRAST__
