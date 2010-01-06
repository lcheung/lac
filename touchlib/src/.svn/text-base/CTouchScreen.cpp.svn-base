/*

	Touchlib

	An open-source library for Multitouch input using computer vision techniques.

	Please see:

	http://www.whitenoiseaudio.com/blog/
	http://www.nuigroup.com/wiki/Touchlib
	http://www.nuigroup.com/
*/

#include "CTouchScreen.h"
#include "CBlobTracker.h"
#include "FilterFactory.h"
#include "tinyxml.h"		// http://www.sourceforge.net/projects/tinyxml
#include <highgui.h>		// Intel Open Source Computer Vision Library

using namespace touchlib;

// If we are using Windows
#ifdef WIN32
// create a thread and mutex
HANDLE CTouchScreen::hThread = 0;
HANDLE CTouchScreen::eventListMutex = 0;
// If Linux or Apple
#else
// create a thread and mutex
pthread_t CTouchScreen::hThread = 0;
pthread_mutex_t CTouchScreen::eventListMutex = PTHREAD_MUTEX_INITIALIZER;
#endif

// FIXME: Maybe some of this calibration stuff should be moved to the config app

CTouchScreen::CTouchScreen()
{
	// Initialize BwImage frame
	frame = 0;

#ifdef WIN32
	tracker = 0;	// just reset the pointer to be safe...
	eventListMutex = CreateMutex(NULL, 0, NULL);	// Initialize Windows mutex
#else
	pthread_mutex_init(&eventListMutex, NULL);	// Initialize Linux/Apple mutex
#endif

/** These are all initializations of default config.xml variables	*/
	reject_distance_threshold = 250;	// The distance and
	reject_min_dimension = 2;			// min
	reject_max_dimension = 250;			// max dimension limits on blobs

	ghost_frames = 0;
	minimumDisplacementThreshold = IBlobTracker::DEFAULT_MINIMUM_DISPLACEMENT_THRESHOLD;

	screenBB = rect2df(vector2df(0.0f, 0.0f), vector2df(1.0f, 1.0f));	// Initialize the screen bounding box
	initScreenPoints();		// Calculates the calibration points based on a 4:3 aspect ratio
	initCameraPoints();		// Calculates the camera resolution or defaults to 640x480

	debugMode = true;		// Initialization assumes you want to show trackbar sliders in your windows for manual calibration
	bTracking = false;		// We are not yet tracking any blobs, so we initialize this flag to false

	screenMesh.recalcBoundingBox();		// Initialize the screen mesh

	// Initialize the triangles[72] with the [GRID_X * GRID_Y * 2t * 3i] indices for the points
	int i,j;
	int t = 0;
	for(j=0; j<GRID_Y; j++)
	{
		for(i=0; i<GRID_X; i++)
		{
			triangles[t+0] = (i+0) + ((j+0) * (GRID_X+1));
			triangles[t+1] = (i+1) + ((j+0) * (GRID_X+1));
			triangles[t+2] = (i+0) + ((j+1) * (GRID_X+1));

			t += 3;

			triangles[t+0] = (i+1) + ((j+0) * (GRID_X+1));
			triangles[t+1] = (i+1) + ((j+1) * (GRID_X+1));
			triangles[t+2] = (i+0) + ((j+1) * (GRID_X+1));

			t += 3;
		}
	}


	bCalibrating = false;		// Set the calibration flag to false (toggled when recording finger data as new mesh points)
	calibrationStep = 0;		// Start at the beginning


	this->tracker = NULL;	// create a default blob tracker
        setBlobTracker(new CBlobTracker());
}

void CTouchScreen::setBlobTracker(IBlobTracker* blobTracker)
{
	// Check that the tracker isn't in use
	// FIXME: add a mutex so that it is interchangable
	if (bTracking) {
		return;
	}

	// Free the old tracker
	if (tracker != NULL) {
		delete tracker;
	}

	// Save the new tracker and register with it
	tracker = blobTracker;
	tracker->registerListener((ITouchListener *)this);
}

