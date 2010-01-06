// Filter description
// ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
// Name: Crop Filter
// Purpose: Allows the user to crop the source image
// Original author: Laurence Muller (aka Falcon4ever)

#ifndef __TOUCHLIB_FILTER_CROP__
#define __TOUCHLIB_FILTER_CROP__

#include <TouchlibFilter.h>

#define DEFAULT_CROPWIDTH 640
#define DEFAULT_CROPHEIGHT 480

class TOUCHLIB_FILTER_EXPORT CropFilter : public Filter
{
	public:
		CropFilter(char* name);
		void kernel();
		virtual ~CropFilter();

		virtual void getParameters(ParameterMap& pMap);
		virtual void setParameter(const char *name, const char *value);
		virtual void showOutput(bool value, int windowx, int windowy);

	private:	
		bool firsttime;
		int max_x;
		int max_y;
		int level_posX_slider;
		int level_posY_slider;
		int level_width_slider;
		int level_height_slider;
		CvRect img_rect;
};

#endif // __TOUCHLIB_FILTER_CROP__
