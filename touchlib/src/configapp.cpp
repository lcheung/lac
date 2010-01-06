#include <stdio.h>

#ifdef WIN32
	#pragma once
	#define WIN32_LEAN_AND_MEAN 
	#define _WIN32_WINNT  0x0500

	#include <windows.h>
	#include <tchar.h>
	
	#pragma comment( lib, "glut32" )
	#pragma comment( lib, "user32" )
#elif defined(__APPLE__)
	#include <GLUT/glut.h>
#else
	#include <GL/glut.h>
#endif

#include <cv.h>
#include <cxcore.h>
#include <highgui.h>
#include <map>

#include "TouchScreenDevice.h"
#include "TouchData.h"
#ifdef WIN32
#include "glut.h"
#endif
using namespace touchlib;

#include <time.h>

#ifdef WIN32
	#include <cvcam.h>
#endif

void glutDrawText(GLfloat x, GLfloat y, char *text);
void glutDrawTexturedBox(float x1, float y1, float x2, float y2, int txtId);
void glutDrawBox(float x1, float y1, float x2, float y2, float r, float g, float b);
void glutDrawPlus(float x1, float y1, float s, float r, float g, float b, float ang);
void glutDrawMarker(float x1, float y1, float s, float r, float g, float b, float ang);
void glutPrepTexture(IplImage *image, int id);
void glutRenderIplImage(int x, int y, IplImage *image);
void printGLError(char *hdr);

static bool keystate[256];
bool ok=true;
ITouchScreen *screen;
int configStep = 0;
int curcalib = -1;
bool captureBox = false;
bool showHelp = true;
int viewFilterStage = 0;
GLuint glTxtTble[10] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
rect2df bBox(vector2df(0.0f,0.0f),vector2df(1.0f,1.0f));
rect2df previewBox(vector2df(0.0f,0.0f),vector2df(0.15f,0.25f));
static float rotAng = 0.0f;

std::string backgroundLabel;

class FingerElement
{
public:
	FingerElement()
	{
	}
	FingerElement(RgbPixel c, TouchData d)
	{
		color = c;
		data = d;

	}
	RgbPixel color;
	TouchData data;
	void draw()
	{
		if (configStep == 1) {
			
	                float X = (data.X*2.0f) - 1.0;
        	        float Y = ((1.0-data.Y)*2.0f) - 1.0;
			float halfX = data.width;	// 0..2
			float halfY = data.height;	// 0..2
			float ulX = X - halfX;
			float ulY = Y - halfY;
			float lrX = X + halfX;
			float lrY = Y + halfY;
			
			glPushMatrix();
				glTranslatef(X, Y, 0.0f);
				glRotatef(data.angle, 0.0f, 0.0f, 1.0f);
				glTranslatef(-X, -Y, 0.0f);
				glutDrawBox(ulX, ulY, lrX, lrY, (float)color.r/255.0f, (float)color.g/255.0f, (float)color.b/255.0f);
			glPopMatrix();

		}
	}
};


class TestApp : public ITouchListener
{
public:
	TestApp()
	{
		colors[0].r = 255;
		colors[0].g = 255;
		colors[0].b = 255;

		colors[1].r = 255;
		colors[1].g = 255;
		colors[1].b = 255;

		colors[2].r = 255;
		colors[2].g = 0;
		colors[2].b = 255;

		colors[3].r = 255;
		colors[3].g = 0;
		colors[3].b = 255;

		colors[4].r = 128;
		colors[4].g = 255;
		colors[4].b = 255;

		colors[5].r = 128;
		colors[5].g = 128;
		colors[5].b = 255;

		colors[6].r = 128;
		colors[6].g = 128;
		colors[6].b = 0;

		colors[7].r = 128;
		colors[7].g = 64;
		colors[7].b = 0;

        CvSize size;
        size.width = 640;
        size.height = 640;

		m_lastPress = time(0);

		// Create named window in which the captured images will be presented
		cvNamedWindow( "mywindow", CV_WINDOW_AUTOSIZE );
        window_img = cvCreateImage(size, 8, 3);
	}

