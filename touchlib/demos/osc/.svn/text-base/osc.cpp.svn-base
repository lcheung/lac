// You'll need OSCPack to compile this:
// http://www.audiomulch.com/~rossb/code/oscpack/
// Please set the OSCPACK_HOME directory to the directory where you installed oscpack.. 
// I have included a static LIB for oscpack in the lib dir, 
// so if you are compiling with VC .NET then you don't need to compile oscpack.. 

#ifdef WIN32
#pragma once
#define WIN32_LEAN_AND_MEAN 
#define _WIN32_WINNT  0x0500
#endif

#include <map>
#include <cv.h>
#include <highgui.h>

#include "TouchScreenDevice.h"
#include "TouchData.h"

using namespace touchlib;

#include <stdio.h>
#include <string>


ITouchScreen *screen;

#include "osc/OscOutboundPacketStream.h"
#include "ip/UdpSocket.h"


#define ADDRESS "127.0.0.1"
#define PORT 3333

#define OUTPUT_BUFFER_SIZE 2048

//#define OSC_STRICT 1



///////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////

// FIXME: allow address and port to be specified on the command line or from a config file.. 

class OSCApp : public ITouchListener
{
public:


	OSCApp()
	{
		transmitSocket = NULL;

		frameSeq = 0;

	}

	~OSCApp()
	{
		delete transmitSocket;
	}

	// Set IP and Port with commandline parameters
	void connectSocket(std::string ip_address, int port)
	{			
		transmitSocket = new UdpTransmitSocket( IpEndpointName( ip_address.c_str(), port ) );
		printf("Socket Initialized : %s Port : %i\n\n", ip_address.c_str(), port);
		frameSeq = 0;
	}

	//! Notify that a finger has just been made active. 
	virtual void fingerDown(TouchData data)
	{
		RgbPixel c;
		c.r = 255;
		c.g = 255;
		c.b = 255;

		if(!(data.X == 0.00 && data.Y == 0.00))
		{
			fingerList[data.ID] = data;
			printf("Blob Detected | X: %f Y: %f Area: %f Weight: %f\n", data.X, data.Y, data.area, data.weight);
		}

	}

	//! Notify that a finger has moved 
	virtual void fingerUpdate(TouchData data)
	{

		fingerList[data.ID] = data;

	}

	//! A finger is no longer active..
	virtual void fingerUp(TouchData data)
	{
		std::map<int, TouchData>::iterator iter;


		for(iter=fingerList.begin(); iter != fingerList.end(); iter++)
		{
			if(iter->second.ID == data.ID)
			{
				fingerList.erase(iter);

				return;
			}
		}
	}

