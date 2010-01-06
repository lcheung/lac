///////////////////////////////////////////////////////////////////////////////////////
//																					 //
// LockMedia takes a child (thisChild), and removes it from its parent (oldParent),  //
// and adds it to a new Parent (newParent) while keeping it's scale, rotation, and	 //
// x/y position.																	 //
//																					 //
// When locked is "true", the above occurs. When locked is set to "false", the child //
// goes back to it's original parent while still maintaining it's scale, rotation,   //
// and x/y position.																 //
//																					 //
// The main (original) use for this is to lock children within a moving canvas		 //
// to their current locations. This way when someone moves a canvas that has an      //
// photo, application, or other media inside, the locked media won't be affected by	 //
// someone changing movement/scale/rotation of the canvas. When done using the media //
// you can just unlock it (set it to "false") and it's part of the canvas again.	 //
//																					 //
//	-Seth Sandler (cerupcat)														 // 
//																					 //
// Locked:	  LockMedia.lockMediaFromCanvas(root, root.oldCanvas, this, true);		 //
// Unlocked:  LockMedia.lockMediaFromCanvas(root, root.oldCanvas, this, false);		 //
//																					 //
///////////////////////////////////////////////////////////////////////////////////////

package app.core.action{

	import flash.display.Sprite;
	import flash.display.*;
	import flash.geom.Point;
	import app.core.utl.CoordinateTools;


	public class LockMedia {

		public static function lockMediaFromCanvas(newParent:DisplayObject, oldParent:DisplayObject, thisChild:DisplayObject, locked:Boolean = false) {

			if (locked == true) {

				//Set Adjust position
				var newPos = CoordinateTools.localToLocal(thisChild, newParent);
				
				//Adjust scale
				thisChild.scaleX = oldParent.scaleX * thisChild.scaleX;
				thisChild.scaleY = oldParent.scaleY * thisChild.scaleY;
				
				//Add to new parent (pop off of current parent/canvas);
				newParent.addChild(thisChild);
				
				//Adjust rotation
				thisChild.rotation += oldParent.rotation;
				
				//Adjust position
				thisChild.x = newPos.x;
				thisChild.y = newPos.y;
			}
			
			if (locked == false) {
				
				//Adjust scale
				thisChild.scaleX = thisChild.scaleX/oldParent.scaleX;
				thisChild.scaleY = thisChild.scaleY/oldParent.scaleX;
				
				//Set Adjust position
				var newPos = CoordinateTools.localToLocal(thisChild, oldParent);
				thisChild.x = (newPos.x);
				thisChild.y = (newPos.y);
				
				//Adjust rotation
				thisChild.rotation -= oldParent.rotation;
				
				//Add back to old parent (pop back onto old parent/canvas);
				oldParent.addChild(thisChild);
			}
		}
	}
}