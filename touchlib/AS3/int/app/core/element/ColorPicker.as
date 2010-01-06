﻿// TODO: two finger color blending
// ----- Still some minor bugs on the toggling of the colorBar
// ----- make this class return a color value also.. similar to a slider

// instead of showing a thumbnail for each finger - just blend all the colors under all the fingers and show that
// we don't need to see thumbs for each one..  

package app.core.element
{
	import app.core.element.*;
	
	import flash.events.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.text.*;
	import flash.net.*;
	import flash.system.LoaderContext;
	import flash.utils.*;
	import app.core.action.Multitouchable;	
	
	import caurina.transitions.Tweener;
	
	public class ColorPicker extends Multitouchable
	{	trace('ColorPicker Created');
		private var imgLoader:Loader = null;	     
		private var separateByPixels:BitmapData; 	
		private var label:TextField;
		public var color:int;
		public var r:int;
		public var g:int;
		public var b:int;
		private var colorThumb:Shape;
		private var colorThumbBlend:Shape;
		
		private var selectedSpr:Sprite;
		private var sampleSprite:Sprite;
		
		function ColorPicker() {
			imgLoader = new Loader();		
			//imgLoader.contentLoaderInfo.addEventListener( ProgressEvent.PROGRESS, onProgressHandler);	
			imgLoader.contentLoaderInfo.addEventListener( Event.COMPLETE, onCompleteHandler, false, 0, true);	
			var context:LoaderContext = new LoaderContext();
			context.checkPolicyFile = true;		
			var request:URLRequest = new URLRequest( "www/img/color.png" );			
			imgLoader.unload();
			imgLoader.load( request, context);			
		}	
		function onCompleteHandler(event:Event = null){			
			_fmt = new TextFormat("_sans", 10, 0xFFFFFF,false,false,false,null,null,"right");
			label = new TextField(); 
			label.defaultTextFormat=_fmt; 
			label.blendMode='invert';		
			label.selectable=false;						
			label.x = imgLoader.width-110;
			label.y = -40;		
			
			//var image:Bitmap = Bitmap(imgLoader.content);
			separateByPixels = new BitmapData(imgLoader.width, imgLoader.height, false); 
			separateByPixels.draw(imgLoader);
			
			sampleSprite = new Sprite();
			sampleSprite.graphics.beginBitmapFill(separateByPixels);
			sampleSprite.graphics.drawRect(0, 0, imgLoader.width, imgLoader.height)
			sampleSprite.graphics.endFill();   
			sampleSprite.visible=false;
			//sampleSprite.scaleY = 0;
			//sampleSprite.y=-25;
			
			selectedSpr = new Sprite();
			selectedSpr.graphics.lineStyle(1.35, 0xffffff);
			selectedSpr.graphics.moveTo(-7, 0);
			selectedSpr.graphics.lineTo(7, 0);			
			selectedSpr.graphics.moveTo(0, -7);
			selectedSpr.graphics.lineTo(0, 7);	
			selectedSpr.blendMode='invert';			
			selectedSpr.visible=false;
				
			colorThumb = new Shape();
			colorThumb.graphics.beginFill(0xFFFFFF);
			colorThumb.graphics.drawRoundRect(0, -55, imgLoader.width, 50,6);
			colorThumb.graphics.endFill();		
			
			var colorThumbBorder = new Shape();
			colorThumbBorder.graphics.lineStyle(1, 0xffffff);
			colorThumbBorder.graphics.drawRoundRect(0, -55, imgLoader.width, 50,6);	
			
		
			addChild(colorThumb);
			addChild(colorThumbBorder);			
			addChild(sampleSprite);		
			addChild(label);		
			addChild(selectedSpr);	
	
		}	
		function setThumbColor(c) {
			var thumbColorTransform:ColorTransform = new ColorTransform();
			thumbColorTransform.color = c;
			colorThumb.transform.colorTransform = thumbColorTransform;
		}	
	
		public override function handleDownEvent(id:int, mx:Number, my:Number, targetObj:Object):void
		{	
			//trace('---------------------------------------------------------------------------------------'+blobs.length);
			if(targetObj is ColorPicker || targetObj is Shape)
			{ 	
				//selectedSpr.x = selectedSpr.y = 0;
				if(sampleSprite.alpha!=1){		
				sampleSprite.visible=true;		
				selectedSpr.visible=true;
				Tweener.addTween(sampleSprite, {alpha:1, time:0.35, transition:"easeinoutquad"});
				}
				else{				
				Tweener.addTween(sampleSprite, {alpha:0, time:0.35, transition:"easeinoutquad"});
				sampleSprite.visible=false;		
				selectedSpr.visible=false;
				}			
			}
			else{	
			//color1  = separateByPixels.getPixel(mx- this.x, my-this.y);		
			//setThumbColor(color1);		
			//color = color1;
			//r = color1 >> 16;
			//g = (color1 & 0xff00) >> 8;
			//b = color1 & 0xff;
			//label.text = r + ", " + g + ", " + b;					
			selectedSpr.x = mx- this.x;
			selectedSpr.y = my- this.y;	
			}
		
		}		

		public override function handleMoveEvent(id:int, mx:Number, my:Number, targetObj:Object):void
		{
			
			for(var i:int = 0; i<blobs.length; i++)
			{	//trace(blobs[i].history.length);
					
									
				color = separateByPixels.getPixel(mx- this.x, my-this.y);
				trace((mx-this.x)+', '+(my-this.y)+' --------------------ONE');		
				
				if(i >= 1){	
					color1  = separateByPixels.getPixel((blobs[i-1].history[0].x-this.x), (blobs[i-1].history[0].y-this.y));	
					color2  = separateByPixels.getPixel((blobs[i-0].history[0].x-this.x), (blobs[i-0].history[0].y-this.y));
					trace((blobs[i].history[0].x-this.x)+', '+ (blobs[i].history[0].y-this.y)+' --------------------TWO+');		
					color = (color2 + color1)/2;	
						if((blobs[i-0].history[0].y-this.y) >=2){		setThumbColor(color);	}
				}	
				else{
				
				}		
				if(my- this.y >=2){			
				setThumbColor(color);	
				selectedSpr.x = mx- this.x;
				selectedSpr.y = my- this.y;
				}
			}	
			
			//r = color1 >> 16;
			//g = (color1 & 0xff00) >> 8;
			//b = color1 & 0xff;
			//label.text = r + ", " + g + ", " + b;					
			//selectedSpr.x = mx- this.x;
			//selectedSpr.y = my- this.y;
		}		

	}
}
