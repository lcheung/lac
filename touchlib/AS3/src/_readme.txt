Hello,

Here is a overview of the Touchlib AS3 project:

------------------------------------------------
//Applications (original author)
------------------------------------------------

Core
---------------
AppLoader
Base - Base testing for table operations. (debug)

Effects
---------------
Ripples
Paint (David Wallin)
Trace

Multimemdia
---------------
Photo (David Wallin)
Viewer (Christian Moore)
MultiKey (Seth Sandler)
MusicalSquares (Seth Sandler)
Turntables (Christian Moore)

Games
--------------
Puzzle (Laurence Muller)
Tangram (Adithya Ananth & Divesh Jaiswal)
Tank (David Wallin)

------------------------------------------------
//Additional Application Notes
------------------------------------------------

Puzzle
------
The source code is based on the example from the adobe website: http://www.adobe.com/devnet/flash/samples/puzzle_game/
To add more images to the Puzzle application, the sourcecode has to be modified manualy. Images need to be resized to 800x600 pixels.
The included images (4) in the directory: (touchlibroot)\AS3\src\deploy\www\img\puzzle\ may only be used for non-commercial purposes.

------------------------------------------------
//Structure
------------------------------------------------

src - Flash CS3 source and deployment assets
int - internal libraries
ext - external libraries (papervision, tweener, etc..)

com.touchlib - TUIO socket (renders touch input)

app.core.action - Actions for objects (Rotate/Scale, scroll, doubletap, LockMedia)
app.core.canvas - Container and lens objects (MediaCanvas, nCanvas, Zoom)
app.core.element - Interactive objects that typically act as controllers (Knob, Slider, Toggle)
app.core.loader - External content loaders
app.core.object - Objects that can be rendered on a canvas element (ImageObject, VideoOject)
app.core.utl - Misc utils

app.demo - Demo applications assets
 

------------------------------------------------
//Development
------------------------------------------------
Here is some general guidelines to follow when building demo applications.

Think of the app.demo folder as you would Windows Program files, all application classes and assets 
go into a folder. A typical folder:

app/demo/appName - Folder
app/demo/appName/assets - externals (images, fonts)
app/demo/appName/appNameClass.as - Document Class
app/demo/appName/readme.txt - About the app (license, version)


When committing new applications please keep graphics to minimum, exclude things like background 
and text objects unless necessary for programs operation. If possible put on solid black background.
Also try to clean up any unused library elements. 

Use flash components as much as possible eg: Button

------------------------------------------------
//FLA Setup
------------------------------------------------
Document Class: app.core.appName
Source Paths: ../lib and ../ext
Publish Resolution: 1024x786
Background: Solid Black
Publish path: deploy/appName.swf

------------------------------------------------
//Deployment
------------------------------------------------
www - dynamic web objects 
local - dynamic local objects
appName.swf

------------------------------------------------
//Developers:
------------------------------------------------
David Wallin (WhiteNoiz) - http://www.whitenoiseaudio.com
Christian Moore (nuiman) - nuiman.com
Tim Roth - timroth.de
Laurence Muller (Falcon4ever) - http://www.multigesture.net
Seth Sandler (cerupcat) - http://ssandler.wordpress.com/
Adithya Ananth & Divesh Jaiswal (adi/deej) - http://therealdesktop.blogspot.com/
Jens Franke - http://blog.jensfranke.com/

------------------------------------------------
//License:
------------------------------------------------
Core - GPL
Demo Applications - License determined by author(s).


-------------------------------------------------------------
//Notes
-------------------------------------------------------------
c.moore: developers let me know if have any ideas, please put here with your contact.

Home: http://touchlib.com
SVN : http://touchlib.googlecode.com




