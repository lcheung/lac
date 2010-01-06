#include <textures.h>
#include <stdio.h>

//#pragma comment(lib, "odbccp32.lib")

#pragma comment(lib, "Advapi32.lib")
#pragma comment(lib, "User32.lib")
#pragma comment(lib, "gdi32.lib")
#pragma comment(lib, "glaux.lib")

COGLTexture::COGLTexture()
{
	ID = 1;
	Width=0;
	Height=0;
	bInitialized = false;
}
COGLTexture::~COGLTexture()
{


	// FIXME: do we need to free OGL memory?
}
void COGLTexture::LoadFromFile(char *filename)
{
	// FIXME: if(bInitialized) free memory.
	printf("loading texture: %s\n", filename);
	glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
	glGenTextures(1,(GLuint*)&ID); 
	glBindTexture( GL_TEXTURE_2D, ID);
	Image = auxDIBImageLoadA( (const char*) filename );
	if(!Image) 
	{
		printf("failed\n");
		return;
	}
	Width = Image->sizeX;
	Height = Image->sizeY;
	gluBuild2DMipmaps(	GL_TEXTURE_2D, 
						3, 
						Image->sizeX,
						Image->sizeY,
						GL_RGB,
						GL_UNSIGNED_BYTE,
						Image->data);

	delete Image;

	bInitialized = true;
}

void COGLTexture::SetActive()
{
	if(!bInitialized)
		return;

	glBindTexture( GL_TEXTURE_2D, ID);
}

unsigned int COGLTexture::GetID()
{
	return ID;
}