CTouchScreen::~CTouchScreen()
{
	unsigned int i;

#ifdef WIN32
	if(hThread)							// Check for existing thread
		TerminateThread(hThread, 0);	// if it exists, then terminate it and reinitialize hThread with 0

	CloseHandle(eventListMutex);		// Uninitialize the mutex
#else
	if(hThread){					// Check for existing thread
		pthread_kill(hThread,15);	// if it exists, then terminate it
		hThread = 0;				// and reinitialize hThread with 0
	}

	pthread_mutex_destroy(&eventListMutex);	// Uninitialize the mutex
#endif


	for(i=0; i<filterChain.size(); i++)		// Go through and delete each filter
		delete filterChain[i];


	delete tracker;
}

void CTouchScreen::initScreenPoints()
{
	int p = 0;	// Create some local variable placeholders

	int i,j;

	vector2df xd(screenBB.lowerRightCorner.X-screenBB.upperLeftCorner.X,0.0f);		// Get the bounding box dimensions
	vector2df yd(0.0f, screenBB.lowerRightCorner.Y-screenBB.upperLeftCorner.Y);
	xd /= (float) GRID_X;		// divide and assign by
	yd /= (float) GRID_Y;		// the default 4:3 aspect ratio from ITouchScreen.h

	for(j=0; j<=GRID_Y; j++)
	{
		for(i=0; i<=GRID_X; i++)	// For each point
		{
			screenPoints[p] = screenBB.upperLeftCorner + xd*i + yd*j;			// Set each screen point to the corrosponding grid index
			printf("(%d, %d) = (%f, %f)\n", i, j, screenPoints[p].X, screenPoints[p].Y);	// Display a little feedback to the terminal
			p++;
		}
	}
}

void CTouchScreen::initCameraPoints()
{
	int p = 0;

	float cw = 640.0, ch = 480.0; // 640x480 default if no frame is available

	// try and get a frame from the filter stack, and we'll use that as our frame size
	if(filterChain.size() > 0) {		// If we have a filter
		filterChain[0]->process(NULL);	// send process on a dry run to initialize the camera resolution parameters
		IplImage *output = filterChain.back()->getOutput();		// return the captured frame from the last filter as a IplImage object

		cw = (float)output->width;		// extract the camera frame width
		ch = (float)output->height;		// and height from the IplImage object
	}

	int i,j;
	for(j=0; j<=GRID_Y; j++)
	{
		for(i=0; i<=GRID_X; i++)		// For each point in the grid
		{
			// Set each camera point the the corrosponding grid index
			cameraPoints[p] = vector2df((i * cw) / (float)GRID_X, (j * ch) / (float)GRID_Y);
			p++;
		}
	}
}


IplImage* CTouchScreen::getFilterImage(std::string & label)
{
	std::map<std::string,Filter*>::iterator iter = filterMap.find(label);		// Get the chosen filter
	if(iter == filterMap.end())				// If we have reached the last filter
		return NULL;						// then exit
	return iter->second->getOutput();		// otherwise, return the next IplImage from the filter
}

IplImage* CTouchScreen::getFilterImage(int step)
{
	step = step >= filterChain.size() ? filterChain.size()-1:step;		// If the requested step is greater than the total number of filters, reduce until equal
	step = step < 0? 0:step;											// If the requested step is less than 0, step now equals 0
	return filterChain[step]->getOutput();								// Return the latest IplImage from the filter
}

void CTouchScreen::setScreenScale(float s)
{
	// legacy
	float offset = (1.0f - s)*0.5f;
	screenBB = rect2df(vector2df(offset,offset),vector2df(1.0f-offset,1.0f-offset));
	initScreenPoints();
}

float CTouchScreen::getScreenScale()
{
	// legacy, take the minimum scale value that fits inside the bounding box
	float minValL = MIN(screenBB.lowerRightCorner.X,screenBB.lowerRightCorner.Y);
	minValL = 1.0f - minValL;
	float minValU = MAX(screenBB.upperLeftCorner.X,screenBB.upperLeftCorner.Y);
	float minVal = MIN(minValL,minValU);
	return 1.0f - (2.0f * minVal);
}

void CTouchScreen::setScreenBBox(rect2df &box)
{
	screenBB = box;
	initScreenPoints();
}

void CTouchScreen::registerListener(ITouchListener *listener)
{
	// Add new ITouchListener to the end of the list
	listenerList.push_back(listener);
}


