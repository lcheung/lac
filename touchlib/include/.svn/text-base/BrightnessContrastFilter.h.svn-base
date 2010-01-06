

#ifndef __TOUCHLIB_FILTER_BRIGHTNESSCONTRAST__
#define __TOUCHLIB_FILTER_BRIGHTNESSCONTRAST__

#include <TouchlibFilter.h>

#define DEFAULT_BRIGHTNESS 0.0
#define DEFAULT_CONTRAST 0.2


class TOUCHLIB_FILTER_EXPORT BrightnessContrastFilter : public Filter
{

public:

    BrightnessContrastFilter(char*);
    void kernel();
    virtual ~BrightnessContrastFilter();

	void setBrightness(float value);
    void setContrast(float value);
    float getContrast(void) {return contrast;}
    float getBrightness(void) {return brightness;}

	virtual void getParameters(ParameterMap& pMap);
	virtual void setParameter(const char *name, const char *value);

	virtual void showOutput(bool value, int windowx, int windowy);
private:

    void updateLUT( void );

    uchar lut[256*4];

	int brightness_slider;
	int contrast_slider;

    float brightness;
    float contrast;
    CvMat* lutmat;

};

#endif // __TOUCHLIB_FILTER_BRIGHTNESSCONTRAST__
