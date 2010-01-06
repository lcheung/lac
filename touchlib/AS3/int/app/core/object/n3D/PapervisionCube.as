package app.core.object.n3D{	
public class PapervisionCube extends RotatableScalable{
public function PapervisionCube()
				{
					init3D();
					addEventListener(Event.ENTER_FRAME, loop3D);
				}

		private function init3D():void {
			container = new Sprite();
			//container.y= -150;
			dragBG.graphics.beginFill(0xFF0000,0.0);
			dragBG.graphics.drawRect(-100,-100,200,250);
			dragBG.graphics.endFill();
			addChild(dragBG);
			//container.scaleX= 0.5;
			//container.scaleY = 0.5;
			addChild( container );
			// create a new scene and use the container
			scene = new Scene3D( container );
			
			// create a new camera and position it
			camera = new Camera3D();
			camera.zoom = 1.1;
			camera.focus = 150;
			//camera.x = 3000;
			camera.z = 3000;
			camera.y = 3000;
			xwing.y = -150;
			xwing.scaleX = 0.5;
			xwing.scaleY = 0.5;
			xwing.scaleZ = 0.5;

			rootNode = scene.addChild( new DisplayObject3D("rootNode") );
			rootNode.y = -100;
			//rootNode.addChild(bgPlane);
			rootNode.addChild(xwing);			
			
		}
		
		/**
		 * The 3D animation loop
		 * @param event
		 */		
		private function loop3D( event:Event ):void {
			xwing.rotationX = _3dRot_x;
			xwing.rotationY = _3dRot_y;
			xwing.rotationZ = _3dRot_z;
		
			//trace(xwing);
			scene.renderCamera( camera );
		}
		private var myMaterials:Object;
		private var material:ColorMaterial;
		
		//private var materiallist:MaterialsList = new MaterialsList();
		private var container:Sprite;
		private var scene:Scene3D;
		private var camera:Camera3D;
		private var rootNode:DisplayObject3D;
		private var xwing:DisplayObject3D = new Collada( "assets/xwing.dae");
		//private var xwing:DisplayObject3D = new Collada( "3dXwing/assets/xwing.dae");
		
		public var _3dRot_x:Number = new Number(0);
		public var _3dRot_y:Number = new Number(0);
		public var _3dRot_z:Number = new Number(0);
		
		
		private var cube:Cube;
		private var dragBG:Sprite= new Sprite();

	}	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.*;
	import app.core.action.RotatableScalable;	
	
	import org.papervision3d.cameras.Camera3D;
	import org.papervision3d.materials.BitmapAssetMaterial;
	import org.papervision3d.materials.MaterialsList;
	import org.papervision3d.materials.WireframeMaterial;
	import org.papervision3d.materials.ColorMaterial;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.scenes.Scene3D;
	import org.papervision3d.objects.Collada;
	import org.papervision3d.objects.Cone;
	import org.papervision3d.objects.Cube;
	import org.papervision3d.objects.Plane;
}
	