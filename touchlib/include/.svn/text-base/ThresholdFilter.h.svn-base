#ifndef __TOUCHSCREEN_FILTER_THRESHOLD__
#define __TOUCHSCREEN_FILTER_THRESHOLD__

#include <TouchlibFilter.h>

/**
 * This filter has two modes. One that dynamically changes the threshold with the help
 * of statistics that are recorded, and one which is static. Idea by Damian.
 *
 * @author Seb
 */
class TOUCHLIB_FILTER_EXPORT ThresholdFilter : public Filter
{
public:


	// ----  constructor/destructor  ---------------------------------------------


	ThresholdFilter(char *);
	virtual ~ThresholdFilter();


	// ----  overridden/implemented member functions  ----------------------------


	void kernel();
	void getParameters(ParameterMap &pMap);
	void setParameter(const char *name, const char *value);
	void showOutput(bool value, int windowx, int windowy);

private:

	
	// ----  constants  ----------------------------------------------------------


	static const float DEFAULT_THRESHOLD;

	static const int DEFAULT_REINIT_DYNAMIC_STATISTICS_FRAMES = 6;	
	static const int DEFAULT_MODE = 1;	
	static const int MODE_DYNAMIC = 1;
	static const int MODE_MANUAL = 0;

	static const char *TRACKBAR_LABEL_MODE;
	static const char *TRACKBAR_LABEL_THRESHOLD;
	static const char *PARAMETER_MODE;
	static const char *PARAMETER_THRESHOLD;



	// ----  instance variables  -------------------------------------------------


	float overallMax;
	float threshold;
	int reinitDynamicStatisticsFrames;
	int thresholdSlider;
	bool isDynamic;
	int mode;
	int modeSlider;
	
	// ----  private member functions  -------------------------------------------


	void setMode(int mode);
};

#endif // __TOUCHSCREEN_FILTER_THRESHOLD__
