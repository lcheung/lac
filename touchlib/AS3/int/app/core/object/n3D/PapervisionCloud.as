/*
 *  PAPER    ON   ERVIS  NPAPER ISION  PE  IS ON  PERVI IO  APER  SI  PA
 *  AP  VI  ONPA  RV  IO PA     SI  PA ER  SI NP PE     ON AP  VI ION AP
 *  PERVI  ON  PE VISIO  APER   IONPA  RV  IO PA  RVIS  NP PE  IS ONPAPE
 *  ER     NPAPER IS     PE     ON  PE  ISIO  AP     IO PA ER  SI NP PER
 *  RV     PA  RV SI     ERVISI NP  ER   IO   PE VISIO  AP  VISI  PA  RV3D
 *  ______________________________________________________________________
 *  papervision3d.org + blog.papervision3d.org + osflash.org/papervision3d
 */

// _______________________________________________________________________ PaperCloud

package app.core.object.n3D
{
import flash.display.*;
import flash.events.*;
import flash.geom.ColorTransform;
import flash.utils.Dictionary;
//import flash.filters.*;
import caurina.transitions.Tweener;
	import flash.geom.*;
	import flash.system.LoaderContext;    

	import flash.net.*;

	import flash.system.LoaderContext;
// Import Papervision3D
import org.papervision3d.core.proto.*;
import org.papervision3d.scenes.*;
import org.papervision3d.cameras.*;
import org.papervision3d.objects.*;
import org.papervision3d.materials.*;
import org.papervision3d.materials.MaterialsList;
import flash.events.*;
import app.core.utl.ColorUtil;
import app.core.element.*;

import org.papervision3d.events.FileLoadEvent;

public class PapervisionCloud extends MovieClip
{
	// ___________________________________________________________________ 3D vars

	public var container :Sprite;
	public var scene     :MovieScene3D;
	public var camera    :Camera3D;

	public var planeByContainer :Dictionary = new Dictionary();


	// ___________________________________________________________________ Album vars

	public var paperSize :Number = 0.5;
	public var cloudSize :Number = 500;
	public var rotSize   :Number = 360;
	public var maxAlbums :Number = 3;
	public var num       :Number = 0;

	public var materials:MaterialsList;
	// ___________________________________________________________________ stage

	//public var iFull :SimpleButton = new SimpleButton();


	// ___________________________________________________________________ main

	public function PapervisionCloud()
	{	
		//TUIO.init( this, 'localhost', 3000, '', true );
	
		//stage.quality = StageQuality.MEDIUM;

		init3D();

		this.addEventListener( Event.ENTER_FRAME, loop );
	}


	// ___________________________________________________________________ Init3D

	public function init3D():void
	{	
		var spr1:Sprite = new Sprite();
		spr1.graphics.beginFill(0x00FFFF,1.0);
		spr1.graphics.drawRect(-0,-0,100,100);
		var WrapperObject3:Wrapper = new Wrapper(spr1);	
		WrapperObject3.addEventListener(MouseEvent.CLICK, sortOne);		
		WrapperObject3.x = -100; 
		WrapperObject3.y = -350;
		this.addChild(WrapperObject3);	
		
		var spr2:Sprite = new Sprite();
		spr2.graphics.beginFill(0xFFFF00,1.0);
		spr2.graphics.drawRect(-0,-0,100,100);
		var WrapperObject4:Wrapper = new Wrapper(spr2);	
		WrapperObject4.addEventListener(MouseEvent.CLICK, sortTwo);		
		WrapperObject4.x = 0; 
		WrapperObject4.y = -350;
		this.addChild(WrapperObject4);	
		
		var spr3:Sprite = new Sprite();
		spr3.graphics.beginFill(0xFF00FF,1.0);
		spr3.graphics.drawRect(-0,-0,100,100);
		var WrapperObject5:Wrapper = new Wrapper(spr3);	
		WrapperObject5.addEventListener(MouseEvent.CLICK, sortThree);		
		WrapperObject5.x = 100; 
		WrapperObject5.y = -350;
		this.addChild(WrapperObject5);	
		
		container = new Sprite();
		addChild( container );
		container.x = 0;
		container.y = 0;

		// Create scene
		scene = new MovieScene3D( container );

		// Create camera
		camera = new Camera3D();
		camera.zoom = 5;

		// Store camera properties
		camera.extra =
		{
			goPosition: new DisplayObject3D(),
			goTarget:   new DisplayObject3D()
		};

		camera.extra.goPosition.copyPosition( camera );
	}

	public function createAlbum()
	{		
		
		/*color = ColorUtil.random(0,0,0);		
		material_0 = new BitmapFileMaterial();
		material_0.addEventListener(FileLoadEvent.LOAD_COMPLETE, handleFileLoaded);
		material_0.texture = "1.png";		
		material_0.smooth=true;
		material_0.doubleSided = true;*/	
		var loaderContext:LoaderContext = new LoaderContext ();
		loaderContext.checkPolicyFile = true;								
		var imageLoader:Loader = new Loader();			
		imageLoader.contentLoaderInfo.addEventListener( Event.COMPLETE, handleFileLoaded );
		imageLoader.load( new URLRequest( '1.png' ), loaderContext );
	}	
	
	public function handleFileLoaded(e:Event):void
		{			
		var loadedBmp : Bitmap = e.target.content as Bitmap;
		var bmp : BitmapData = loadedBmp.bitmapData;				
		var bmpWithReflection:BitmapData = new BitmapData(bmp.width, bmp.height*2, false, 0);				
		
		bmpWithReflection.draw(bmp);				
	 
		var alpha:Number = 0.3;
        var flipMatrix:Matrix = new Matrix(1, 0, 0, -1, 0, bmp.height*2 + 4);
        bmpWithReflection.draw( bmp, flipMatrix, new ColorTransform(alpha, alpha, alpha, 1, 0, 0, 0, 0) );         
				
				
		var holder:Shape = new Shape();
		var gradientMatrix:Matrix = new Matrix();
		gradientMatrix.createGradientBox( bmp.width, bmp.height, Math.PI/2 );
				
		holder.graphics.beginGradientFill( GradientType.LINEAR, [ 0, 0 ], [ 0, 10 ], [ 0, 0xFF ], gradientMatrix)
		holder.graphics.drawRect(0, 0, bmp.width, bmp.height);
		holder.graphics.endFill();
				 
		var m:Matrix  = new Matrix();
		m.translate(0, bmp.height);
		bmpWithReflection.draw( holder, m );
				 
				
		var planeMaterial:BitmapMaterial = new BitmapMaterial(bmpWithReflection);
		planeMaterial.smooth = true;
		planeMaterial.doubleSided = true;

		var plane:Plane = new Plane( planeMaterial, bmp.width, bmp.height, 4, 4 );
		scene.addChild(plane);
			
		// Randomize position
		var gotoData :DisplayObject3D = new DisplayObject3D();

		//gotoData.x = 50+Math.random() * cloudSize - cloudSize/2;
		//gotoData.y = 50+Math.random() * cloudSize - cloudSize/2;
		//gotoData.z = Math.random() * cloudSize - cloudSize/2;
		
		gotoData.rotationX = 0;
		gotoData.rotationY = 0;
		gotoData.rotationZ = 0;
		
		//gotoData.rotationX = Math.random() * rotSize;
		//gotoData.rotationY = Math.random() * rotSize;
		//gotoData.rotationZ = Math.random() * rotSize;
		
		

		plane.extra =
		{
			goto: gotoData
		};

		// Include in scene
		scene.addChild( plane, "obj" + String( num ) );
		trace("obj" + String( num ) );
		var container:Sprite = plane.container;
		container.buttonMode = true;
		container.addEventListener( TouchEvent.MOUSE_OVER, doRollOver );
		container.addEventListener( TouchEvent.MOUSE_OUT, doRollOut );
		container.addEventListener( TouchEvent.MOUSE_DOWN, doPress );
		
		container.addEventListener( MouseEvent.ROLL_OVER, doRollOver );
		container.addEventListener( MouseEvent.ROLL_OUT, doRollOut );
		container.addEventListener( MouseEvent.MOUSE_DOWN, doPress );

		planeByContainer[ container ] = plane;

		num++;
			//addEventListener(Event.ENTER_FRAME, loop);
		}
	private function tweenObject(inChild,i,x,y,z,rx,ry,rz,sx,sy,sz):void
	{
			var targetAlpha:int = 1;
			var targetX:int = 100*i;
			var targetY:int = 100*i;	
			var targetZ:int = -100*i;
			var targetRotationX:int = 0;			
			var targetRotationY:int = 0;		
			var targetRotationZ:int = 0;
			var targetScaleX:Number = 1.0;		
			var targetScaleY:Number = 1.0;		
			var targetScaleZ:Number = 1.0;	    
    		
    		Tweener.addTween(inChild, {
    		x:targetX, 
    		y:targetY, 
    		z:targetZ, 
    		scaleX: targetScaleX, 
    		scaleY: targetScaleY, 	
    		scaleZ: targetScaleZ,     	
    		delay:0,
    		time:0.35, 
    		transition:"easeinoutquad"});	
		}
		
	private function sortOne(e:Event):void
	{
		var n:int = scene.numChildren;
		trace(n);
		trace(scene.getChildByName('obj0'));
		for(var i:int = 0; i<n; i++)
		{
		var child:DisplayObject3D = scene.getChildByName('obj'+i);
		if(child is Wrapper) continue;				
			var targetAlpha:int = 1;
			var targetX:int = 0;
			var targetY:int = 0;	
			var targetZ:int = -i*20;
			var targetRotationX:int = 0;			
			var targetRotationY:int = 0;		
			var targetRotationZ:int = 0;
			var targetScaleX:Number = 1.0;		
			var targetScaleY:Number = 1.0;		
			var targetScaleZ:Number = 1.0;	    
        	
    		Tweener.addTween(child, {
    		x:targetX, 
    		y:targetY, 
    		z:targetZ, 
    		rotationX:targetRotationX,
    		rotationY:targetRotationY,
    		rotationZ:targetRotationZ,
    		scaleX: targetScaleX, 
    		scaleY: targetScaleY, 	
    		scaleZ: targetScaleZ,     	
    		delay:0,
    		time:0.35, 
    		transition:"easeinoutquad"});	
		}
	}	
	
	private function sortThree(e:Event):void
	{
		var n:int = scene.numChildren;
		trace(n);
		trace(scene.getChildByName('obj0'));
		for(var i:int = 0; i<n; i++)
		{
		var child:DisplayObject3D = scene.getChildByName('obj'+i);
		if(child is Wrapper) continue;				
			var targetAlpha:int = 1;
			var targetX:int = -100*i;
			var targetY:int = -25*i;	
			var targetZ:int = -100*i;
			var targetRotationX:int = 0;			
			var targetRotationY:int = 0;		
			var targetRotationZ:int = 0;
			var targetScaleX:Number = 1.0;		
			var targetScaleY:Number = 1.0;		
			var targetScaleZ:Number = 1.0;	     		
			
    		Tweener.addTween(child, {
    		x:targetX, 
    		y:targetY, 
    		z:targetZ, 
    		rotationX:targetRotationX,
    		rotationY:targetRotationY,
    		rotationZ:targetRotationZ,
    		scaleX: targetScaleX, 
    		scaleY: targetScaleY, 	
    		scaleZ: targetScaleZ,     	
    		delay:0,
    		time:0.35, 
    		transition:"easeinoutquad"});
		}
	}	
private function sortTwo(e:Event):void
	{
		var n:int = scene.numChildren;
		trace(n);
		trace(scene.getChildByName('obj0'));
		for(var i:int = 0; i<n; i++)
		{
		var child:DisplayObject3D = scene.getChildByName('obj'+i);
		if(child is Wrapper) continue;			
			
			var targetAlpha:int = 1;
			var targetX:int = 0;
			var targetY:int = 0;	
			var targetZ:int = -i*20;
			var targetRotationX:int = 0;			
			var targetRotationY:int = 180;		
			var targetRotationZ:int = 0;
			var targetScaleX:Number = 1.0;		
			var targetScaleY:Number = 1.0;		
			var targetScaleZ:Number = 1.0;	     		

    		Tweener.addTween(child, {
    		x:targetX, 
    		y:targetY, 
    		z:targetZ, 
    		rotationX:targetRotationX,
    		rotationY:targetRotationY,
    		rotationZ:targetRotationZ,
    		scaleX: targetScaleX, 
    		scaleY: targetScaleY, 	
    		scaleZ: targetScaleZ,     	
    		delay:0,
    		time:0.35, 
    		transition:"easeinoutquad"});
		}
	}	
	private function doPress(event:Event):void
	{
		var plane:Plane = planeByContainer[ event.target ];
		//trace(plane);
		plane.scaleX = 1;
		plane.scaleY = 1;

		var target :DisplayObject3D = new DisplayObject3D();

		target.copyTransform( plane );
		target.moveBackward( 350 );

		camera.extra.goPosition.copyPosition( target );
		camera.extra.goTarget.copyPosition( plane );

		plane.material.lineAlpha = 0;

//		event.target.filters = null;
	};


	private function doRollOver(event:Event):void
	{
		//var plane:Plane = planeByContainer[ event.target ];
		//plane.scaleX = 1.1;
		//lane.scaleY = 1.1;

		//plane.material.lineAlpha = 1;

		//var glow:Number = Math.max( 20, Math.min( 30, 10 + 20 * (1 - plane.screenZ / cloudSize ) ) );		
		//event.target.filters = [new GlowFilter( 0xFFFFFF, 0.7, glow, glow, 1, 1, false, false ) ];
	};


	private function doRollOut(event:Event):void
	{
		//var plane:Plane = planeByContainer[ event.target ];
		//plane.scaleX = 1;
		//plane.scaleY = 1;

		//plane.material.lineAlpha = 0;

//		event.target.filters = null;
	};


	// ___________________________________________________________________ Loop

	private function loop(event:Event):void
	{
		if( num < maxAlbums )
			createAlbum();

		update3D();
	}


	private function update3D():void
	{
		var target     :DisplayObject3D = camera.target;
		var goPosition :DisplayObject3D = camera.extra.goPosition;
		var goTarget   :DisplayObject3D = camera.extra.goTarget;

		camera.x -= (camera.x - goPosition.x) /32;
		camera.y -= (camera.y - goPosition.y) /32;
		camera.z -= (camera.z - goPosition.z) /32;

		target.x -= ((target.x - goTarget.x) /32);
		target.y -= ((target.y - goTarget.y) /32);
		target.z -= (target.z - goTarget.z) /32;

		var paper :DisplayObject3D;

		for( var i:Number=0; paper = scene.getChildByName( "Album"+i ); i++ )
		{
			var goto :DisplayObject3D = paper.extra.goto;

			paper.x -= (paper.x - goto.x) / 32;
			paper.y -= (paper.y - goto.y) / 32;
			paper.z -= (paper.z - goto.z) / 32;

			paper.rotationX -= ((paper.rotationX - goto.rotationX) /32);
			paper.rotationY -= ((paper.rotationY - goto.rotationY) /32);
			paper.rotationZ -= (paper.rotationZ - goto.rotationZ) /32;
		}

		// Render
		scene.renderCamera( this.camera );
	}




}
}