bool CTouchScreen::process()
{
	// The main event loop for this CTouchScreen instance
	while(1) {
		if(filterChain.size() == 0)		// If there are no filters
			return false;				// error out
		//printf("Process chain\n");
		filterChain[0]->process(NULL);	// Otherwise go to the first filter
		IplImage *output = filterChain.back()->getOutput(); // and get the first frame

		if(output != NULL) {			// If there is output to get
			//printf("Process chain complete\n");
			frame = output;		// assign it to the private CTouchScreen::frame variable

			if(bTracking == true)		// If we are currently tracking blobs
			{
				//printf("Tracking 1\n");
				tracker->findBlobs(frame);		// Locate the blobs
				tracker->trackBlobs();			// and update their location

#ifdef WIN32
				DWORD dw = WaitForSingleObject(eventListMutex, INFINITE);
				//dw == WAIT_OBJECT_0
				if(dw == WAIT_TIMEOUT || dw == WAIT_FAILED) {		// If locking the mutex failed
					// handle time-out error
					//throw TimeoutExcp();
					printf("Failed %d", dw);						// output result to terminal

				}
				else 		// Locking the mutex succeeds
				{
					//printf("Tracking 2\n");
					tracker->gatherEvents();			// then find out which blobs are new and track the old blob's movement
					ReleaseMutex(eventListMutex);		// and unlock the mutex
				}
#else
				int err;
				if((err = pthread_mutex_lock(&eventListMutex)) != 0){
					// some error occured
					fprintf(stderr,"locking of mutex failed\n");
				}else{
					tracker->gatherEvents();	// then find out which blobs are new and track the old blob's movement
					pthread_mutex_unlock(&eventListMutex);		// and unlock the mutex
				}
#endif
			}
			//return true;
		}
		//SLEEP(32);
	}

}


void CTouchScreen::getRawImage(char **img, int &width, int &height)
{
	*img = ((IplImage *)frame.imgp)->imageData;		// *img gets assigned the pointer to the aligned image data
	width = frame.getWidth();						// then assign the width
	height = frame.getHeight();						// and height from the frame data
	return;
}


