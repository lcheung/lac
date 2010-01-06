package app.core.object.n3D
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import flash.text.*;
	
	import flash.display.*;		
	import flash.events.*;
	import flash.net.*;
	import flash.events.*;
	import flash.geom.*;			
	import flash.filters.BlurFilter;
	import app.core.object.n3D.PapervisionCube;
	import app.core.element.*;
	
    import flash.filters.*;


	public class n3DObject extends MovieClip
	{		
		private var TKnobX:TouchlibKnob=  new TouchlibKnob(100);
		private var TKnobY:TouchlibKnob=  new TouchlibKnob(100);
		private var TKnobZ:TouchlibKnob=  new TouchlibKnob(100);	
		private var TSliderX:HorizontalSlider = new HorizontalSlider(300,25);
		private var TSliderY:HorizontalSlider = new HorizontalSlider(300,25);
		private var TSliderZ:HorizontalSlider = new HorizontalSlider(300,25);
		private var TSliderScale:HorizontalSlider = new HorizontalSlider(300,25);
		//private var TKnobZ:TouchlibKnob = new TouchlibKnob(30);
		private var boxRed:Sprite = new Sprite();
		private var boxHolder:Sprite = new Sprite();
		private var _3dCube = new PapervisionCube();
		
		private var resetBT:Sprite = new Sprite();
		
		public function n3DObject():void{
			
			resetBT.graphics.beginFill(0xFFFFFF,1.0);
			resetBT.graphics.drawRoundRect(0,0,100,100,10);
			resetBT.graphics.endFill();
			resetBT.x = 150;
			resetBT.y = -250;
			resetBT.addEventListener(TouchEvent.MOUSE_DOWN, resetPos);
			resetBT.addEventListener(MouseEvent.MOUSE_DOWN, resetPos);
			
			this.addChild(resetBT);
			
			/*boxRed.graphics.beginFill(0xFF0000, 1);
			boxRed.graphics.drawRect(-150,-75,300,150);
				
			boxHolder.addChild(boxRed);*/
			boxHolder.x = 0;
			boxHolder.y = 0;
			this.addChild(boxHolder);
			boxHolder.addChild(_3dCube);	
			_3dCube.x = -25;	
			_3dCube.y = 55;
			//var TKnob = new TouchlibKnob(100);
			TKnobX.x = 155;
			TKnobX.y = -135;
			this.addChild(TKnobX);
			
			TKnobY.x = 155;
			TKnobY.y = 0;
			this.addChild(TKnobY);
			
			TKnobZ.x = 155;
			TKnobZ.y = 135;
			this.addChild(TKnobZ);
			
			
			TSliderX.x = -200;
			TSliderX.y = -168;
			TSliderX.setValue(0.5);
			this.addChild(TSliderX);
			
			TSliderY.x = -200;
			TSliderY.y = -203;
		
			TSliderY.setValue(0.5);
			this.addChild(TSliderY);
			
			TSliderZ.x = -200;
			TSliderZ.y = -238;

			TSliderZ.setValue(0.5);
			this.addChild(TSliderZ);
			
			TSliderScale.x = -200;
			TSliderScale.y = 320;
		
			TSliderScale.setValue(0.5);
			this.addChild(TSliderScale);
			
			this.addEventListener(Event.ENTER_FRAME, this.frameUpdate);		
			
			}
			
			function resetPos(event:Event):void{
				TSliderX.setValue(0.5);
				TSliderY.setValue(0.5);
				TSliderZ.setValue(0.5);
				//TSliderScale.setValue(0.5);
				TKnobX.setValue(0);
				TKnobY.setValue(0);
				TKnobZ.setValue(0);					
				_3dCube._3dRot_x = 0;
				_3dCube._3dRot_y = 0;
				_3dCube._3dRot_z = 0;
				_3dCube.x = -25;	
				_3dCube.y = 55;
				//_3dCube._3dScale_x = 0;
				//_3dCube._3dScale_y = 0;	
				//_3dCube._3dScale_z = 1.0;
				}
			
			function frameUpdate(e:Event)
		{
			
			
			if(TKnobX.knobValue != 0){
				_3dCube._3dRot_x = TKnobX.knobValue*360;
				TSliderX.setValue(0.5);
			}
			if(TKnobY.knobValue != 0){
				_3dCube._3dRot_y = TKnobY.knobValue*360;
				TSliderY.setValue(0.5);
			}
			if(TKnobZ.knobValue != 0){
				_3dCube._3dRot_z = TKnobZ.knobValue*360;
				TSliderZ.setValue(0.5);
			}
			
			
			
			_3dCube._3dRot_x += (TSliderX.sliderValue*2)-1;
			_3dCube._3dRot_y += (TSliderY.sliderValue*2)-1;
			_3dCube._3dRot_z += (TSliderZ.sliderValue*2)-1;
			
			//_3dCube._3dScale_x += (TSliderZ.sliderValue*2)-1;
			//_3dCube._3dScale_y += (TSliderZ.sliderValue*2)-1;
			//_3dCube._3dScale_z += (TSliderScale.sliderValue*2)-1;
	
			
			//trace(TSliderH.sliderValue);
			//boxHolder.rotation = TKnob.knobValue*360;
			//trace(TSlider.sliderValue);
			//boxHolder.x = TSliderH.sliderValue*800;
		}				
	}
}