	~TestApp()
	{
		cvDestroyWindow( "mywindow" );
	    cvReleaseImage( &window_img);
	}

	//! Notify that a finger has just been made active. 
	virtual void fingerDown(TouchData data)
	{
		fingerList[data.ID] = FingerElement(colors[data.ID % 8], data);
		
		printf("Press detected: %f, %f\n", data.X, data.Y);

		if(curcalib == -1)
		{
#ifdef WIN32
			INPUT aInput;

			aInput.type = INPUT_MOUSE;
			aInput.mi.dwFlags = MOUSEEVENTF_LEFTDOWN | MOUSEEVENTF_ABSOLUTE | MOUSEEVENTF_MOVE;
			aInput.mi.dwExtraInfo = 0;
			aInput.mi.mouseData = 0;
			aInput.mi.time = 0;
			aInput.mi.dx = (data.X * 65535.0f);
			aInput.mi.dy = (data.Y * 65535.0f);

			int aResult = SendInput(1, &aInput, sizeof(INPUT) );
#endif
		}
	}

	//! Notify that a finger has moved 
	virtual void fingerUpdate(TouchData data)
	{
		fingerList[data.ID].data = data;

		if(curcalib == -1)
		{
#ifdef WIN32
			INPUT aInput;

			aInput.type = INPUT_MOUSE;
			aInput.mi.dwFlags = MOUSEEVENTF_ABSOLUTE | MOUSEEVENTF_MOVE;
			aInput.mi.dwExtraInfo = 0;
			aInput.mi.mouseData = 0;
			aInput.mi.time = 0;
			aInput.mi.dx = (data.X * 65536.0f);
			aInput.mi.dy = (data.Y * 65535.0f);

			int aResult = SendInput(1, &aInput, sizeof(INPUT) );
#endif
		}
	}

	//! A finger is no longer active..
	virtual void fingerUp(TouchData data)
	{
		if(curcalib != -1){			
			time_t now = time(0);
			if((now-m_lastPress)>0){
				m_lastPress = now;
				screen->nextCalibrationStep();
				curcalib ++;
				if(curcalib >= GRID_POINTS){
					curcalib = -1;					
				}
			}
		}
		std::map<int, FingerElement>::iterator iter;

		for(iter=fingerList.begin(); iter != fingerList.end(); iter++)
		{
			if(iter->second.data.ID == data.ID)
			{
				fingerList.erase(iter);
				return;
			}
		}

		if(curcalib == -1)
		{
#ifdef WIN32
			INPUT aInput;

			aInput.type = INPUT_MOUSE;
			aInput.mi.dwFlags = MOUSEEVENTF_LEFTUP;
			aInput.mi.dwExtraInfo = 0;
			aInput.mi.mouseData = 0;
			aInput.mi.time = 0;
			int aResult = SendInput(1, &aInput, sizeof(INPUT) );
#endif
		}
	}