void CTouchScreen::saveConfig(const char* filename)
{
	ParameterMap pMap;					// Create a pMap to store the filter attributes
	ParameterMap::iterator pMapItr;		// Create an iterator to cycle through each attribute

	TiXmlDocument doc(filename);		// Create a TinyXML document and assign it an xml file
	TiXmlDeclaration* decl = new TiXmlDeclaration("1.0", "", "");		// Make the <?xml version="1.0" ?> tag
	doc.LinkEndChild(decl);												// Add the tag to the document


	char sztmp[50];			// Create sztmp[] to convert each attribute value to a (char *)

	TiXmlElement* configElement = new TiXmlElement("blobconfig");		// Create the <blobconfig> tag
	doc.LinkEndChild(configElement);		// Add the tag to the document


	configElement->SetAttribute("distanceThreshold", reject_distance_threshold);		// Add distanceThreshold="250"
	configElement->SetAttribute("minDimension", reject_min_dimension);					// Add minDimension="2"
	configElement->SetAttribute("maxDimension", reject_max_dimension);					// Add maxDimension="250"
	configElement->SetAttribute("ghostFrames", ghost_frames);							// Add ghostFrames="0"
	sprintf(sztmp, "%f", minimumDisplacementThreshold);									// Convert minimumDisplacementThreshold float to a (char *)
	configElement->SetAttribute("minDisplacementThreshold", sztmp);						// Add minDisplacementThreshold="2.000000"



	TiXmlElement* bbelement = new TiXmlElement("bbox");		// Create the <bbox> tag
	sprintf(sztmp, "%f", screenBB.upperLeftCorner.X);		// Convert screenBB.upperLeftCorner.X float to a (char *)
	bbelement->SetAttribute("ulX", sztmp);					// Add ulX="0.000000"
	sprintf(sztmp, "%f", screenBB.upperLeftCorner.Y);		// Convert screenBB.upperLeftCorner.Y float to a (char *)
	bbelement->SetAttribute("ulY", sztmp);					// Add ulY="0.000000"
	sprintf(sztmp, "%f", screenBB.lowerRightCorner.X);		// Convert screenBB.lowerRightCorner.X float to a (char *)
	bbelement->SetAttribute("lrX", sztmp);					// Add lrX="1.000000"
	sprintf(sztmp, "%f", screenBB.lowerRightCorner.Y);		// Convert screenBB.lowerRightCorner.Y float to a (char *)
	bbelement->SetAttribute("lrY", sztmp);					// Add lrY="1.000000"
	doc.LinkEndChild(bbelement);							// Add the tag to the document

	TiXmlElement* screenRoot = new TiXmlElement("screen");	// Create <screen> tag
	doc.LinkEndChild(screenRoot);		// Add the tag to the document
	int i;

	for(i=0; i<GRID_POINTS; i++)		// Cycle through each grid point
	{

		TiXmlElement* element = new TiXmlElement("point");		// Create <point> tag
		sprintf(sztmp, "%f", cameraPoints[i].X);				// Convert cameraPoints[i].X vector2df to a (char *)
		element->SetAttribute("X", sztmp);						// Add X="[each grid point]"
		sprintf(sztmp, "%f", cameraPoints[i].Y);				// Convert cameraPoints[i].Y vector2df to a (char *)
		element->SetAttribute("Y", sztmp);						// Add Y="[each grid point]"
		screenRoot->LinkEndChild(element);						// Insert tag between <screen> and </screen>
	}


	TiXmlElement* fgRoot = new TiXmlElement("filtergraph");		// Create <filtergraph> tag
	doc.LinkEndChild(fgRoot);									// Add the tag to the document

	for(i = 0; i < filterChain.size(); i++)		// Cycle through each filter
	{
		TiXmlElement* element = new TiXmlElement(filterChain[i]->getType());		// Create <[filter type]> tag
		element->SetAttribute("label", filterChain[i]->getName());					// Add label="[filter name]"

		filterChain[i]->getParameters(pMap);		// load filter attributes into pMap

		for(pMapItr = pMap.begin(); pMapItr != pMap.end(); pMapItr++)		// Cycle through each attribute
		{
			TiXmlElement* param = new TiXmlElement(pMapItr->first.c_str());		// Create a <[attribute type]> tag
			param->SetAttribute("value", pMapItr->second.c_str());				// Add value="[attribute value]"
			element->LinkEndChild(param);										// Insert tag between <[filter type]> and </[filter type]>
		}

		fgRoot->LinkEndChild(element);		// Insert between <filtergraph> and </filtergraph>
		pMap.clear();						// Reinitialize pMap for next filter
	}
	doc.SaveFile();							// Write document to file
}