	void frame()
	{
		if(!transmitSocket)
			return;

		// send update messages..

		char buffer[OUTPUT_BUFFER_SIZE];
		char buffer2[OUTPUT_BUFFER_SIZE];
		osc::OutboundPacketStream p( buffer, OUTPUT_BUFFER_SIZE );
		osc::OutboundPacketStream p2( buffer2, OUTPUT_BUFFER_SIZE );

		std::map<int, TouchData>::iterator iter1, iter2, iter_last;	    

		if(fingerList.size() > 0)
		{
			//p << osc::BeginBundleImmediate;


			int scount = 0, acount = 0;
			iter1=fingerList.begin();
			
			bool done=false;

			while(!done)
			{
				p.Clear();
				p2.Clear();


				p << osc::BeginBundle();
				p2 << osc::BeginBundle();

				for(; iter1 != fingerList.end(); iter1++)
				{
					TouchData d = (*iter1).second;
					float m = sqrtf((d.dX*d.dX) + (d.dY*d.dY));
					float area = d.area;
				//	printf(d.area);
				//	printf("%d\n", d.tagID);
					if(!(d.X == 0 && d.Y == 0)) {
						if(d.tagID == 0)
						{
// don't send extra info
#ifdef OSC_STRICT
							p << osc::BeginMessage( "/tuio/2Dcur" ) << "set" << d.ID << d.X << d.Y << d.dX << d.dY << m << osc::EndMessage;
#else
							p << osc::BeginMessage( "/tuio/2Dcur" ) << "set" << d.ID << d.X << d.Y << d.dX << d.dY << m << d.width << d.height << osc::EndMessage;
							//pressure
							//p << osc::BeginMessage( "/tuio/2Dcur" ) << "set" << d.ID << d.X << d.Y << d.dX << d.dY << m << d.width << d.height << d.weight << osc::EndMessage;
							
#endif
						} else {
							// is a fiducial tag

							//FIXME: should we send height and width for obj's too?
							p2 << osc::BeginMessage( "/tuio/2Dobj" ) << "set" << d.ID << d.tagID << d.X << d.Y << d.angle << d.dX << d.dY << 0.0 << m << 0.0 << osc::EndMessage;
						}

						scount ++;
						if(scount >= 10)
						{
							scount = 0;
							break;
						}
					}
				}

				if(iter1 == fingerList.end())
					done = true;



				p << osc::BeginMessage( "/tuio/2Dcur" );
				p << "alive";
				p2 << osc::BeginMessage( "/tuio/2Dobj" );
				p2 << "alive";

				for(iter2=fingerList.begin(); iter2 != fingerList.end(); iter2++)
				{
					TouchData d = (*iter2).second;
					if(d.tagID == 0)
					{
						if(!(d.X == 0 && d.Y == 0)) {
							p << d.ID;
						}
					} else {
						if(!(d.X == 0 && d.Y == 0)) {
							p2 << d.ID;
						}
					}
				}
				p << osc::EndMessage;
				p << osc::BeginMessage( "/tuio/2Dcur" ) << "fseq" << frameSeq << osc::EndMessage;
				p << osc::EndBundle;

				p2 << osc::EndMessage;
				p2 << osc::BeginMessage( "/tuio/2Dobj" ) << "fseq" << frameSeq << osc::EndMessage;
				p2 << osc::EndBundle;



				//printf("%d size. %d #fingers\n", p.Size(), fingerList.size());
				frameSeq ++; 
				if(p.IsReady())
					transmitSocket->Send( p.Data(), p.Size() );

				//if(p2.IsReady())
					//transmitSocket->Send( p2.Data(), p2.Size() );
			}


		} else {
			// do we even need to do this?

			//p << osc::BeginBundleImmediate;
			p.Clear();
			p << osc::BeginBundle();

			p << osc::BeginMessage( "/tuio/2Dcur" );
			p << "alive";
			p << osc::EndMessage;

			p << osc::BeginMessage( "/tuio/2Dcur" ) << "fseq" << frameSeq << osc::EndMessage;

			p << osc::EndBundle;

			frameSeq ++;
			//printf("%d size\n", p.Size());

			if(p.IsReady())
				transmitSocket->Send( p.Data(), p.Size() );
		}
	}

	void clearFingers()
	{
		fingerList.clear();
	}

private:
	UdpTransmitSocket *transmitSocket;

	// Keep track of all finger presses.
	std::map<int, TouchData> fingerList;
	int frameSeq;
};

/////////////////////////////////////////////////////////////////////////

OSCApp app;
bool ok=true;


int main(int argc, char * argv[])
{
	std::string ip_address = ADDRESS;
	int port = PORT;

	// Check if command arguments are specified
	if (argc == 3)
	{			
		// Convert parsed values
		ip_address = argv[1];
		port = (int)strtol (argv[2], NULL, 0);	
	}
	
	// Set ip and port
	app.connectSocket(ip_address, port);

	screen = TouchScreenDevice::getTouchScreen();
	screen->setDebugMode(false);
	if(!screen->loadConfig("config.xml"))
	{
		std::string label;
		label = screen->pushFilter("dsvlcapture");
		screen->setParameter(label, "source", "cam");
		screen->pushFilter("mono");
		screen->pushFilter("smooth");
		screen->pushFilter("backgroundremove");

		label = screen->pushFilter("brightnesscontrast");
		screen->setParameter(label, "brightness", "0.1");
		screen->setParameter(label, "contrast", "0.4");
		label = screen->pushFilter("rectify");

		screen->setParameter(label, "level", "25");
		screen->saveConfig("config.xml");
	}

	std::string bgLabel = screen->findFirstFilter("backgroundremove");
	std::string recLabel = screen->findFirstFilter("rectify");
	screen->registerListener((ITouchListener *)&app);
	// Note: Begin processing should only be called after the screen is set up

	SLEEP(1000);
	screen->setParameter(bgLabel, "mask", (char*)screen->getCameraPoints());
	screen->setParameter(bgLabel, "capture", "");

	screen->beginProcessing();
	screen->beginTracking();
    cvNamedWindow( "Touch Listener", CV_WINDOW_AUTOSIZE );
	do
	{
		int keypressed = cvWaitKey(10) & 255;
		
		if(keypressed != 255 && keypressed > 0)
			printf("KP: %d\n", keypressed);

        if( keypressed == 27) break;		// ESC = quit
        if( keypressed == 98)				// b = recapture background
		{
			screen->setParameter(bgLabel, "capture", "");
			app.clearFingers();
		}

        if( keypressed == 114)				// r = auto rectify..
		{
			screen->setParameter(recLabel, "level", "auto");
		}

		screen->getEvents();

		app.frame();

		SLEEP(1);


	} while( ok );


	TouchScreenDevice::destroy();
	return 0;
}
