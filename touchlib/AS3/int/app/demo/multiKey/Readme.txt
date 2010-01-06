MultiKey
by Seth Sandler (cerupcat)




What each file does:

DrawNaturalKey.as - draws an individual natural (white) key and changes it's color (red) when pressed.

DrawSharpKey.as - draws an individual sharp (black) key and changes it's color (red) when pressed.

AddKey.as - takes the drawn key and adds the ability to move an individual around with pyshics.

AssemblePiano.as - takes the key from addkey, and assembles the full piano together.

AddPiano.as - takes the Assembled Piano and adds the physics to move it around. It also creates the toggle
           border (move, rotate, scale, sound).

RotatableScalable.as - rotates, scales, and moves the target (pianos).

PianoSurface.as - not implemented right now. 

MultiKey.as - Adds the keys to the stage in flash. Edit this file to add more pianos.






Updates 9-23-07: 

-Created toggle switch for move, scale, rotate, and sound.
-Added noSound variable which makes it possible mute only the moving piano (instead of all pianos).

