
#ifndef __TOUCHLIB_FILTER_MONO__
#define __TOUCHLIB_FILTER_MONO__

#include <TouchlibFilter.h>


class TOUCHLIB_FILTER_EXPORT MonoFilter : public Filter
{

public:

    MonoFilter(char* name);
    void kernel();
    virtual ~MonoFilter();
private:


};

#endif // __TOUCHLIB_FILTER_MONO__
