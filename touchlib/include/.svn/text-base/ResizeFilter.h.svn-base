
#ifndef __TOUCHLIB_FILTER_RESIZE__
#define __TOUCHLIB_FILTER_RESIZE__

#include <TouchlibFilter.h>

#define DEFAULT_RESIZEWIDTH 480
#define DEFAULT_RESIZEHEIGHT 640


class TOUCHLIB_FILTER_EXPORT ResizeFilter : public Filter
{

public:

    ResizeFilter(char* name);
    void kernel();
    virtual ~ResizeFilter();

	virtual void getParameters(ParameterMap& pMap);
	virtual void setParameter(const char *name, const char *value);

private:
	IplImage* reference;
	bool ownsImage;

	int sizeX;
	int sizeY;

};

#endif // __TOUCHLIB_FILTER_RESIZE__