	void draw()
	{
		rotAng += 0.1;
		if (rotAng > 90.0)
			rotAng = 0;
		
		glutPrepTexture(screen->getFilterImage(viewFilterStage), viewFilterStage);
		glutDrawTexturedBox(previewBox.upperLeftCorner.X*2.0f - 1.0f,(1.0f-previewBox.upperLeftCorner.Y)*2.0f - 1.0f,
							previewBox.lowerRightCorner.X*2.0f - 1.0f,(1.0f-previewBox.lowerRightCorner.Y)*2.0f - 1.0f,
							viewFilterStage);
		glutDrawBox(previewBox.upperLeftCorner.X*2.0f - 1.0f,(1.0f-previewBox.upperLeftCorner.Y)*2.0f - 1.0f,
							previewBox.lowerRightCorner.X*2.0f - 1.0f,(1.0f-previewBox.lowerRightCorner.Y)*2.0f - 1.0f,
							1.0, 0.0, 0.0);
//		glutRenderIplImage(0, 0, screen->getFilterImage(viewFilterStage));
		if(captureBox){
			if(fingerList.size() == 2){
				std::map<int, FingerElement>::iterator iter = fingerList.begin();
				FingerElement f = iter->second;
				iter++;
				FingerElement s = iter->second;
				vector2df fv(f.data.X,f.data.Y);
				vector2df sv(s.data.X,s.data.Y);
				
				if(fv.getLengthSQ() < sv.getLengthSQ())
					bBox = rect2df(fv,sv);
				else
					bBox = rect2df(fv,sv);				
			}
			glutDrawBox(bBox.upperLeftCorner.X*2.0f - 1.0f,(1.0f-bBox.upperLeftCorner.Y)*2.0f - 1.0f,
							bBox.lowerRightCorner.X*2.0f - 1.0f,(1.0f-bBox.lowerRightCorner.Y)*2.0f - 1.0f,
							1.0,1.0,1.0);
			glutDrawText(-0.5,0.05, "Press Arrows to move capture box.");
			glutDrawText(-0.5,0.0, "Press [Ctrl]+Arrows to size capture window.");
			glutDrawText(-0.5,-0.05, "Pressing [Shift] in combination makes adjustments in larger increments.");
		} else if (showHelp && (curcalib == -1)) {
			glutDrawText(-0.5,0.15, "Press '1'-'0' to view the output of each filter in the filter chain.");
			glutDrawText(-0.5,0.10, "Press 'C' to begin calibration.");
			glutDrawText(-0.5,0.05, "Press 'B' to recapture the background filter.");
			glutDrawText(-0.5,0.0, "Press 'X' to adjust the capture bounding box.");
			glutDrawText(-0.5,-0.05, "Press 'H' to toggle the help display.");
			glutDrawText(-0.5,-0.15, "Press Arrows to move preview window.");
			glutDrawText(-0.5,-0.20, "Press Ctrl+Arrows to size preview window.");
			glutDrawText(-0.5,-0.25, "Pressing [Shift] in combination makes adjustments in larger increments.");
		} else if (curcalib >= 0) {
			glutDrawText(-0.5,0.0, "Touch glowing cross. Repeat for each calibration point. Pressing 'R' returns to the last point.");
		}
		
		rect2df bbox = screen->getScreenBBox();

		if(fingerList.size() > 0)
			glutDrawBox(bbox.upperLeftCorner.X*2.0f - 1.0f,(1.0f-bbox.upperLeftCorner.Y)*2.0f - 1.0f,
						bbox.lowerRightCorner.X*2.0f - 1.0f,(1.0f-bbox.lowerRightCorner.Y)*2.0f - 1.0f,
						1.0,1.0,1.0);			
		else
			glutDrawBox(bbox.upperLeftCorner.X*2.0f - 1.0f,(1.0f-bbox.upperLeftCorner.Y)*2.0f - 1.0f,
						bbox.lowerRightCorner.X*2.0f - 1.0f,(1.0f-bbox.lowerRightCorner.Y)*2.0f - 1.0f,
						0.0, 0.2, 0.0);
			

		vector2df *screenpts = screen->getScreenPoints();
		vector2df *campts = screen->getCameraPoints();

		int i;
		for(i=0; i<GRID_POINTS; i++)
		{

			if(curcalib == i)
				glutDrawMarker((screenpts[i].X*2.0f)-1.0f, ((1.0-screenpts[i].Y)*2.0f)-1.0f, 0.05, 1.0, 0.0, 0.0, rotAng);
//			else
				glutDrawPlus((screenpts[i].X*2.0f)-1.0f, ((1.0-screenpts[i].Y)*2.0f)-1.0f, 0.02, 0.0, 1.0, 0.0, 0.0);
		}

/*
//Draw the 'mapping' points (camera space)...
		for(i=0; i<GRID_POINTS; i++)
		{
			if(curcalib == i)
				glutDrawPlus((campts[i].X/300.0f)-1.0f, (campts[i].Y/300.0f)-1.0f, 0.02, 0.2, 0.2, 0.2);
			else
				glutDrawPlus((campts[i].X/300.0f)-1.0f, (campts[i].Y/300.0f)-1.0f, 0.02, 0.1, 0.1, 0.1);
		}
*/

		// only draw fingers when not calibrating..
		if(curcalib == -1)
		{
			std::map<int, FingerElement>::iterator iter;

			for(iter=fingerList.begin(); iter != fingerList.end(); iter++)
			{
				iter->second.draw();
			}
		}
	}

