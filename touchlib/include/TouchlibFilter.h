
#ifndef __TOUCHLIB_FILTER__
#define __TOUCHLIB_FILTER__

#include <cv.h>
#include <string>
#include <map>
#include <utilities.h>
#include <touchlib_platform.h>

class FilterFactory;

typedef std::map<std::string, std::string> ParameterMap;

class TOUCHLIB_FILTER_EXPORT Filter
{

	friend class FilterFactory;

public:
    Filter(char* name);
	virtual ~Filter();
    void process(IplImage* frame);
    virtual void kernel() = 0;
    void connectTo(Filter* chainedfilter);
    IplImage* getOutput() { return destination; }
    virtual void showOutput(bool value, int windowx=0, int windowy=0);
	virtual void getParameters(ParameterMap& pMap) { };
	virtual void setParameter(const char *param, const char *value) { };
	const char* getType() { return type.c_str(); };
	const char* getName() { return name.c_str(); };


protected:
    bool show;
    IplImage* source;
    IplImage* destination;
    Filter* chainedfilter;
	std::string type;
    std::string name;

};

#endif // __TOUCHLIB_FILTER__