bool CTouchScreen::loadConfig(const char* filename)
{
	TiXmlDocument doc(filename);		// Create a TinyXML document and load xml file

	if(!doc.LoadFile())			// Check <?xml version="1.0" ?> tag
		return false;			// If the tag is wrong, then exit out

	TiXmlElement* configElement = doc.FirstChildElement("blobconfig");					// Begin with the <blobconfig> tag
	if(configElement){																	// and if it exists
		configElement->Attribute("distanceThreshold", &reject_distance_threshold);		// Get the distanceThreshold
		configElement->Attribute("minDimension", &reject_min_dimension);				// Get the minDimension
		configElement->Attribute("maxDimension", &reject_max_dimension);				// Get the maxDimension
		configElement->Attribute("ghostFrames", &ghost_frames);							// Get the ghostFrames

		double temp;
		configElement->Attribute("minDisplacementThreshold", &temp);					// Get the minDisplacementThreshold
		minimumDisplacementThreshold = (float) temp;									// Set the minimumDisplacementThreshold
	}

	// set up some configuration variables
	tracker->setup(reject_distance_threshold, reject_min_dimension, reject_max_dimension, ghost_frames, minimumDisplacementThreshold);

	TiXmlElement* bboxRoot = doc.FirstChildElement("bbox");									// Get <bbox> tag
	if(bboxRoot){																			// and if it exists
		vector2df ul(atof(bboxRoot->Attribute("ulX")),atof(bboxRoot->Attribute("ulY")));	// Get the upper left X,Y
		vector2df lr(atof(bboxRoot->Attribute("lrX")),atof(bboxRoot->Attribute("lrY")));	// Get the lower right X,Y
		rect2df bb(ul,lr);																	// Create a bounding box variable
		setScreenBBox(bb);																	// Load screenBB and initialize the new screen points
	}else{																					// and if it doesn't exist
		setScreenScale(1.0f);																// Load screenBB to default and initialize the new screen points
	}

	TiXmlElement* screenRoot = doc.FirstChildElement("screen");			// Get <screen> tag

	printf("Reading camera points\n");									// Announce to terminal
	if(screenRoot)														// and if it exists
	{

		int i=0;
		for(TiXmlElement* pointElement = screenRoot->FirstChildElement();	// Cycle through each <point> tag
			pointElement != NULL;
			pointElement = pointElement->NextSiblingElement())
		{
			cameraPoints[i] = vector2df(atof(pointElement->Attribute("X")),atof(pointElement->Attribute("Y")));		// and extract each X,Y value
			printf("%f, %f\n", cameraPoints[i].X,cameraPoints[i].Y);		// Announce coordinates to terminal
			i++;

		}
	}

	TiXmlElement* fgRoot = doc.FirstChildElement("filtergraph");		// Get <filtergraph> tag

	if(fgRoot)															// and if it exists
	{


		for(TiXmlElement* filterElement = fgRoot->FirstChildElement();					// Cycle through each filter
			filterElement != NULL;
			filterElement = filterElement->NextSiblingElement())
		{
			pushFilter(filterElement->Value(), filterElement->Attribute("label"));		// Create a new Filter window [filter type] and [filter name] from tag
			// fixme: we should check to see whether pushfilter succeeded.
			if(filterChain.size() > 0)													// If there are any Filter attributes
			{
				Filter* curFilter = filterChain[filterChain.size()-1];					// Apply them to the new Filter

				for(TiXmlElement* paramElement = filterElement->FirstChildElement();	// Cycle through each Filter attribute
					paramElement != NULL;
					paramElement = paramElement->NextSiblingElement())
				{
						curFilter->setParameter(paramElement->Value(), paramElement->Attribute("value"));		// Load the value of each Filter attribute found
				}
			}
		}

	}
	return true;
}

std::list<std::string> CTouchScreen::findFilters(const char * type)
{
	std::list<std::string> filters;																		// Make a list
	for(std::vector<Filter*>::iterator iter = filterChain.begin();iter!=filterChain.end();iter++){		// and for each Filter
		if(!strcmp((*iter)->getType(),type)){															// if the type is the one sought
			filters.push_back(std::string((*iter)->getName()));											// add the name to the list
		}
	}
	return filters;																						// and return the list
}

std::string CTouchScreen::findFirstFilter(const char * type)
{
	std::string filter;
	for(std::vector<Filter*>::iterator iter = filterChain.begin();iter!=filterChain.end();iter++){		// Cycle through each Filter
		if(!strcmp((*iter)->getType(),type)){															// if the type is the one sought
			filter = (*iter)->getName();																// Get the Filter name
			break;																						// stop cycling through the list
		}
	}
	return filter;																						// and return it
}

void CTouchScreen::setParameter(std::string & label, char *param, char *value)
{
	std::map<std::string,Filter*>::iterator iter = filterMap.find(label);		// Cycle through list until Filter found
	if(iter == filterMap.end())													// If at the end of the list
		return;																	// then exit
	iter->second->setParameter(param, value);									// Otherwise assign the parameter and value to the Filter
}

std::string CTouchScreen::pushFilter(const char *type, const char * inlabel)
{
	std::string label;							// Filter label
	unsigned int n = filterChain.size();		// Number of Filters
	if(inlabel){								// If label name is passed
		label = inlabel;						// Set Filter label to name
	}else{										// Otherwise
		label = type;							// Set Filter label to type
		// ugly, but a pain with safe functions because of windows function names
		char buffer[20];						// Create buffer
		sprintf(buffer,"%d",n);					// Set buffer to number of Filters
		label += buffer;						// Append the number to the new label name
	}
	Filter *newfilt = FilterFactory::createFilter(type, label.c_str());		// Create a new Filter and pointer to it

	if(newfilt)												// If the pointer was successfully created
	{
		// lets tile all the output windows nicely


		// FIXME: we are assuming 1024 x 768 screen res. We should
		// have a cross platform way to get the current screen res.

		// also we are assuming a camera res of 320x200..
		int num_per_row = 1024 / 320;
		int i = n % num_per_row;
		int j = n / num_per_row;
		newfilt->showOutput(debugMode, i*320, j * 200);		// Display Filter window

		if(filterChain.size() > 0)							// If there exists at least one other Filter in the list
			filterChain.back()->connectTo(newfilt);			// then point the end of the list to the new Filter

		filterChain.push_back(newfilt);						// Make the new Filter the end of the list
		filterMap.insert(std::make_pair(label,newfilt));	// Add new Filter to the filter map
		return label;										// and return the name of the Filter
	}
	return std::string();									// If no pointer to a new filter then return a NULL string
}