	void clearFingers()
	{
		fingerList.clear();
	}

private:
	std::map<int, FingerElement> fingerList;
    RgbPixel colors[8];
    IplImage *window_img;
	time_t m_lastPress;
};



TestApp app;

void glutKeyboardUpCallback( unsigned char key, int x, int y )
{
    printf( "keyup=%i\n", key );
    keystate[key] = false;
}

void glutSpecialUp(int key, int x, int y)
{
	   printf( "keyup=%i\n", key );
}
void glutSpecialDown(int key, int x, int y)
{
	   printf( "keydn=%i\n", key );
	   bool resize;
	   float incf = 0.005;		   
	   int mod = glutGetModifiers();
	   resize = (mod & GLUT_ACTIVE_CTRL) == GLUT_ACTIVE_CTRL;
	   if(mod & GLUT_ACTIVE_SHIFT)
		   incf = 0.1;
	   vector2df inc;
	   
	   switch(key){
			case GLUT_KEY_UP:				   
				inc = vector2df(0.0,-incf);
			break;
			case GLUT_KEY_DOWN:				   
				inc = vector2df(0.0,incf);
			break;
			case GLUT_KEY_LEFT:				   
				inc = vector2df(-incf,0.0);
			break;
			case GLUT_KEY_RIGHT:				   
				inc = vector2df(incf,0.0);
			break;
			default:
				return;
	   }		   
	   if(captureBox) {
		   bBox.upperLeftCorner += inc;
		   if(!resize)
			   bBox.lowerRightCorner += inc;
			   
			printf("bBox: [%f,%f]x[%f,%f]\n", bBox.upperLeftCorner.X, bBox.upperLeftCorner.Y, bBox.lowerRightCorner.X, bBox.lowerRightCorner.Y);			
	   } else {
		   previewBox.upperLeftCorner += inc;
		   if(!resize)
			   previewBox.lowerRightCorner += inc;
			printf("previewBox: [%f,%f]x[%f,%f]\n", previewBox.upperLeftCorner.X, previewBox.upperLeftCorner.Y, previewBox.lowerRightCorner.X, previewBox.lowerRightCorner.Y);			
	   }   
}

void glutKeyboardCallback( unsigned char key, int x, int y )
{
    printf( "keydn=%i\n", key );
    keystate[key] = true;

	if(key == 120)          // x
	{
		printf("bounding box\n");
		if(!captureBox){
			rect2df bb(vector2df(0.0f,0.0f),vector2df(1.0f,1.0f));
			screen->setScreenBBox(bb);
			bBox = rect2df(vector2df(0.0f,0.0f),vector2df(1.0f,1.0f));
			captureBox = true;
		}else{
			captureBox = false;
			screen->setScreenBBox(bBox);			
		}		
	}
	if(key == 99)			// c
	{
		printf("Calibrate\n");
		screen->beginCalibration();
		curcalib = 0;
	} else if(key == 27)			// esc
	{
		glutLeaveGameMode();
		screen->saveConfig("config.xml");
		TouchScreenDevice::destroy();
		exit(1);
	}
    else if( key == 98)				// b = recapture background
	{
		screen->setParameter(backgroundLabel, "capture", "");
		app.clearFingers();
	} else if( key == 32)				// space = next calibration step
	{
		screen->nextCalibrationStep();
		curcalib ++;
		if(curcalib >= GRID_POINTS)
			curcalib = -1;
	}
	if (key == 114 )		// r = revert calib
	{
		screen->revertCalibrationStep();
		curcalib --;
		if (curcalib<0){
			curcalib = 0;
		}
	}
	if (key >= 49 && key <= 57)
	{
		viewFilterStage = key - 49;
		printf("Setting viewFilterStage = %d\n", viewFilterStage);
	}
	
}

