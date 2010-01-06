// Todo: get capture working @ 640 x 480
// f


#include "CBlobTracker.h"
#include <cstdio>
#include <map>

#define MIN_AREA 2.0
#define DETECT_THRESHOLD 1		// this is really handled by the Rectify filter
#define MIN_WEIGHT	255.0f
#define MAX_LABELS	1000

using namespace std;



// FIXME: findFinger should search back a few frames just in case 

using namespace touchlib;

///////////////////////////////////////////////////
// blob detecting

CBlobTracker::CBlobTracker() : IBlobTracker()
{
	currentID = 1;
	extraIDs = 0;
}

// stolen from opencv - squares.c sample
// helper function:
// finds a cosine of angle between vectors
// from pt0->pt1 and from pt0->pt2 
double cosAngle( CvPoint* pt1, CvPoint* pt2, CvPoint* pt0 )
{
    double dx1 = pt1->x - pt0->x;
    double dy1 = pt1->y - pt0->y;
    double dx2 = pt2->x - pt0->x;
    double dy2 = pt2->y - pt0->y;
    return (dx1*dx2 + dy1*dy2)/sqrt((dx1*dx1 + dy1*dy1)*(dx2*dx2 + dy2*dy2) + 1e-10);
}

// check out the number of children at each level some how to calculate a blob tag. 
// there can be a max of 9 squares at each level.. 
unsigned int getTag(CvSeq *curCont, int level=0)
{

	unsigned int num = 0;
	unsigned int sum = 0;

	if(level > 5)
		return 0;

	for( ; curCont != 0; curCont = curCont->h_next )	
	{
		num ++;

		if(curCont->v_next)
			sum += getTag(curCont->v_next, level+1);

		if(num > 9)
			return 9;

	}

	sum += num * (int)powf(10.0, level);

	return sum;
}


