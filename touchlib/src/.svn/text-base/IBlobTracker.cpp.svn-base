#include "IBlobTracker.h"

#include <map>

using namespace std;

using namespace touchlib;

const float IBlobTracker::DEFAULT_MINIMUM_DISPLACEMENT_THRESHOLD = 1.5f;

IBlobTracker::IBlobTracker()
{
	// note: CTouchscreen will set it's own defaults (and also read from the config file)
	// so changing these here won't do much
	reject_distance_threshold = 250;
	reject_min_dimension = 2;
	reject_max_dimension = 250;
	minimumDisplacementThreshold = DEFAULT_MINIMUM_DISPLACEMENT_THRESHOLD;

	ghost_frames = 0;
}

void IBlobTracker::setup(int r_dist, int r_min_dim, int r_max_dim, int g_frames, float minimumDisplacementThreshold)
{
	reject_distance_threshold = r_dist;
	reject_min_dimension = r_min_dim;
	reject_max_dimension = r_max_dim;

	ghost_frames = g_frames;

	this->minimumDisplacementThreshold = minimumDisplacementThreshold;
}

void IBlobTracker::registerListener(ITouchListener *listener)
{
	listenerList.push_back(listener);
}


void IBlobTracker::doTouchEvent(const TouchData& data)
{
	unsigned int i;
	for(i=0; i<listenerList.size(); i++)
	{
		listenerList[i]->fingerDown(data);
	}
}


void IBlobTracker::doUpdateEvent(const TouchData& data)
{
	unsigned int i;
	for(i=0; i<listenerList.size(); i++)
	{
		listenerList[i]->fingerUpdate(data);
	}
}

void IBlobTracker::doUntouchEvent(const TouchData& data)
{
	unsigned int i;
	for(i=0; i<listenerList.size(); i++)
	{
		listenerList[i]->fingerUp(data);
	}
}
