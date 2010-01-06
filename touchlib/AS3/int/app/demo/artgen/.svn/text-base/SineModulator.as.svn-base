package app.demo.artgen
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;	
	
	public class SineModulator extends IModulator 
	{

		private var phase:Number = 0;
		private var phaseChange:Number = 0;
	
		public function SineModulator() 
		{
			setRate(1);

		}
		
		override public function setRate(r:Number):void
		{
			phaseChange = r * Math.PI * 2.0;

		}
		
		override public function run():Number
		{
			phase += phaseChange;
			
			if(phase > Math.PI * 2.0)
				phase -= Math.PI * 2.0;
				
			return Math.sin(phase);
		}
		
	}
}