void CBlobTracker::findBlobs(BwImage &img)
{

	blobList.clear();
	CvMemStorage* storage = cvCreateMemStorage(0);

	//pressure
	//IplImage *origImg = cvCloneImage(img.imgp);

	CvSeq* cont = 0; 
	CvBox2D32f box;
	float halfx,halfy;
	CBlob blob;
	float temp;
	CvSeq *result;
    //CvSeq *squares = cvCreateSeq( 0, sizeof(CvSeq), sizeof(CvPoint), storage );

	double s, t;
	unsigned int i;

	bool isSquare = false;

	cvFindContours( img.imgp, storage, &cont, sizeof(CvContour), CV_RETR_TREE, CV_CHAIN_APPROX_SIMPLE );

	for( ; cont != 0; cont = cont->h_next )	{
		int count = cont->total; // This is number point in contour

		// First we check to see if this contour looks like a square.. 
		isSquare = false;
        result = cvApproxPoly( cont, sizeof(CvContour), storage,
            CV_POLY_APPROX_DP, cvContourPerimeter(cont)*0.02, 0 );

        if( result->total == 4 &&
            fabs(cvContourArea(result,CV_WHOLE_SEQ)) > 1000 &&
            cvCheckContourConvexity(result) )
        {
			s = 0;
            
            for( i = 0; i < 5; i++ )
            {
                // find minimum angle between joint
                // edges (maximum of cosine)
                if( i >= 2 )
                {
                    t = fabs(cosAngle(
                    (CvPoint*)cvGetSeqElem( result, i ),
                    (CvPoint*)cvGetSeqElem( result, i-2 ),
                    (CvPoint*)cvGetSeqElem( result, i-1 )));
                    s = s > t ? s : t;
                }
            }
            
            // if cosines of all angles are small
            // (all angles are ~90 degree) then this is a square.. 
            if( s < 0.5 )
			{
	

				box = cvMinAreaRect2(cont, storage);		
				blob.center.X = box.center.x;
				blob.center.Y = box.center.y;
				blob.angle = box.angle;

				halfx = box.size.width*0.5f;
				halfy = box.size.height*0.5f;
				blob.box.upperLeftCorner.set(box.center.x-halfx,box.center.y-halfy);
				blob.box.lowerRightCorner.set(box.center.x+halfx,box.center.y+halfy);

				blob.area = blob.box.getArea();
				/*pressure
				unsigned char imgPixel;
				int widthStep = img.getWidth();
				float tempWeight = 0;
				int numPixels = 0;
				for(int i1 = blob.box.upperLeftCorner.Y; i1 <= blob.box.lowerRightCorner.Y; i1++)
				{
					for(int j1 = blob.box.upperLeftCorner.X; j1 <= blob.box.lowerRightCorner.X; j1++)
					{
						
						imgPixel = ((uchar*)(origImg->imageData + origImg->widthStep*i1))[j1];
						if((int)imgPixel > 0)
						{
							tempWeight += imgPixel;
							numPixels++;
						}
						//printf("%d ",imgPixel);
					}
				}
				blob.weight = tempWeight / (float)numPixels;
				end pressure*/

				// use v_next.. 

				if(cont->v_next)
					blob.tagID = getTag(cont->v_next);
				else
					blob.tagID = 0;

				printf("Square Detected %d\n", blob.tagID);

				blobList.push_back(blob);

				isSquare = true;
			}
		}

		// fallback, if it's a regular blob.
		if(!isSquare)
		{
			// Number point must be more than or equal to 6 (for cvFitEllipse_32f).    
			if( count >= 6)
			{
				// Fits ellipse to current contour.
				box = cvFitEllipse2(cont);	
			} else {
				box = cvMinAreaRect2(cont, storage);		
			}
			blob.center.X = box.center.x;
			blob.center.Y = box.center.y;
			blob.angle = box.angle;

			halfx = box.size.width*0.5f;
			halfy = box.size.height*0.5f;
			blob.box.upperLeftCorner.set(box.center.x-halfx,box.center.y-halfy);
			blob.box.lowerRightCorner.set(box.center.x+halfx,box.center.y+halfy);

			blob.area = blob.box.getArea();
			
			/*pressure
			unsigned char imgPixel;
			int imgWidth = img.getWidth();
			int widthStep = img.getWidth();
			int imgHeight = img.getHeight();
			float tempWeight = 0;
			int numPixels = 0;
			int ulcY = blob.box.upperLeftCorner.Y;
			int lrcY = blob.box.lowerRightCorner.Y;
			int ulcX = blob.box.upperLeftCorner.X;
			int lrcX = blob.box.lowerRightCorner.X;
			if(ulcY >= 0 && ulcX >=0 && lrcY <= imgHeight && lrcX <= imgWidth)
			{
				for(int i1 = ulcY; i1 <= lrcY; i1++)
				{
					for(int j1 = ulcX; j1 <= lrcX; j1++)
					{
						
						imgPixel = ((uchar*)(origImg->imageData + origImg->widthStep*i1))[j1];
						if((int)imgPixel > 0)
						{
							tempWeight += imgPixel;
							numPixels++;
						}
						//printf("%d ",imgPixel);
					}
				}
			}
			//else
			//	printf("garbage. Something that shouldn't happen did !");

				
			blob.weight = tempWeight / (float)numPixels;
			end pressure*/
			blob.weight = 0;
			blob.tagID = 0;

			int h=(int)blob.box.getHeight(), w=(int)blob.box.getWidth();
			if(w >= reject_min_dimension && h >= reject_min_dimension && w < reject_max_dimension && h < reject_max_dimension)
				blobList.push_back(blob);
		}

	}		// end cont for loop
	//pressure
	//cvReleaseImage(&origImg);
	cvReleaseMemStorage(&storage);

}

//////////////////////////////////////////
// blob tracking stuff below