void glutDrawText(GLfloat x, GLfloat y, char *text)
{
    char *p;
    
    glRasterPos2f(x, y);
    for (p = text; *p; p++)
    	glutBitmapCharacter(GLUT_BITMAP_HELVETICA_10, *p);
}

void glutDrawBox(float x1, float y1, float x2, float y2, float r, float g, float b)
{
	glLineWidth(2.0);
	
	printGLError("glutDrawBox (Pre-glBegin)");
	glBegin(GL_LINE_STRIP);
	glColor3f(r, g, b);

	glVertex2f(x1,y1);
	glColor3f(r, g, b);
	glVertex2f(x2,y1);
	glColor3f(r, g, b);
	glVertex2f(x2,y2);
	glColor3f(r, g, b);
	glVertex2f(x1,y2);
	glColor3f(r, g, b);
	glVertex2f(x1,y1);

	glEnd();
	printGLError("glutDrawBox (Post-glEnd)");
}

void glutDrawTexturedBox(float x1, float y1, float x2, float y2, int txtId)
{
	GLuint id = glTxtTble[txtId];
	if (id == 0)
		return;
		
	//glLineWidth(2.0);
	glEnable(GL_TEXTURE_2D);
	glBindTexture(GL_TEXTURE_2D, id);
	
	printGLError("glutDrawTexturedBox (Pre-glBegin)");
	glBegin(GL_QUADS);
	
	glTexCoord2f(1.0, 0.0);
	glVertex2f(x1,y1);
	
	glTexCoord2f(0.0, 0.0);
	glVertex2f(x2,y1);

	glTexCoord2f(0.0, 1.0);
	glVertex2f(x2,y2);
	
	glTexCoord2f(1.0, 1.0);
	glVertex2f(x1,y2);

	glEnd();
	printGLError("glutDrawTexturedBox (Post-glEnd)");
	glDisable(GL_TEXTURE_2D);
}

void glutDrawPlus(float x1, float y1, float s, float r, float g, float b, float ang)
{
	glLineWidth(2.0);
	printGLError("glutDrawPlus (Pre-glBegin)");
	
	glPushMatrix();
	glLoadIdentity();
	glTranslatef(x1, y1, 0.0);
	glScalef(s, s, s);
	glRotatef(ang, 0.0, 0.0, 1.0);
	
	glBegin(GL_LINES);

	float sx = s;
	float sy = s;

	glColor3f(r, g, b);
	glVertex2f(0.0, -1.0); //glVertex2f(x1,y1-sy);
	glColor3f(r, g, b);
	glVertex2f(0.0, 1.0); //glVertex2f(x1,y1+sy);

	glColor3f(r, g, b);
	glVertex2f(-1.0, 0.0); //glVertex2f(x1-sx,y1);
	glColor3f(r, g, b);
	glVertex2f(1.0, 0.0); // glVertex2f(x1+sx,y1);

	glEnd();
	glPopMatrix();
	
	printGLError("glutDrawPlus (Post-glEnd)");
}

