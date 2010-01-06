
#ifndef __TOUCHSCREEN_FILTER_SCALER__
#define __TOUCHSCREEN_FILTER_SCALER__

#include <TouchlibFilter.h>

#define DEFAULT_RECTIFYLEVEL 20

class TOUCHLIB_FILTER_EXPORT ScalerFilter : public Filter
{

public:

    ScalerFilter(char* name);
    void kernel();
    virtual ~ScalerFilter();

	virtual void getParameters(ParameterMap& pMap);
	virtual void setParameter(const char *name, const char *value);

    void setLevel(unsigned int value) {level = value; level_slider = level;}
    unsigned int getLevel(void) {return level;}


	virtual void showOutput(bool value, int windowx, int windowy);

private:
	bool bAutoSet;
	int level_slider;
    unsigned int level;

};

#endif // __TOUCHSCREEN_FILTER_RECTIFY__