void CBlobTracker::trackBlobs()
{
	// Fire off events, set id's..
	unsigned int i, j, k;

	history.push_back(current);

	if(history.size() > HISTORY_FRAMES) 
	{
		history.erase(history.begin());
	}

	current.clear();

	unsigned int numblobs = (unsigned int) blobList.size();

	for(i=0; i<numblobs; i++)
	{
		current.push_back(CFinger(blobList[i]));
	}

	vector<CFinger> *prev = &history[history.size()-1];

	const unsigned int cursize = (unsigned int) current.size();
	const unsigned int prevsize = (unsigned int) (*prev).size();

	// now figure out the 'error' for all the blobs in the current frame
	// error is defined as the distance between the current frame blobs and the blobs
	// in the last frame
	// potentially error could encompass things like deviation from the predicted
	// position, change in size, etc, but it's difficult to come up with a fair metric which 
	// includes more than one axis. Simply optimizing for the least change in distance
	// seems to work the best.

	for(i=0; i<cursize; i++)
	{
		current[i].error.clear();
		current[i].closest.clear();

		for(j=0; j<prevsize; j++)
		{
			float error = 0.0f;
			error = getError((*prev)[j], current[i]);
			current[i].error.push_back(error);
			current[i].closest.push_back(j);
		}
	}

	// sort so we can make a list of the closest blobs in the previous frame..
	for(i=0; i<cursize; i++)
	{
		// Bubble sort closest.
		for(j=0; j<prevsize; j++)
		{
			for(k=0; k<prevsize-1-j; k++)
			{
				// ugly as hell, I know.
				
				if(current[i].error[current[i].closest[k+1]] < current[i].error[current[i].closest[k]]) 
				{
				  int tmp = current[i].closest[k];			// swap
				  current[i].closest[k] = current[i].closest[k+1];
				  current[i].closest[k+1] = tmp;
				}
			}
		}
	}

	// Generate a matrix of all the possible choices
	// If we know there were four points last time and 6 points this time then 2 ID's will be -1.
	// then we will calculate the error and pick the matrix that has the lowest error
	// the more points the slower this will be.. fortunately we will be dealing with low numbers of points..
	// unfortunately the cpu time grows explosively since this is an NP Complete problem.
	// to remedy, we will assume that the chosen ID is going to be from one of the top 4 closest points.
	// this will eliminate possiblities that shouldn't lead to an optimal solution.

	ids.clear();

	//map<int, int> idmap;

	// collect id's.. 
	for(i=0; i<cursize; i++)
	{
		ids.push_back(-1);
	}

	extraIDs = cursize - prevsize;
	if(extraIDs < 0)
		extraIDs = 0;
	matrix.clear();

	// FIXME: we could scale numcheck depending on how many blobs there are
	// if we are tracking a lot of blobs, we could check less.. 
	

	if(cursize <= 4)
		numcheck = 4;
	else if(cursize <= 6)
		numcheck = 3;
	else if(cursize <= 10)
		numcheck = 2;
	else
		numcheck = 1;

	if(prevsize < numcheck)
		numcheck = prevsize;
	
	if(current.size() > 0)
		permute2(0);


	unsigned int num_results = matrix.size();

	//if(cursize > 0)
		//printf("matrix size: %d\n", num_results);

	// loop through all the potential ID configurations and find one with lowest error
	float best_error = 99999, error;
	int best_error_ndx = -1;

	for(j=0; j<num_results; j++)
	{
		error = 0;
		// get the error for each blob and sum
		for(i=0; i<cursize; i++)			
		{
			CFinger *f = 0;

			if(matrix[j][i] != -1) 
			{
				error += current[i].error[matrix[j][i]];
			}
		}

		if(error < best_error)
		{
			best_error = error;
			best_error_ndx = j;		
		}
	}

	// now that we know the optimal configuration, set the IDs and calculate some things..
	if(best_error_ndx != -1)
	{
		for(i=0; i<cursize; i++)
		{
			if(matrix[best_error_ndx][i] != -1)
				current[i].ID = (*prev)[matrix[best_error_ndx][i]].ID;
			else
				current[i].ID = -1;

			if(current[i].ID != -1)
			{
				CFinger *oldfinger = &(*prev)[matrix[best_error_ndx][i]];
				current[i].delta = (current[i].center - oldfinger->center);
				current[i].deltaArea = current[i].area - oldfinger->area;
				current[i].predictedPos = current[i].center + current[i].delta;
				current[i].displacement = oldfinger->displacement + current[i].delta;
			} else {
				current[i].delta = vector2df(0, 0);
				current[i].deltaArea = 0;
				current[i].predictedPos = current[i].center;
				current[i].displacement = vector2df(0.0f, 0.0f);
			}
		}

		//printf("Best index = %d\n", best_error_ndx);
	}


}