void glutDrawMarker(float x1, float y1, float s, float r, float g, float b, float ang)
{
	glLineWidth(2.0);
	printGLError("glutDrawPlus (Pre-glBegin)");
	
	glPushMatrix();
	glLoadIdentity();
	glTranslatef(x1, y1, 0.0);
	glScalef(s, s, s);
	glRotatef(ang, 0.0, 0.0, 1.0);
	
	glBegin(GL_TRIANGLES);

	float sx = s;
	float sy = s;

	// upper-left
	glColor3f(r, g, b);
	glVertex2f(-0.5, 0.5);
	glColor3f(r, g, b);
	glVertex2f(-1.0, 0.5);
	glColor3f(r, g, b);
	glVertex2f(-0.5, 1.0);

	// upper-right
	glColor3f(r, g, b);
	glVertex2f(0.5, 0.5);
	glColor3f(r, g, b);
	glVertex2f(1.0, 0.5);
	glColor3f(r, g, b);
	glVertex2f(0.5, 1.0);

	// lower-right
	glColor3f(r, g, b);
	glVertex2f(0.5, -0.5);
	glColor3f(r, g, b);
	glVertex2f(1.0, -0.5);
	glColor3f(r, g, b);
	glVertex2f(0.5, -1.0);

	// lower-left
	glColor3f(r, g, b);
	glVertex2f(-0.5, -0.5);
	glColor3f(r, g, b);
	glVertex2f(-0.5, -1.0);
	glColor3f(r, g, b);
	glVertex2f(-1.0, -0.5);

	glEnd();
	glPopMatrix();
	
	printGLError("glutDrawPlus (Post-glEnd)");
}

void glutPrepTexture(IplImage *orig, int i) {
	GLint  internalFormat;
	GLenum format, type, formats[5] = { 0, GL_RED, 0, GL_RGB, GL_RGBA };
	GLuint id;
	IplImage *image = 0;

	if (orig == 0)
		return;
		
    image = cvCreateImage(cvSize(256,256), orig->depth, orig->nChannels);
    image->origin = orig->origin;  // same vertical flip as source
	cvResize(orig, image, CV_INTER_LINEAR);
		
	id = glTxtTble[i];	
	if (id == 0) {
		glGenTextures(1, &id);
		glTxtTble[i] = id;
	}
	
	glBindTexture(GL_TEXTURE_2D, id);
	printGLError("glutPrepTexture (Post-glBindTexture)");
   
	glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP);
	glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP);
	glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
	glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
	glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_REPLACE);
	
	type = ( image->depth == IPL_DEPTH_8U ? GL_UNSIGNED_BYTE : GL_BYTE );
	internalFormat = image->nChannels;
	format = formats[image->nChannels];

	
	glTexImage2D(GL_TEXTURE_2D, 0, internalFormat, 256, 256, 0, format, type, image->imageData);
	printGLError("glutPrepTexture (Post-glTexImage2D)");

	cvReleaseImage(&image);
}

void glutRenderIplImage(int x, int y, IplImage *image) {
	GLint  internalFormat;
	GLenum format, type, formats[5] = { 0, GL_RED, 0, GL_RGB, GL_RGBA };
	GLuint id;

	if (image == 0)
		return;
	
	type = ( image->depth == IPL_DEPTH_8U ? GL_UNSIGNED_BYTE : GL_BYTE );
	internalFormat = image->nChannels;
	format = formats[image->nChannels];
	
	if (image->origin == IPL_ORIGIN_BL) {
		image = cvCreateImage(cvSize(image->width,image->height), image->depth, image->nChannels);
	    image->origin = IPL_ORIGIN_BL;
		cvFlip(image, 0, 1);
	}

	glRasterPos2i(x, y);
	glDrawPixels(image->width, image->height, format, type, image->imageData);  
	printGLError("glutRenderIplImage");
}

void glutDisplayCallback( void )
{
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
	
	glutDrawBox(-1,1,1,-1, 1.0, 1.0, 1.0);
	printGLError("glutDisplayCallback (Post-glutDrawBox)");
	
	screen->getEvents();

	printGLError("glutDisplayCallback (Pre-draw)");
	
	app.draw();
	
	printGLError("glutDisplayCallback (Post-draw)");

	glFlush();
	glutSwapBuffers();

	glutPostRedisplay();
	
	printGLError("glutDisplayCallback (Final)");
}

