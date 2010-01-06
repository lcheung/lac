// This code is from http://www.codecolony.de/opengl.htm#TexturesBFC
// by Phillip Crocoll

// should be freely usable, but we should contact him and let him know.

#ifdef WIN32
#include <GL/glaux.h>
#else
#include <GL/gl.h>
#endif
class COGLTexture
{
public:
	COGLTexture();
	~COGLTexture();
#ifdef WIN32
	_AUX_RGBImageRec *Image;
#endif
	unsigned int GetID();
	void LoadFromFile(char *filename);
	void SetActive();
	int GetWidth();
	int GetHeight();
private:
	int Width, Height;
	unsigned int ID;
	bool bInitialized;
};

