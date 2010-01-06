package app.core.object {

	import flash.events.*;
	import flash.system.LoaderContext;
	import flash.net.URLRequest;
	import flash.display.*;

	
	import caurina.transitions.Tweener;
	
	import app.core.loader.nLoader;	
	//import app.core.object.TextObject;	
	import app.core.action.Physical;
	
	public class ImageObject extends Physical 
	{		
		public var doubleTapEnabled: Boolean;
		
		public var swfboard: Loader;
		
		private var progressBar:Sprite = new Sprite();	
		private var clickgrabber:Shape = new Shape();	
		private var photoBack:Sprite = new Sprite();		
		private var photoLoader:Loader = null;		
		
		private var thisTween:Boolean;
		private var thisSlide:Boolean;	
		private var _thisScaleDown:Boolean;	
			
		private var velX:Number = 0.0;
		private var velY:Number = 0.0;		
		
		private var velAng:Number = 0.0;
		 
		private var friction:Number = 0.85;
		private var angFriction:Number = 0.92;
		
	
		//private var TextObject_0:TextObject;	
		
		public function ImageObject (url:String, mouseSelect:Boolean, thisTweenX:Boolean, thisSlideX:Boolean, thisScaleDown:Boolean)
		{
			_thisScaleDown=thisScaleDown;
			mouseSelection=mouseSelect;
			thisTween=thisTweenX;
			thisSlide=thisSlideX;		
			
			scaleBehavior = "Discrete";
			
		
			doubleTapEnabled = false;		
			photoLoader = new Loader();		

			photoLoader.contentLoaderInfo.addEventListener( ProgressEvent.PROGRESS, onProgressHandler);	
			photoLoader.contentLoaderInfo.addEventListener( Event.COMPLETE, arrange, false, 0, true);	
			photoLoader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, onIOError);
			var context:LoaderContext = new LoaderContext();
			context.checkPolicyFile = true;				
			
			progressBar.graphics.beginFill(0xFFFFFF,1);
			progressBar.graphics.drawRect(0, 0, 25, 100);
			progressBar.graphics.endFill();				
			    
			photoBack.graphics.beginFill(0x000000,0.75);
			photoBack.graphics.drawRect(0, 0, 1,1);
			photoBack.graphics.endFill();	
			//photoBack.blendMode = 'invert';				
			
			clickgrabber.graphics.beginFill(0xFFFFFF, 1);
			clickgrabber.graphics.drawRect(0, 0, 1,1);
			clickgrabber.graphics.endFill();	
			
			var request:URLRequest = new URLRequest( url );				
	
			photoLoader.unload();
			photoLoader.load( request , context);						
	
			//this.addChild( photoLoader );				
			this.addChild( clickgrabber );
			this.addChild( photoBack );
			//this.addChild( progressBar );
			
		//	TextObject_0 = new TextObject(url);	
		//	TextObject_0.noMove=true;		
		//	TextObject_0.visible=false;		
		//	this.addChild(TextObject_0);	
			
			if(thisSlide){	
			//this.addEventListener(Event.ENTER_FRAME, slide);
			}
		
		}
		private function onProgressHandler(mProgress:ProgressEvent)
		{	
		var percent:Number = -100*(mProgress.target.bytesLoaded/mProgress.target.bytesTotal);
		//progressBar.alpha=percent;			
		///trace(percent);
		}
		private function arrange( event:Event = null ):void 
		{							
			Tweener.addTween(clickgrabber, {alpha:0, time:1, transition:"easeinoutquad"});	
			//removeChild(progressBar);	
			//this.x = 0;
			//this.y = 0;	
			//this.scaleX = 0;
			//this.scaleY =0;	
			this.alpha = 1;
			//this.rotation =  Math.random()*180 - 90;				

			
//			photoLoader.scaleX = 0.01;
//			photoLoader.scaleY = 0.01;						
			photoLoader.x = -photoLoader.width/2;
			photoLoader.y = -photoLoader.height/2;			
			
		
			clickgrabber.scaleX = photoLoader.width;
			clickgrabber.scaleY = photoLoader.height;			
			clickgrabber.x = -photoLoader.width/2;
			clickgrabber.y = -photoLoader.height/2;			
			
			photoBack.scaleX = photoLoader.width;
			photoBack.scaleY = photoLoader.height;			
			photoBack.x = -photoLoader.width/2;
			photoBack.y = -photoLoader.height/2;				
			photoBack.alpha = 0.0;
			
		//	TextObject_0.visible=true;
		//	TextObject_0.scaleX = 0.20;
		//	TextObject_0.scaleY = 0.20;	
		//	TextObject_0.x=0;	
		//	TextObject_0.y=photoLoader.height/2+15;	 			
			
		if(thisTween) {						
			var targetX:int = this.x;	
			var targetY:int = this.y;		
			var targetRotation:int = Math.random()*180 - 90;	 
			var targetScale:Number = (Math.random()*0.4) + 0.4;			
			Tweener.addTween(this, {x:targetX, y:targetY,scaleX: targetScale, scaleY: targetScale, delay:0,time:1, transition:"easeinoutquad"});	
		}
		else {			
			//random
//			this.scaleX = (Math.random()*0.4) + 0.3;
//			this.scaleY = this.scaleX;
//			this.rotation = Math.random()*180 - 90;
//			this.x = 700 * Math.random() - 350;
//			this.y = 700 * Math.random() - 350;	
			this.alpha = 1.0;
			
			//static
			//this.scaleX = 0.5;
			//this.scaleY = 0.5;	
			//this.rotation = 0;		
			//this.x = 0;
			//this.y = 0;	
		}  
			
		var image:Bitmap = Bitmap(photoLoader.content);
		image.smoothing=true;
		
		image.x = -image.width/2;
		image.y = -image.height/2;	
		
		this.addChildAt(image,0);    	
		
		if(_thisScaleDown) 
		{
			this.x = 0;
			this.y = 0;        
			this.scaleX=0.1;
			this.scaleY=0.1;
		}
		
		/*
		nLoad_0 = new Loader();
		nLoad_0.load(new URLRequest("www/swf/stack.swf"));
		//var nLoad_0 = new nLoader("www/swf/stack.swf",0,0);
 		nLoad_0.contentLoaderInfo.addEventListener( Event.COMPLETE, swfLoaded );
		//nLoad_0.x=-250;
		//nLoad_0.y=-190;
		
		nLoad_0.x=clickgrabber.width*0.5-49;	
		nLoad_0.y=-clickgrabber.height*0.5-2;
		this.addChild(nLoad_0);			      
		//this.addEventListener(MouseEvent.CLICK, MouseDownKey);
		*/
		}				
		
		public function swfLoaded(e:Event)
		{		
			//trace('Sub-Menu Object Created');
			//var mc:MovieClip = nLoad_0.content;	
			//mc['stack1'].addEventListener(MouseEvent.CLICK, MouseDownKey);
		}
		
		public function MouseDownKey(e:Event) 
		{					
			trace('target parent :'+e.target.parent.parent.parent.parent.parent.name);
			trace('target :'+e.target.name);
			trace('parent :'+parent);
			trace('parent parent :'+parent.parent);
			trace('root :'+root);
			trace('this :'+this);		
			//e.target.parent.parent.parent.parent.parent=null;
			//trace(parent.getChildByName('TextObject_0'));
			//parent.parent.photos.removeChild(getChildByName('ImageObject_0'));	
		}
		
		/*
		public override function released(dx:Number, dy:Number, dang:Number)
		{
			velX = dx;
			velY = dy;				
			velAng = dang;
		}
		*/
		function onIOError(e:Event)
		{
			trace(e);
		}
		

/*		public override function doubleTap()
		{
	   	if(!doubleTapEnabled){
		//Tweener.addTween(this, {scaleX: 1, scaleY: 1,x:0, y:0,rotation: 0, time:0.30, transition:"easeinoutquad"});		
		Tweener.addTween(this, { scaleX: 1, scaleY: 1, time:0.45, transition:"easeinoutquad"});		
	   	Tweener.addTween(photoBack, {alpha:0.0, delay: 0.05, time:0.25,  transition:"easeinoutquad"});
	   	doubleTapEnabled = true;
	   	}
	   	else{	
	   	//Tweener.addTween(this, {scaleX: 1.0, scaleY: 0,x:this.x+200, y:this.y+200, rotation: Math.random()*180 - 90,  time:0.35,  transition:"easeinoutquad"});	
	   	 
	   	  Tweener.addTween(this, {scaleX: -1.0, scaleY: 1.0,  delay: 0.0, time:0.45,  transition:"easeinoutquad"});
	      Tweener.addTween(photoBack, {alpha:1.0, delay: 0.05, time:0.25,  transition:"easeinoutquad"});
	   	  doubleTapEnabled = false;	   	
	   	  //Tweener.addTween(this, {scaleX: 1.0, scaleY: 1.0,  time:0.35,  transition:"easeinoutquad"}); 	
	   	 }
	   	}*/
		/*
		private function slide(e:Event):void
		{
			if(this.state == "none")
			{		
				if(Math.abs(velX) < 0.001)
					velX = 0;
				else {
					x += velX;
					velX *= friction;										
				}
				if(Math.abs(velY) < 0.001)
					velY = 0;					
				else {
					y += velY;
					velY *= friction;						
				}
				if(Math.abs(velAng) < 0.001)
					velAng = 0;					
				else {
					velAng *= angFriction;				
					this.rotation += velAng;					
				}
			}
		}
		*/
		
		
	}
}