void startGLApp(int argc, char *argv[])
{
	bool useGameMode = false;
	if (argc > 1) {
		if (strcmp(argv[1], "-g") == 0) {
			argc--;
			argv++;
			useGameMode = true;
		}
	}

	screen->beginTracking();

	glutInit( &argc, argv );

	// set RGBA mode with double and depth buffers
	glutInitDisplayMode( GLUT_RGBA | GLUT_DEPTH | GLUT_DOUBLE );
	
	if (!useGameMode) {
		glutCreateWindow("root");
		glutFullScreen();
	}
	
	//glEnable(GL_CULL_FACE);
	//glEnable(GL_DEPTH_TEST);
	//glDepthMask(GL_TRUE);
	
	printGLError("startGLApp");
	
	if (useGameMode) {
		// start fullscreen game mode using
		// 640x480, 16bit pixel depth, 60Hz refresh rate
		char *width = "640";
		char *height = "480";
		char *depth = "16";
		char *freq = "60";
		if (argc > 1) {
			width = argv[1];
			if (argc > 2) {
				height = argv[2];
				if (argc > 3) {
					depth = argv[3];
					if (argc > 4) {
						freq = argv[4];
					}
				}
			}
		}

		char s[256];
		// not everyone has snprintf installed
//		snprintf(s, sizeof(s), "%sx%s:%s@%s", width, height, depth, freq);
		sprintf(s, "%sx%s:%s@%s", width, height, depth, freq);
		glutGameModeString(s);
		glutEnterGameMode();
	}	

	// setup callbacks
	glutKeyboardFunc( glutKeyboardCallback );
	glutSpecialFunc( glutSpecialDown);
	glutKeyboardUpFunc( glutKeyboardUpCallback );
	glutSpecialUpFunc(glutSpecialUp);
	glutDisplayFunc( glutDisplayCallback );

	configStep = 1;

	screen->setParameter(backgroundLabel, "capture", "");

	// enter main loop
	glutMainLoop();
}

void printGLError(char *hdr) {
	GLenum err = glGetError();
	if (err != GL_NO_ERROR) {
		printf("%s: %s\n", hdr, gluErrorString(err));
		exit(0);
	}
}

#ifdef WIN32
int _tmain(int argc, char * argv[])
#else
int main(int argc, char * argv[])
#endif
{
	screen = TouchScreenDevice::getTouchScreen();

	if(!screen->loadConfig("config.xml"))
	{
		std::string label;
#ifdef WIN32
		label = screen->pushFilter("dsvlcapture");
#else
		label = screen->pushFilter("cvcapture");
#endif
		screen->setParameter(label, "source", "cam");
		//screen->setParameter(label, "source", "../tests/simple-2point.avi");
		//screen->setParameter(label, "source", "../tests/hard-5point.avi");

		screen->pushFilter("mono");
		screen->pushFilter("smooth");
		label = screen->pushFilter("backgroundremove");
		screen->setParameter(label, "threshold", "0");

		//label = screen->pushFilter("brightnesscontrast");
		//screen->setParameter(label, "brightness", "0.1");
		//screen->setParameter(label, "contrast", "0.4");

		label = screen->pushFilter("rectify");
		screen->setParameter(label, "level", "25");

		screen->saveConfig("config.xml");
	}

	std::string recLabel = screen->findFirstFilter("rectify");
	backgroundLabel = screen->findFirstFilter("backgroundremove");
	screen->registerListener((ITouchListener *)&app);
	// Note: Begin processing should only be called after the screen is set up

	screen->beginProcessing();
	// kill any mask that might be present
	screen->setParameter(backgroundLabel, "mask", NULL);
	
	do
	{

		int keypressed = cvWaitKey(32) & 255;

		if(keypressed != 255 && keypressed > 0)
			printf("KP: %d\n", keypressed);
        if( keypressed == 27) break;		// ESC = quit
        if( keypressed == 98)				// b = recapture background
		{
			screen->setParameter(backgroundLabel, "capture", "");
			app.clearFingers();
		}
        if( keypressed == 114)				// r = auto rectify..
		{
			screen->setParameter(recLabel, "level", "auto");
		}		
        if( keypressed == 13 || keypressed == 10)				// enter = calibrate position
		{
			startGLApp(argc, argv);
		}

	} while( ok );

	screen->saveConfig("config.xml");
	TouchScreenDevice::destroy();
	return 0;
}
