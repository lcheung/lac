package app.demo.artgen
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;	
	
	public class ISwarmMember extends Shape 
	{
		protected var swarm:Swarm;
		public var vel:Point;
		protected var modulators:Array;
		protected var destinations:Array;
		protected var amounts:Array;		
		
		public var memberscale:Number = 1.0;
		public var memberalpha:Number = 1.0;		
	
		public function ISwarmMember() 
		{
			vel = new Point();			
			
			modulators = new Array();
			destinations = new Array();
			amounts = new Array();
			
			
		}
		
		public function track(pt:Point)
		{
		}
		
		public function setSwarm(s:Swarm)
		{
			swarm = s;
		}
		
		public function setupInfo(data:XMLList)
		{
			
		}
		
		public function addModulator(type:String, rate:Number, dest:String, amt:Number)
		{
			var m:IModulator;
			switch(type)
			{
				case "sine":
					m = new SineModulator();	
					break;
				case "square":
					m = new SquareModulator();				
					break;
				case "random":
					m = new RandomModulator();
					break;					
				default:
					m = new IModulator();
					break;
			}
			
			modulators.push(m);
			m.setRate(rate / 30.0);
			
			destinations.push(dest);
			amounts.push(amt);			
		}
		
		public function runModulators()
		{
			var i:int;
			var newrotation:Number = rotation;
			var newscale:Number = memberscale;
			var newalpha:Number = memberalpha;
			var newcolor;
			
			var offsetX:Number = 0;
			var offsetY:Number = 0;
			
			for(i=0; i<modulators.length; i++)
			{
				var v:Number = modulators[i].run();
				
				switch(destinations[i])
				{
					case "rotation":
						newrotation += v * amounts[i] * 180.0;
						break;
					case "scale":
						newscale += v * amounts[i];
						break;						
					case "alpha":
						newalpha += v * amounts[i];
						break;																		
					case "position":
					// FIXME: this is a bad way to modulate the position.. it's always gonna be diagonal. we should make
					// orthongal position modulation (to facing direction).. and maybe make a second parameter for forward, back.. 
						offsetX += v * amounts[i] * 100.0;
						offsetY += v * amounts[i] * 100.0;						
						break;																		
				}
			}
			
			if(newscale < 0.0)
				newscale = 0.0;
				
			if(newalpha < 0.0)
				newalpha = 0.0;
			if(newalpha > 1.0)
				newalpha = 1.0;
			
			scaleX = newscale;
			scaleY = newscale;
			rotation = newrotation;
			alpha = newalpha;
			
			x += offsetX;
			y += offsetY;
		}
	}
}