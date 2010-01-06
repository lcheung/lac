

#ifndef __TOUCHSCREEN_FILTER_HIGHPASS__
#define __TOUCHSCREEN_FILTER_HIGHPASS__

#include <TouchlibFilter.h>

class TOUCHLIB_FILTER_EXPORT HighpassFilter : public Filter
{
public:

    HighpassFilter(char*);
    virtual ~HighpassFilter();
    void kernel();


	virtual void getParameters(ParameterMap& pMap);
	virtual void setParameter(const char *name, const char *value);
	virtual void showOutput(bool value, int windowx, int windowy);

private:
	int filterLevel;
	int filterLevel_slider;

	int scale;
	int scale_slider;

	IplConvKernel* element;
	IplConvKernel* element2;

	IplImage* outra;
	IplImage* outra2;

	bool noErodeDialate;
};

#endif // __TOUCHSCREEN_FILTER_HIGHPASS__