void CTouchScreen::doTouchEvent(TouchData data)
{
	unsigned int i;
	for(i=0; i<listenerList.size(); i++)		// Cycle through all the ITouchListeners
	{
		listenerList[i]->fingerDown(data);		// and check for new finger blobs
	}
}


void CTouchScreen::doUpdateEvent(TouchData data)
{
	unsigned int i;
	for(i=0; i<listenerList.size(); i++)		// Cycle through all the ITouchListeners
	{
		listenerList[i]->fingerUpdate(data);	// and check for finger blob movement
	}
}


void CTouchScreen::doUntouchEvent(TouchData data)
{
	unsigned int i;
	for(i=0; i<listenerList.size(); i++)		// Cycle through all the ITouchListeners
	{
		listenerList[i]->fingerUp(data);		// and check for finger blobs gone
	}
}

void CTouchScreen::fingerDown(TouchData data)
{
	CTouchEvent e;														// Create a CTouchEvent variable

	if(bCalibrating) {													// If we are calibrating the camera points
		cameraPoints[calibrationStep] = vector2df(data.X, data.Y);		// assign the data to the current point
		//printf("%d (%f, %f)\n", calibrationStep, data.X, data.Y);
	}

	transformDimension(data.width, data.height, data.X, data.Y);		// Calculate and assign width and height from data X,Y
	data.area = data.width * data.height;								// Calculate and assign area from width and height

	cameraToScreenSpace(data.X, data.Y);								// Align camera and screen grids

	e.data = data;														// Assign the data to the CTouchEvent
	e.type = TOUCH_PRESS;												// Assign the event to the fingerDown type

	e.data.dX = 0;														// We are not tracking a moving blob yet
	e.data.dY = 0;														// so we will initialize the movement deltas

	eventList.push_back(e);												// Add the CTouchEvent to the end of the eventList
}


void CTouchScreen::fingerUp(TouchData data)
{
	CTouchEvent e;														// Create local CTouchEvent variable

	float tx, ty;														// Create local X,Y variable

	tx = data.X + data.dX;												// Add blob movement delta to last blob position
	ty = data.Y + data.dY;												// for both X,Y and assign it to the local X,Y

	transformDimension(data.width, data.height, data.X, data.Y);		// Calculate and assign width and height from data X,Y
	data.area = data.width * data.height;								// Calculate and assign area from width and height

	cameraToScreenSpace(data.X, data.Y);								// Convert camera data X,Y coordinates to screen coordinates
	cameraToScreenSpace(tx, ty);										// Convert local X,Y coordinates to screen coordinates

	e.data = data;														// Assign the data to the CTouchEvent
	e.type = TOUCH_RELEASE;												// Assign the event the fingerUp type
	e.data.dX = tx - data.X;											// Assign both X,Y blob movement delta
	e.data.dY = ty - data.Y;											// now that they have been converted to screen coordinates

	eventList.push_back(e);												// Add the CTouchEvent to the end of the eventList
}


void CTouchScreen::fingerUpdate(TouchData data)
{
	CTouchEvent e;														// Create local CTouchEvent variable

	float tx, ty;														// Create local X,Y variable

	tx = data.X + data.dX;												// Add blob movement delta to last blob position
	ty = data.Y + data.dY;												// for both X,Y and assign it to the local X,Y

	transformDimension(data.width, data.height, data.X, data.Y);		// Calculate and assign width and height from data X,Y
	data.area = data.width * data.height;								// Calculate and assign area from width and height

	cameraToScreenSpace(data.X, data.Y);								// Convert camera data X,Y coordinates to screen coordinates
	cameraToScreenSpace(tx, ty);										// Convert local X,Y coordinates to screen coordinates

	e.data = data;														// Assign the data to the CTouchEvent
	e.type = TOUCH_UPDATE;												// Assign the event the fingerUpdate type
	e.data.dX = tx - data.X;											// Assign both X,Y blob movement delta
	e.data.dY = ty - data.Y;											// now that they have been converted to screen coordinates

	eventList.push_back(e);												// Add the CTouchEvent to the end of the eventList
}

