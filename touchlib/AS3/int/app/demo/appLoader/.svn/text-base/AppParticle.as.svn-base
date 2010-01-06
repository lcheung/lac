package app.demo.appLoader
{
	import flash.events.*;
	import app.demo.appLoader.*;
	
	import flash.events.*;
	import flash.geom.*;
	import flash.display.*;	
	import fl.controls.Button;
	import flash.text.*;
	import flash.net.*;
	
	public class AppParticle extends Sprite
	{
		private var direction:int = 0;		
		private var dirChangeCount:int = 0;
		
		private var cursor:Point;
		
		private var upVec:Point;
		
		private var history:Array;
		
		private var life:int = 0;
		
		function AppParticle()
		{
			history = new Array();
			direction = int(Math.random()*8);
			dirChangeCount = 0;
			upVec = new Point(6, 0);
			cursor = new Point(0,0);
			history.push(new Point(cursor.x, cursor.y));			
			addEventListener(Event.ENTER_FRAME, frameUpdate, false, 0, true);
			life = 30;

		}
		
		function frameUpdate(e:Event)
		{
			// FIXME: draw from last history point to cursor
			//this.graphics.lineStyle(1,0xffffff, 0.5, true);						
			//this.graphics.moveTo(history[history.length-1].x, history[history.length-1].y);			
			//this.graphics.moveTo(history[0].x, history[0].y);			
			this.graphics.lineTo(cursor.x, cursor.y);

			var m:Matrix = new Matrix();
			m.rotate(direction * Math.PI / 4.0);
			var delta:Point = m.transformPoint(upVec);
			
			cursor.x += delta.x;
			cursor.y += delta.y;			

			dirChangeCount -= 1;
			
			life -= 1;
			

			
			if(dirChangeCount <= 0)
			{
				direction += int(Math.random()*4)-2;
				direction = direction % 8;
				dirChangeCount = 1;
			
				history.push(new Point(cursor.x, cursor.y));
				
				if(history.length >= 10)
				{
					history.splice(0, 1);
				}
				
				var i:int;
				
				this.graphics.clear();
				this.graphics.moveTo(history[0].x, history[0].y);
				this.graphics.lineStyle(2,0xffffff, this.life / 300.0, true);			
	

				for(i =0; i<history.length; i++)
				{
					// FIXME: draw history.. 
					this.graphics.lineTo(history[i].x, history[i].y);
					
					//trace("" + i + ":" + history[i].x + "," + history[i].y);
				}
				
		
			
			}						
			
			if(life <= 0)
			{
				removeEventListener(Event.ENTER_FRAME, frameUpdate);				
				this.parent.removeChild(this);
			}
			
			
		}
	}
}

/*

	var colArray:Array = new Array();
	colArray.push(0xffffff);
	colArray.push(0x000000);
	var alphaArray:Array = new Array();
	alphaArray.push(100, 100);
	var ratiosArray:Array = new Array();
	ratiosArray.push(0);
	ratiosArray.push(255);
	var gm:Matrix = new Matrix();
	gm.createGradientBox(200, 200, 0, 0,0);
	this.graphics.lineGradientStyle(GradientType.RADIAL, colArray, alphaArray, ratiosArray, gm);

*/