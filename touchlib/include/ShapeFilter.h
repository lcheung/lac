#ifndef __TOUCHSCREEN_FILTER_SHAPE__
#define __TOUCHSCREEN_FILTER_SHAPE__

#include <TouchlibFilter.h>

/**
 * This filter is used for filtering out sharp-edged objects from an image.
 *
 * @author Seb
 */
class TOUCHLIB_FILTER_EXPORT ShapeFilter : public Filter
{
public:


	// ----  constructor/destructor  ---------------------------------------------


	ShapeFilter(char *);
	virtual ~ShapeFilter();


	// ----  overridden/implemented member functions  ----------------------------


	void kernel();
	void getParameters(ParameterMap &pMap);
	void setParameter(const char *name, const char *value);
	void showOutput(bool value, int windowx, int windowy);

private:

	
	// ----  constants  ----------------------------------------------------------


	static const int DEFAULT_BLUR_LEVEL		= 10;
	static const char *TRACKBAR_LABEL_BLUR;
	static const char *PARAMETER_BLUR;

	static const int DEFAULT_LEVEL_LEVEL		= 0;
	static const char *TRACKBAR_LABEL_LEVEL;
	static const char *PARAMETER_LEVEL;


	

	// ----  instance variables  -------------------------------------------------


	int blurLevel;
	int blurLevelSlider;

    int levelLevel;
	int levelSlider;


	IplImage *buffer;


	// ----  methods  ------------------------------------------------------------


	void setNoiseSmoothType(int noiseMethod);
};

#endif // __TOUCHSCREEN_FILTER_SIMPLE_HIGHPASS__