void CTouchScreen::transformDimension(float &width, float &height, float centerX, float centerY)
{
	// transform width/height
        float halfX = width * 0.5f;
        float halfY = height * 0.5f;

        float ulX = centerX - halfX;
        float ulY = centerY - halfY;
        float lrX = centerX + halfX;
        float lrY = centerY + halfY;

        cameraToScreenSpace(ulX, ulY);
        cameraToScreenSpace(lrX, lrY);

        width = lrX - ulX;
        height = ulY - lrY;
}



bool isPointInTriangle(vector2df p, vector2df a, vector2df b, vector2df c)
{
	if (vector2df::isOnSameSide(p,a, b,c) && vector2df::isOnSameSide(p,b, a,c) && vector2df::isOnSameSide(p, c, a, b))
		return true;
    else
		return false;
}



int CTouchScreen::findTriangleWithin(vector2df pt)
{
	int t;

	for(t=0; t<GRID_INDICES; t+=3)
	{
		if( isPointInTriangle(pt, cameraPoints[triangles[t]], cameraPoints[triangles[t+1]], cameraPoints[triangles[t+2]]) )
		{
			return t;
		}
	}

	return -1;
}


// Transforms a camera space coordinate into a screen space coord
void CTouchScreen::cameraToScreenSpace(float &x, float &y)
{
	vector2df pt(x, y);						// Put coordinates into a vector
	int t = findTriangleWithin(pt);			// so you can find which triangle contains it

	if(t != -1)								// If the right triangle is found
	{

		vector2df A = cameraPoints[triangles[t+0]];			// Place camera vector triangle points
		vector2df B = cameraPoints[triangles[t+1]];			// into some local vectors
		vector2df C = cameraPoints[triangles[t+2]];
		float total_area = (A.X - B.X) * (A.Y - C.Y) - (A.Y - B.Y) * (A.X - C.X);		// Calculate the total area of the triangle

		// pt,B,C
		float area_A = (pt.X - B.X) * (pt.Y - C.Y) - (pt.Y - B.Y) * (pt.X - C.X);		// and find the area enclosed by the

		// A,pt,C
		float area_B = (A.X - pt.X) * (A.Y - C.Y) - (A.Y - pt.Y) * (A.X - C.X);			// three camera vector triangle points

		float bary_A = area_A / total_area;												// so we can find three fractions of the total area
		float bary_B = area_B / total_area;
		float bary_C = 1.0f - bary_A - bary_B;	// bary_A + bary_B + bary_C = 1

		vector2df sA = screenPoints[triangles[t+0]];									// Place screen vector triangle points
		vector2df sB = screenPoints[triangles[t+1]];									// into some local vectors
		vector2df sC = screenPoints[triangles[t+2]];

		vector2df transformedPos;														// Create a temporary vector variable

		transformedPos = (sA*bary_A) + (sB*bary_B) + (sC*bary_C);						// Calculate the new vector adjustment

		x = transformedPos.X;															// Change the value of x
		y = transformedPos.Y;															// Change the value of y
		return;
	}

	x = 0;			// If the right triangle is not found
	y = 0;			// then initialize x,y = 0

	// FIXME: what to do in the case that it's outside the mesh?
}

THREAD_RETURN_TYPE CTouchScreen::_processEntryPoint(void * obj)
{
	((CTouchScreen *)obj)->process();									// Make a handle for this CTouchScreen
}


void CTouchScreen::beginProcessing()
{
#ifdef WIN32
	hThread = (HANDLE)_beginthread(_processEntryPoint, 0, this);		// Get the handle for _this_ CTouchScreen object and assign to local handle
	//SetThreadPriority(hThread, THREAD_PRIORITY_ABOVE_NORMAL);
#else
	pthread_create(&hThread,0,_processEntryPoint,this);
#endif
}


