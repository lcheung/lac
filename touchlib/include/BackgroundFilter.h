
#ifndef __TOUCHLIB_FILTER_BACKGROUND__
#define __TOUCHLIB_FILTER_BACKGROUND__

#include <TouchlibFilter.h>


class TOUCHLIB_FILTER_EXPORT BackgroundFilter : public Filter
{

public:

    BackgroundFilter(char* name);
    void kernel();
    virtual ~BackgroundFilter();
	virtual void getParameters(ParameterMap& pMap);
	virtual void setParameter(const char *name, const char *value);

	virtual void showOutput(bool value, int windowx, int windowy);
	void setMask(void *aPoints,int xRes, int yRes);
	void clearMask();

private:
	bool recapture;
	IplImage* reference;
	bool ownsImage;
	int updateThreshold;		// anything above this threshold is considered a 'press' and not part of the background
	int count;
	int currentRow;
	IplImage* mask;
	CvPoint * polyMask;
	int nPolyMask;
};

#endif // __TOUCHLIB_FILTER_BACKGROUND__
