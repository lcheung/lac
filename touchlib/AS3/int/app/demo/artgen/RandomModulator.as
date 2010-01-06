package app.demo.artgen
{
	import flash.display.*;
	import flash.events.*;

	
	public class RandomModulator extends IModulator 
	{

		private var phase:Number = 0;
		private var phaseChange:Number = 0;
		private var curValue:Number = 0.0;
	
		public function RandomModulator() 
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
			{
				phase -= Math.PI * 2.0;
				
				curValue = 2*(Math.random()-0.5);
				
			}
				
			return curValue;
		}
		
	}
}