void CBlobTracker::gatherEvents()
{
	vector<CFinger> *prev = &history[history.size()-1];

	const unsigned int cursize = (unsigned int) current.size();
	const unsigned int prevsize = (unsigned int) (*prev).size();
	unsigned int i, j;

	// assign ID's for any blobs that are new this frame (ones that didn't get 
	// matched up with a blob from the previous frame).
	for(i=0; i<cursize; i++)
	{
		if(current[i].ID == -1)	
		{
			current[i].ID = currentID;

			currentID ++;
			if(currentID >= 65535)
				currentID = 0;

			doTouchEvent(current[i].getTouchData());
		} else {
			if (current[i].displacement.getLength() >= minimumDisplacementThreshold) {
				current[i].delta = current[i].displacement;
				doUpdateEvent(current[i].getTouchData());
				current[i].displacement = vector2df(0.0f, 0.0f);
			}
		}
	}

	// if a blob disappeared this frame, send a finger up event
	for(i=0; i<prevsize; i++)		// for each one in the last frame, see if it still exists in the new frame.
	{
		bool found = false;
		for(j=0; j<cursize; j++)
		{
			if(current[j].ID == (*prev)[i].ID)
			{
				found = true;
				break;
			}
		}

		if(!found)
		{
			

			if(ghost_frames == 0)
			{
				doUntouchEvent((*prev)[i].getTouchData());
			} else if((*prev)[i].markedForDeletion)
			{
				(*prev)[i].framesLeft -= 1;
				if((*prev)[i].framesLeft <= 0)
					doUntouchEvent((*prev)[i].getTouchData());
				else
					current.push_back((*prev)[i]);	// keep it around until framesleft = 0
			} else
			{
				(*prev)[i].markedForDeletion = true;
				(*prev)[i].framesLeft = ghost_frames;
				current.push_back((*prev)[i]);	// keep it around until framesleft = 0
			}

		}
	}
}

inline void CBlobTracker::permute2(int start)
{  
  if (start == ids.size()) 
  {

		  //for( int i=0; i<start; i++)
		  //{
			//printf("%d, ", ids[i]);
		  //}
		  //printf("--------\n");
		  matrix.push_back(ids);

  }
  else 
  {
	  int numchecked=0;

	  for(int i=0; i<current[start].closest.size(); i++)
	  {
		if(current[start].error[current[start].closest[i]] > reject_distance_threshold)
			break;

		ids[start] = current[start].closest[i];
		if(checkValid(start))
		{
			permute2(start+1);
			numchecked++;

		}

		if(numchecked >= numcheck)
			break;
	  }

	  if(extraIDs > 0)
	  {
			ids[start] = -1;		// new ID
			if(checkValidNew(start))
			{
				permute2(start+1);
			}
	  }



  }
}

inline bool CBlobTracker::checkValidNew(int start)
{
	int newidcount = 0;

	newidcount ++;
	for(int i=0; i<start; i++)
	{
	  if(ids[i] == -1)
		  newidcount ++;
	}

	// Check to see whether we have too many 'new' id's 
	if(newidcount > extraIDs)		//extraIDs > 0 
	  return false;

	return true;
}

inline bool CBlobTracker::checkValid(int start)
{

	for(int i=0; i<start; i++)
	{
	  // check to see whether this ID exists already
	  if(ids[i] == ids[start])
		  return false;
	}

  return true;
}

float CBlobTracker::getError(CFinger &old, CFinger &cur)
{
	//vector2df dev = cur.center - old.predictedPos;

	vector2df dev = cur.center - old.center;

	// FIXME: improve

	return (float) dev.getLength();
}

