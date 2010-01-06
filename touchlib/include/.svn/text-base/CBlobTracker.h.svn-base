#ifndef __TOUCHLIB_CBLOBTRACKER__
#define __TOUCHLIB_CBLOBTRACKER__

#include <vector>
#include <math.h>
#include <vector2d.h>
#include <rect2d.h>

#include <Image.h>
#include <touchlib_platform.h>
#include "ITouchListener.h"
#include "TouchData.h"

#include "IBlobTracker.h"


#define HISTORY_FRAMES	10

// a finger is a blob with an ID and prediction info
// CFinger should be able to accept a CBlob as a constructor

namespace touchlib
{

	class TOUCHLIB_CORE_EXPORT CBlob
	{
    public:
		CBlob()
		{
			area = 0.0f;
			weight = 0.0f;
			tagID = 0;
		}
		vector2df center;
		float area;
		rect2df box;
		float angle;
		float weight;

		int tagID;		// for fiducal markers. 0 = regular touchpoint.
	};


	struct BlobEquiv
	{
		unsigned char from;
		unsigned char to;
		int x;
		int y;
	};

    //////////////

	class TOUCHLIB_CORE_EXPORT CFinger : public CBlob
	{
	public:
		CFinger() 
		{
			ID = -1;
			markedForDeletion = false;
			framesLeft = 0;

		}

		CFinger(const CBlob &b)
		{
			ID = -1;
			center = b.center;
			area = b.area;
			box = b.box;
			angle = b.angle;
			weight = b.weight;
			tagID = b.tagID;
		}

		int getLowestError()
		{
			int best=-1;
			float best_v=99999.0f;

			for(unsigned int i=0; i<error.size(); i++)
			{
				if(error[i] < best_v)
				{
					best = i;
					best_v = error[i];
				}
			}

			return best;
		};

		TouchData getTouchData()
		{
			TouchData data;
			data.ID = ID;
			data.X = center.X;
			data.Y = center.Y;

			data.angle = angle;
			data.width = box.getWidth();
			data.height = box.getHeight();

			data.dX = delta.X;
			data.dY = delta.Y;

			data.weight = weight;
			
			data.tagID = tagID;

			return data;
		};

		int ID;

		vector2df delta;
		vector2df predictedPos;

		vector2df displacement;

		float deltaArea;

		bool markedForDeletion;
		int framesLeft;

		std::vector<float> error;
		std::vector<int> closest;		// ID's of the closest points, sorted..
	};



	class TOUCHLIB_EXPORT CBlobTracker : public IBlobTracker
	{
	public:
		CBlobTracker();

		void findBlobs(BwImage &img);
		void trackBlobs();
		void gatherEvents();

	private:
		inline void permute2(int k);
		inline bool checkValid(int start);
		inline bool checkValidNew(int start);

		int level;
		float getError(CFinger &old, CFinger &cur);


#ifdef WIN32
#pragma warning( disable : 4251 )  // http://www.unknownroad.com/rtfm/VisualStudio/warningC4251.html
#endif

		int currentID;
		int extraIDs;
		int numcheck;

		std::vector<std::vector<int> > matrix;
		std::vector<int> ids;
		std::vector<std::vector<CFinger> > history;
		std::vector<CBlob> blobList;
		std::vector<CFinger> current;

#ifdef WIN32
#pragma warning( default : 4251 )
#endif

	};

}

#endif // __TOUCHLIB_CBLOBTRACKER__
