/*
This class will take objects within a PhotoCanvas element and sort them according to pre-defined settings.

Example: http://youtube.com/watch?v=zu7fNQYmzUs & http://oskope.com/

search: flickr, amazon, ebay, youtube, yahoo

scale with slider
liquid resolution grid resizing?

stack (spred vert/horz)
pile
grid
list
graph

drag and drop to save to local folder
image information toggle
*/

package app.core.canvas{
import flash.events.*;
import app.core.canvas.LiquidCanvas;
import app.core.loader.*;
import app.core.element.*;
import app.core.object.*;
import flash.display.*;
import flash.system.Capabilities;
import flash.events.*;
import app.core.object.n3D.*;

import caurina.transitions.Tweener;
import flash.display.DisplayObject;
import flash.geom.Rectangle;
import app.core.utl.ColorUtil;

public class Arrange extends Sprite
{	
	
	private var testObject:TestLoader;
	public var photos:LiquidCanvas;
		
	public function Arrange()
	{	
		
		photos = new LiquidCanvas();
		photos.name="photos";
		this.addChildAt(photos, 0);		
	   
	    
		var spr0:Sprite = new Sprite();	
		spr0.graphics.beginFill(0xFF00FF,0.75);		
		spr0.graphics.drawRect(-0,-0,100,100);	
		var WrapperObject2:Wrapper = new Wrapper(spr0);	
		WrapperObject2.addEventListener(MouseEvent.CLICK, stackPhotos);		
		WrapperObject2.x = (-photos.width/2)-200; 
		WrapperObject2.y = (-photos.height/2)+0;
		photos.addChild(WrapperObject2);
		
		var spr00:Sprite = new Sprite();	
		spr00.graphics.beginFill(0xFF0000,0.75);		
		spr00.graphics.drawRect(-0,-0,100,100);	
		var spr00Wrapper:Wrapper = new Wrapper(spr00);	
		spr00Wrapper.addEventListener(MouseEvent.CLICK, fanPhotos);		
		spr00Wrapper.x = (-photos.width/2)-100; 
		spr00Wrapper.y = (-photos.height/2)+100;
		photos.addChildAt(spr00Wrapper,this.numChildren-1);	
		
		var spr1:Sprite = new Sprite();
		spr1.graphics.beginFill(0xD7D6D6,1.0);
		spr1.graphics.drawRect(-0,-0,100,100);
		var WrapperObject3:Wrapper = new Wrapper(spr1);	
		WrapperObject3.addEventListener(MouseEvent.CLICK, gridPhotos);		
		WrapperObject3.x = (-photos.width/2)-100; 
		WrapperObject3.y = (-photos.height/2)+200;
		photos.addChildAt(WrapperObject3,3);			
			
		var spr2:Sprite = new Sprite();
		spr2.graphics.beginFill(0xC0C0C0,1.0);
		spr2.graphics.drawRect(-0,-0,100,100);
		var WrapperObject4:Wrapper = new Wrapper(spr2);	
		WrapperObject4.addEventListener(MouseEvent.CLICK, messPhotos);		
		WrapperObject4.x = (-photos.width/2)-100; 
		WrapperObject4.y = (-photos.height/2)+300;
		photos.addChildAt(WrapperObject4,this.numChildren-1);
	
		var spr01:Sprite = new Sprite();
		spr01.graphics.beginFill(0x00FF00,1.0);
		spr01.graphics.drawRect(-0,-0,100,100);
		var WrapperObject5:Wrapper = new Wrapper(spr01);	
		WrapperObject5.addEventListener(MouseEvent.CLICK, sprialPhotos);		
		WrapperObject5.x = (-photos.width/2)-100; 
		WrapperObject5.y = (-photos.height/2)+400;
		photos.addChildAt(WrapperObject5,this.numChildren-1);	
		
		var spr02:Sprite = new Sprite();
		spr02.graphics.beginFill(0x0F0F0F,1.0);
		spr02.graphics.drawRect(-0,-0,100,100);
		var WrapperObject6:Wrapper = new Wrapper(spr02);	
		WrapperObject6.addEventListener(MouseEvent.CLICK, fanPhotos2);		
		WrapperObject6.x = (-photos.width/2)-100; 
		WrapperObject6.y = (-photos.height/2)+500;
		photos.addChildAt(WrapperObject6,this.numChildren-1);	
		
		var spr03:Sprite = new Sprite();
		spr03.graphics.beginFill(0x0F0333,1.0);
		spr03.graphics.drawRect(-0,-0,100,100);
		var WrapperObject6:Wrapper = new Wrapper(spr03);	
		WrapperObject6.addEventListener(MouseEvent.CLICK, fanPhotos3);		
		WrapperObject6.x = (-photos.width/2)-100; 
		WrapperObject6.y = (-photos.height/2)+600;
		photos.addChildAt(WrapperObject6,this.numChildren-1);		
		
		var spr04:Sprite = new Sprite();
		spr04.graphics.beginFill(0xFF33FF,1.0);
		spr04.graphics.drawRect(-0,-0,100,100);
		var WrapperObject7:Wrapper = new Wrapper(spr04);	
		WrapperObject7.addEventListener(MouseEvent.CLICK, fanPhotos4);		
		WrapperObject7.x = (-photos.width/2)-100; 
		WrapperObject7.y = (-photos.height/2)+700;
		photos.addChildAt(WrapperObject7,this.numChildren-1);		
		
		var spr05:Sprite = new Sprite();
		spr05.graphics.beginFill(0x00FF00,1.0);
		spr05.graphics.drawRect(-0,-0,100,100);
		var WrapperObject8:Wrapper = new Wrapper(spr05);	
		WrapperObject8.addEventListener(MouseEvent.CLICK, fanPhotos6);		
		WrapperObject8.x = (-photos.width/2)-100; 
		WrapperObject8.y = (-photos.height/2)+800;
		photos.addChildAt(WrapperObject8,this.numChildren-1);	
		
		var spr06:Sprite = new Sprite();
		spr06.graphics.beginFill(0xFFFF00,1.0);
		spr06.graphics.drawRect(-0,-0,100,100);
		var WrapperObject9:Wrapper = new Wrapper(spr06);	
		WrapperObject9.addEventListener(MouseEvent.CLICK, fanPhotos6);		
		WrapperObject9.x = (-photos.width/2)-100; 
		WrapperObject9.y = (-photos.height/2)+950;
		//photos.addChildAt(WrapperObject9,this.numChildren-1);	
	}
	
	//private var photoW:int = photos.width;
	private var minX:int = -0, maxX:int = 1024;
	private var minY:int = -0, maxY:int = 786;
	
	
	private function sprialPhotos(e:Event):void
	{
		var n:int = photos.numChildren;
		for(var i:int = 0; i<n; i++)
		{
		var child:DisplayObject = photos.getChildAt(i);
		if(child is Shape) continue; // void its 'clickgrabber'
		if(child is Wrapper) continue;
			minX = -0, maxX = 1024;
			minY = -0, maxY = 786;

			var targetX:int = 0;
			var targetY:int = 0;
			var targetRotation:int = 2*i;	
			var targetScale:Number = 1.0;	    
    		Tweener.addTween(child, {scaleX: targetScale, scaleY: targetScale, rotation:targetRotation, x:targetX, y:targetY, time:0.35, transition:"easeinoutquad"});	
		}
	}	
	

	
	private function stackPhotos(e:Event):void
	{	
		var n:int = photos.numChildren;
		for(var i:int = 0; i<n; i++)
		{
		var child:DisplayObject = photos.getChildAt(i);
		if(child is Shape) continue; // void its 'clickgrabber'
		if(child is Wrapper) continue;
			minX = -0, maxX = 1024;
			minY = -0, maxY = 786;
			//var targetX:int = minX+240;
			//var targetY:int = minY+500;	
			var targetX:int = 0;
			var targetY:int = 0;
			var targetScale = 2.0;
			var targetRotation:int = 0;	
			
			/*
			if(photos.rotation <= 90 && photos.rotation > 0){targetRotation = -90}
			if(photos.rotation <= 180 && photos.rotation > 90){targetRotation = -180}
			if(photos.rotation <= -90 && photos.rotation < 0){targetRotation = 90}
			if(photos.rotation <= -180 && photos.rotation < -90){targetRotation = 180}
			trace('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ '+photos.rotation+' = '+targetRotation);
			*/
			
			//var targetScale:Number = photos.scaleX * photos.scaleY + 5.0;	
			//var targetScale:Number = 1.0;	
			//trace(targetScale);		
    
    		Tweener.addTween(child, {scaleX: targetScale, scaleY: targetScale, rotation:targetRotation, x:targetX, y:targetY, time:0.35, transition:"easeinoutquad"});	
		}
	}
	
	private function fanPhotos(e:Event):void
	{	
		var n:int = photos.numChildren;
		for(var i:int = 0; i<n; i++)
		{
		var child:DisplayObject = photos.getChildAt(i);
		if(child is Shape) continue; // void its 'clickgrabber'
		if(child is Wrapper) continue;
			minX = -0, maxX = 1024;
			minY = -0, maxY = 786;
			//var targetX:int = minX+240;
			//var targetY:int = minY+500;	
			var targetX:int = 30*i;
			var targetY:int = 0;
			var targetRotation:int = 0;	
			var targetScale:Number = 1.0;	
    
    		Tweener.addTween(child, {scaleX: targetScale, scaleY: targetScale, rotation:targetRotation, x:targetX-500, y:targetY, time:0.35, transition:"easeinoutquad"});	
		}
	}	
	private function fanPhotos2(e:Event):void
	{	
		var n:int = photos.numChildren;
		for(var i:int = 0; i<n; i++)
		{
		var child:DisplayObject = photos.getChildAt(i);
		if(child is Shape) continue; // void its 'clickgrabber'
		if(child is Wrapper) continue;
			minX = -0, maxX = 1024;
			minY = -0, maxY = 786;
			//var targetX:int = minX+240;
			//var targetY:int = minY+500;	
			var targetX:int = 33*i;
			var targetY:int = 5*i;
			var targetRotation:int = i*10;	
			var targetScale:Number = 1.0;	
    
    		Tweener.addTween(child, {scaleX: targetScale, scaleY: targetScale, rotation:targetRotation, x:targetX-400, y:targetY, time:0.65, transition:"easeinoutquad"});	
		}
	}	
	private function fanPhotos3(e:Event):void
	{	
		var n:int = photos.numChildren;
		for(var i:int = 0; i<n; i++)
		{
		var child:DisplayObject = photos.getChildAt(i);
		if(child is Shape) continue; // void its 'clickgrabber'
		if(child is Wrapper) continue;
			minX = -0, maxX = 1024;
			minY = -0, maxY = 786;
			//var targetX:int = minX+240;
			//var targetY:int = minY+500;	
			var targetX:int = 50*i;
			var targetY:int = 5*i;
			var targetRotation:int = Math.random()*i+45;	
			var targetScale:Number = 1.5;	
    
    		Tweener.addTween(child, {scaleX: targetScale, scaleY: targetScale, rotation:targetRotation, x:targetX-600, y:targetY, time:0.65, transition:"easeinoutquad"});	
		}
	}	
	private function fanPhotos4(e:Event):void
	{	
		var n:int = photos.numChildren;
		for(var i:int = 0; i<n; i++)
		{
		var child:DisplayObject = photos.getChildAt(i);
		if(child is Shape) continue; // void its 'clickgrabber'
		if(child is Wrapper) continue;
			var targetX:int = -25+40*i;
			var targetY:int = 0;
			var targetRotation:int = 0;	
			var targetScale:Number = 0.07*i;	    
    		Tweener.addTween(child, {scaleX: targetScale, scaleY: targetScale, rotation:targetRotation, x:targetX-500, y:targetY, time:0.65, transition:"easeinoutquad"});	
		}
	}	
	private function fanPhotos5(e:Event):void
	{	
		var n:int = photos.numChildren;
		var r = 200; 
		var p = 2*Math.PI/8;
		
		for(var i:int = 0; i<n; i++)
		{
		var child:DisplayObject = photos.getChildAt(i);
		if(child is Shape) continue; // void its 'clickgrabber'
		if(child is Wrapper) continue;
				
			var x1 = 1024+r*Math.cos(i*p);
			var y1 = 768+r*Math.sin(i*p);
				
			var d = 2*Math.PI*r/8;
			var targetX:int = x1-600;
			var targetY:int = y1-800;
			var targetRotation:int = 0;	
			var targetScale:Number = 0.5;	    
    		Tweener.addTween(child, {scaleX: targetScale, scaleY: targetScale, rotation:targetRotation, x:targetX-450, y:targetY, time:0.65, transition:"easeinoutquad"});	
		}
	}	
	private function fanPhotos6(e:Event):void
	{	
		var n:int = photos.numChildren;
		var r = 325; 
		var p = 2*Math.PI/8;
		
		for(var i:int = 0; i<n; i++)
		{
		var child:DisplayObject = photos.getChildAt(i);
		if(child is Shape) continue; // void its 'clickgrabber'
		if(child is Wrapper) continue;
				
			var x1 = 1024+r*Math.cos(i*p);
			var y1 = 768+r*Math.sin(i*p);
				
			var d = 2*Math.PI*r/8;
			var targetX:int = x1-1000;
			var targetY:int = y1-750;
			var targetRotation:int = Math.random()*360;
			var targetScale:Number = 0.40;	    
    		Tweener.addTween(child, {scaleX: targetScale, scaleY: targetScale, rotation:targetRotation, x:targetX, y:targetY, time:0.65, transition:"easeinoutquad"});	
		}
	}
	private function gridPhotos(e:Event):void
	{
	
		//Tweener.addTween(spr2, {scaleX: targetScale, scaleY: 5.0, rotation:180, time:1.0, transition:"easeinoutquad"});
		
		const gap:int = 25; // horizental and vertical gap
		
		var rowWidth:int = gap; // current row width
		var rowBaseline:int = gap; // baseline of current row
		var rowHeight:int = gap; // height of the tallest child in current row
		
		var n:int = photos.numChildren;
		for(var i:int = 0; i<n; i++)
		{	
			minX = -500, maxX = 2700;
			minY = -450, maxY = 2000;
			
			var child:DisplayObject = photos.getChildAt(i);
			if(child is Shape) continue; // void its 'clickgrabber'
			if(child is Wrapper) continue;
			var bounds:Rectangle = child.getBounds(photos);
			var selfBounds:Rectangle = child.getBounds(child);
			var xOff:Number = selfBounds.x * child.scaleX;
			var yOff:Number = selfBounds.y * child.scaleY;
			//trace(bounds);
			
			if(bounds.height > rowHeight) rowHeight = bounds.height;
			
			var targetX:int = rowWidth-xOff+minX;
			var targetY:int = rowBaseline-yOff+minY;
			var targetRotation:int = 0;			
			//var targetRotation:int = photos.rotation;
	
			
			var targetScale:Number = 1.0;	
		
			
			rowWidth += bounds.width + gap;
			if(rowWidth > maxX) // need to start a new row
			{
				rowWidth = gap;
				rowBaseline += rowHeight + gap;
				rowHeight = gap;
				
				targetX = rowWidth-xOff;
				targetY = rowBaseline-yOff;
				
			}
		Tweener.addTween(child, {scaleX: targetScale, scaleY: targetScale, rotation:targetRotation, x:targetX, y:targetY, time:0.65, transition:"easeinoutquad"});
		//syncPhotos(child);
		}
	}
	private function messPhotos(e:Event):void
	{
		var n:int = photos.numChildren;
		for(var i:int = 0; i<n; i++)
		{
			var child:DisplayObject = photos.getChildAt(i);
			if(child is Shape) continue; // void its 'clickgrabber'
			if(child is Wrapper) continue;
			minX = -350, maxX = 600;
			minY = -600, maxY = 600;
			var targetX:int = minX + Math.random() * (maxX-minX);
			var targetY:int = minY + Math.random() * (maxY-minY);
			var targetRotation:int = Math.random()*180;
			var targetScale:Number = (Math.random()*0.4) + 0.18;			
			Tweener.addTween(child, {scaleX: targetScale, scaleY: targetScale, rotation:targetRotation, x:targetX, y:targetY, time:0.65, transition:"easeinoutquad"});
			}
		}
		
	public function toggleCanvas(_photos)
	{
		removeChild(_photos);
	}	
	}	
}