void CTouchScreen::getEvents()
{
	unsigned int i=0;

#ifdef WIN32
	DWORD dw = WaitForSingleObject(eventListMutex, INFINITE);		// Wait for the mutex
	//dw == WAIT_OBJECT_0
	if(dw == WAIT_TIMEOUT || dw == WAIT_FAILED) {					// If you don't lock the mutex
		// handle time-out error
		//throw TimeoutExcp();
		printf("Failed %d", dw);									// announce it to the terminal
		return;														// and exit
	}
#else
	int err;
	if((err = pthread_mutex_lock(&eventListMutex)) != 0){
		// some error occured
		fprintf(stderr,"locking of mutex failed\n");
		return;
	}
#endif
	for(i=0; i<eventList.size(); i++)							// Cycle through each event in the eventList
		{
			switch(eventList[i].type)							// Retrieve the event type
				{
				case TOUCH_PRESS:								// For new blobs
					doTouchEvent(eventList[i].data);			// Send new blob data to the ITouchListener
					break;
				case TOUCH_RELEASE:								// For blob gone
					doUntouchEvent(eventList[i].data);			// Send blob gone data to the ITouchListener
					break;
				case TOUCH_UPDATE:								// For moving blobs
					doUpdateEvent(eventList[i].data);			// Send blob moved data to the ITouchListener
					break;
				};
		}

	eventList.clear();											// Then clear the eventList
#ifdef WIN32
	ReleaseMutex(eventListMutex);								// and unlock the mutex
#else
	pthread_mutex_unlock(&eventListMutex);
#endif

}


void CTouchScreen::beginCalibration()
{
	 bCalibrating = true;				// Set the calibration flag to true
	 calibrationStep = 0;				// and reset the step counter
}


void CTouchScreen::nextCalibrationStep()
{
	if(bCalibrating)
	{
		calibrationStep++;
		if(calibrationStep >= GRID_POINTS)
		{

			printf("Calibration complete\n");

			bCalibrating = false;
			calibrationStep = 0;
		}
	}
}

void CTouchScreen::revertCalibrationStep()
{
	if(bCalibrating)
	{
		calibrationStep--;
		if(calibrationStep < 0)
		{
			calibrationStep = 0;
		}
	}
}

// Code graveyard:
/*
// Transforms a camera space coordinate into a screen space coord
void CTouchScreen::cameraToScreenSpace(float &x, float &y)
{
	// Reference: http://www.cescg.org/CESCG97/olearnik/txmap.htm
	// FIXME: these could be precalculated.

	//x = x / 320.0f;
	//y = y / 240.0f;
	//return;

	float ax = screenPoints[0].X;
	float ay = screenPoints[0].Y;

	float bx = screenPoints[1].X -  screenPoints[0].X;
	float by = screenPoints[1].Y -  screenPoints[0].Y;

	float cx = screenPoints[3].X - screenPoints[0].X;
	float cy = screenPoints[3].Y - screenPoints[0].Y;

	float dx = screenPoints[0].X - screenPoints[1].X - screenPoints[3].X + screenPoints[2].X;
	float dy = screenPoints[0].Y - screenPoints[1].Y - screenPoints[3].Y + screenPoints[2].Y;


	float K = (float) ((cx*dy) - (cy*dx));
	float L = (float) ((dx*y) - (dy*x) + (ax*dy) - (ay*dx) + (cx*by) - (cy*bx));
	float M = (float) ((bx*y) - (by*x) + (ax*by));

	float u, v;

	if (K == 0.0)
		v = -M / L;
	else
		v = (float) ((-L - sqrtf((L*L) - (4.0 * K*M) ) ) / (2.0 * K)) ;

	u = (float) ((x - ax - (cx * v)) / (bx + (dx * v)));


	//x = u * 800.0;
	//y = v * 600.0;

	if(u < 0.0f)
		u *= -1.0f;
	if(v < 0.0f)
		v *= -1.0f;

	u *= screenScale;
	v *= screenScale;

	u += 0.5 - (screenScale*0.5);
	v += 0.5 - (screenScale*0.5);

	x = u;
	y = v;
}
*/
