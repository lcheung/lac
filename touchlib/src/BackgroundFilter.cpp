#include <ITouchScreen.h>
#include <vector2d.h>
#include <BackgroundFilter.h>
#include <Image.h>
#include <highgui.h>
#define ROWSTOSCAN	40

#define UPDATERATE_UP		2
#define UPDATERATE_DOWN		1

#define DEFAULT_UPDATE_THRESH	50

BackgroundFilter::BackgroundFilter(char* s) : Filter(s)
{
	reference = NULL;
	mask = NULL;
	polyMask = NULL;
	nPolyMask = 0;
	recapture = false;
	count = -1;
	updateThreshold = DEFAULT_UPDATE_THRESH;
	currentRow = 0;
}

BackgroundFilter::~BackgroundFilter()
{
	if(destination)
		cvReleaseImage(&destination);
	if(reference)
		cvReleaseImage(&reference);
}

void BackgroundFilter::setParameter(const char *name, const char *value)
{
	if(strcmp(name, "capture") == 0)
	{
		printf("Recap\n");
		recapture = true;	
	} else if(strcmp(name, "threshold") == 0)
	{
		updateThreshold = (int) atof(value);

		if(show)
			cvSetTrackbarPos("threshold", this->name.c_str(), updateThreshold);
	} else if(strcmp(name, "mask") == 0)
	{
		if(value)
			setMask((touchlib::vector2df*)value,GRID_X+1,GRID_Y+1);	
		else
			clearMask();
	} 
}


void BackgroundFilter::showOutput(bool value, int windowx, int windowy)
{
	Filter::showOutput(value, windowx, windowy);

	if(value)
	{
		cvCreateTrackbar( "threshold", name.c_str(), &updateThreshold, 255, NULL);
	}
}

void BackgroundFilter::getParameters(ParameterMap& pMap)
{
	pMap[std::string("threshold")] = toString(updateThreshold);
}




void BackgroundFilter::kernel()
{
	// derived class responsible for allocating storage for filtered image
	if( !destination )
	{
        destination = cvCreateImage(cvSize(source->width,source->height), source->depth, 1);
        destination->origin = source->origin;  // same vertical flip as source
	}

	if(count > -1)
		count--;
	
	if( !reference || recapture || count == 0)
	{
		if(reference)
			cvCopy(source, reference);
		else
			reference = cvCloneImage(source);

		if(!mask) {
			mask = cvCreateImage(cvSize(reference->width,reference->height), reference->depth, 1);
			mask->origin = reference->origin;  // same vertical flip as reference
			cvSet(mask,cvScalar(0,0,0));
		}

		if(nPolyMask && updateThreshold == 0) {
			cvSet(mask,cvScalar(255,255,255));			
			cvFillConvexPoly(mask, polyMask,nPolyMask,cvScalar(0,0,0));
		}

		//cvAdd(reference,mask,reference);
		if(updateThreshold != 0)
		{
			cvSubS(reference, cvScalar(updateThreshold,updateThreshold,updateThreshold), reference);
		}

		
		recapture = false;
	}

#ifdef ADAPTIVE_BACKGROUND
	touchlib::BwImage imgSrc(source), imgRef(reference);

	int x, y;
	int h, w;
	h = source->height;
	w = source->width;

	int stoprow = currentRow + ROWSTOSCAN;

	if(stoprow > h)
		stoprow = h;

	// only do N number of rows per frame to speed up processing.. 
	for(y=currentRow; y<stoprow; y++)
	{
		for(x=0; x<w; x++)
		{
			int pix, ref;
			pix = imgSrc[y][x];
			ref = imgRef[y][x];
			if(pix - ref < updateThreshold)		// bright spots are assummed to be active fingers, not background..
			{
				if(pix > ref) 
				{
					ref += UPDATERATE_UP;
					if(ref > pix)
						ref = pix;

					imgRef[y][x] = ref;		// update background
				}

				// In most cases we won't really need to go 'down'..
				// as the screen gets dirtier, it gets brighter.. 
				// 
				//if(pix < ref)
					//ref -= UPDATERATE_DOWN;
				
			}

		}
	}
	currentRow += ROWSTOSCAN;

	if(currentRow >= h)
		currentRow = 0;
#endif
	// destination = source-reference
	cvSub(source, reference, destination);

/*

	*/

}

void BackgroundFilter::setMask(void * vaPoints, int xGrid, int yGrid)
{
	touchlib::vector2df * aPoints = (touchlib::vector2df*)vaPoints;
	if(polyMask)
		delete[] polyMask;
	polyMask = new CvPoint[2*(xGrid + yGrid - 2)];
	int count = 0;
	// top side
	for(int i = 0 ; i < xGrid; i++){
		polyMask[count].x = aPoints[i].X;
		polyMask[count++].y = aPoints[i].Y;
	}
	// right side
	for(int i = 2;i<yGrid;i++){
		polyMask[count].x = aPoints[i*xGrid -1].X;
		polyMask[count++].y = aPoints[i*xGrid -1].Y;
	}
	// bottom side
	for(int i = xGrid-1 ; i >= 0; i--){
		polyMask[count].x = aPoints[i + (yGrid-1)* xGrid].X;
		polyMask[count++].y = aPoints[i + (yGrid-1)* xGrid].Y;
	}
	// left side
	for(int i = yGrid-2 ; i > 0; i--){
		polyMask[count].x = aPoints[i * xGrid].X;
		polyMask[count++].y = aPoints[i * xGrid].Y;
	}
	nPolyMask = count;
	recapture = true;
}

// deletes an old mask and tells kernel func to recapture
void BackgroundFilter::clearMask()
{
	if(polyMask){
		delete[] polyMask;
		polyMask = NULL;
	}
	if(mask)
		cvSet(mask,cvScalar(0,0,0));
	recapture = true;
}
