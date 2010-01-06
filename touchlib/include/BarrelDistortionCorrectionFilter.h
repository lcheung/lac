// Filter description
// ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
// Name: Barrel Distortion Correction Filter
// Purpose: Correcting the barrel distortion of the lens
// Original author: Laurence Muller (aka Falcon4ever)

#ifndef __TOUCHSCREEN_FILTER_BARRELDISTORTIONCORRECTION__
#define __TOUCHSCREEN_FILTER_BARRELDISTORTIONCORRECTION__

#include <TouchlibFilter.h>

class TOUCHLIB_FILTER_EXPORT BarrelDistortionCorrectionFilter : public Filter
{
	public:
		BarrelDistortionCorrectionFilter(char*);
		virtual ~BarrelDistortionCorrectionFilter();
		void kernel();
		virtual void getParameters(ParameterMap& pMap);
		virtual void setParameter(const char *name, const char *value);

	private:
		IplImage* undistorted_with_border( const IplImage *image, const CvMat *intrinsic,const CvMat *distortion, short int border );
		IplImage* undistorted_with_border2( const IplImage *image, const CvMat *intrinsic,const CvMat *distortion, short int border );
		CvFileStorage *fs;
		CvFileNode *node;		
		CvMat *camera, *dist_coeffs;
		short int border_size;

		CvMat *b_intrinsic;
		IplImage *bordered;
		IplImage *bordered_corr;

		bool init;

		// Method 2
		bool init2;
		IplImage* MapX;
		IplImage* MapY;
};

#endif // __TOUCHSCREEN_FILTER_BARRELDISTORTIONCORRECTION__
