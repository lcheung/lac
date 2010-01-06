package app.core.utl {
//-----------------------------------------------------------------------------------------------------------
	import flash.geom.*
	import flash.display.*
	import flash.events.*;
//-----------------------------------------------------------------------------------------------------------	
	public class AnimatingGradient extends Sprite	{
//----------------------------------------------------------------------------------------------------------- 			
		public var sColor:uint;
		public var eColor:uint;
		
		private var sTwnSteps:Array;
		private var eTwnSteps:Array;
		
		private var gWidth:uint;
		private var gHeight:uint;
		private var alphas:Array;
		private var ratios:Array;
		private var matr:Matrix;
		private var spreadMethod:String;
		private var fillType:String;
		
		private var twnFrames:uint;
		private var currentFrame:uint;
//-----------------------------------------------------------------------------------------------------------		
		public function AnimatingGradient(width:uint, height:uint, startColor:uint, endColor:uint)	{
			this.sColor = startColor;
			this.eColor = endColor;
			
			var colors:Array = [startColor, endColor];
		
			this.gWidth=width;
			this.gHeight=height;
			this.fillType = GradientType.LINEAR;
			this.alphas = [100, 100];
			this.ratios = [0x00, 0xFF];
			this.matr = new Matrix();
			matr.createGradientBox(width, height, (90 * Math.PI/180), 0, 0);
			this.spreadMethod = SpreadMethod.PAD;
			this.updateGradient(startColor, endColor);		
		}
//-----------------------------------------------------------------------------------------------------------		
		public function stop():void	{
			this.removeEventListener(Event.ENTER_FRAME, doTween);
			this.dispatchEvent(new Event("stopped"));
		}
//-----------------------------------------------------------------------------------------------------------		
		public function tweenGradient(startColor:int, endColor:int, steps:int):void	{
			this.currentFrame=0
			this.stop();
			
			this.sTwnSteps = this.getDifferenceAsSteps(this.HEXtoRGB(this.sColor), this.HEXtoRGB(startColor), steps);
			this.eTwnSteps = this.getDifferenceAsSteps(this.HEXtoRGB(this.eColor), this.HEXtoRGB(endColor), steps);
			this.sColor = startColor;
			this.eColor = endColor;
			this.addEventListener(Event.ENTER_FRAME, doTween);
		}
//-----------------------------------------------------------------------------------------------------------		
		private function doTween(event:Event):void	{
			this.dispatchEvent(new Event("changed"));
			this.updateGradient(this.RGBtoHEX(sTwnSteps[this.currentFrame].r,sTwnSteps[this.currentFrame].g,sTwnSteps[this.currentFrame].b), this.RGBtoHEX(eTwnSteps[this.currentFrame].r,eTwnSteps[this.currentFrame].g,eTwnSteps[this.currentFrame].b));
			if(this.currentFrame==this.twnFrames-1) {
				delete this.removeEventListener(Event.ENTER_FRAME, doTween);
				this.dispatchEvent(new Event("finish"));
			}
			else this.currentFrame++;
		}
//-----------------------------------------------------------------------------------------------------------		
		private function updateGradient(s:int,e:int):void	{
			this.graphics.clear();
			this.graphics.beginGradientFill(this.fillType, [s, e], this.alphas, this.ratios, this.matr, this.spreadMethod);  
			this.graphics.drawRect(0,0,this.gWidth,this.gHeight);
			this.graphics.endFill();
		}
//-----------------------------------------------------------------------------------------------------------		
		private function HEXtoRGB(hex:uint):Object{
				return {r:hex >> 16, g:(hex >> 8) & 0xff, b:hex & 0xff};
		}
//-----------------------------------------------------------------------------------------------------------		
		private function RGBtoHEX(red:uint, green:uint, blue:uint):uint	{
			var s:String = new String('0x');
			var r:String = red.toString(16);
			s += (r.length<2)?('0'+r):r;
			var g:String = green.toString(16);
			s += (g.length<2)?('0'+g):g;
			var b:String = blue.toString(16);
			s += (b.length<2)?('0'+b):b;
			return Number(s);
		}
//-----------------------------------------------------------------------------------------------------------		
		private function getDifferenceAsSteps(a:Object, z:Object, stepCount:uint):Array {
			stepCount--;
			
			var r:Number = ((z.r - a.r) / stepCount);
			var g:Number = ((z.g - a.g) / stepCount);
			var b:Number = ((z.b - a.b) / stepCount);  

			var rgbVector:Array = new Array(); 
			var i:int=0;
			var obj:Object = new Object();
			while(i < stepCount){
				obj = (i > 0) ? rgbVector[i-1] : a;
				rgbVector.push({r:obj.r+r, g:obj.g+g, b:obj.b+b});
				i++;
			}
			rgbVector.unshift(a);
			this.twnFrames = rgbVector.length;
			return rgbVector;
			
		}
//-----------------------------------------------------------------------------------------------------------
	}
}