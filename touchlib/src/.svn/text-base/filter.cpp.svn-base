
#include <TouchlibFilter.h>
#include <highgui.h>


Filter::Filter(char* s)
{

    name = std::string(s);

    // default is to not show filter output
    show = false;

	source = NULL;
	destination = NULL;
	chainedfilter = NULL;
}


Filter::~Filter()
{
    if( show )
        cvDestroyWindow( name.c_str() );

    if( destination )
        cvReleaseImage(&destination);


	
}


void Filter::showOutput(bool value, int windowx, int windowy)
{
    if( value && !show )
    {
        cvNamedWindow( name.c_str(), CV_WINDOW_AUTOSIZE );

		cvMoveWindow(name.c_str(), windowx, windowy);
        show = true;
    }
    else if( !value && show )
    {
        cvDestroyWindow( name.c_str() );
        show = false;
    }
}


void Filter::process(IplImage* frame)
{
    source = frame;

    // subclasses need to implement this abstract method.
    this->kernel();

	if( !destination )
		return;

    if( chainedfilter )
        chainedfilter->process(destination);
 
    if( show )
	{
		//printf("Show img\n");
        cvShowImage(name.c_str(), destination); 
	}

}


void Filter::connectTo(Filter* targetfilter)
{
    chainedfilter = targetfilter;
}
