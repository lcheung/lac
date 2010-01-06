//

package app.demo.tank {
	import flash.events.TUIO;
	import app.demo.tank.*;	
	import flash.events.*;
	import flash.geom.*;
	import flash.display.*;
	import flash.system.fscommand;
	import flash.system.Capabilities;
	
	dynamic public class TankGame extends MovieClip
	{

		public var arenaWidth:int = 500;
		public var arenaHeight:int = 300;
		
	
		private var playerArray:Array;
		
		function TankGame()
		{
			playerArray =  new Array();
			
			arenaWidth = mcArenaMask.width;
			arenaHeight = mcArenaMask.height;
			
			TUIO.init( this, 'localhost', 3000, '', true );
			//TUIO.init( this, 'localhost', 3000, '', false );			// www/xml/test2.xml
			
			var plyr:PlayerTank;
			plyr = new PlayerTank(this, 1);
			playerArray.push(plyr);			
			plyr.setUIPosition(100, 550, 0);
			plyr.setTankPosition(50, arenaHeight - 50, 45);
			
			plyr = new PlayerTank(this, 2);
			playerArray.push(plyr);
			plyr.setUIPosition(295, 50, 180);
			plyr.setTankPosition(50, 50, 135);	
			
			plyr = new PlayerTank(this, 3);
			playerArray.push(plyr);
			plyr.setUIPosition(510, 550, 0);
			plyr.setTankPosition(arenaWidth-50, arenaHeight - 50, -45);
			
			plyr = new PlayerTank(this, 4);
			playerArray.push(plyr);
			plyr.setUIPosition(700, 50, 180);
			plyr.setTankPosition(arenaWidth-50, 50, 225);	
			
		
			// FIXME: create a play field for tanks..
			//this.addEventListener(Event.ENTER_FRAME, frameUpdate, false, 0, true);		

			if(this.stage)
			{
				addedToStage(new Event(Event.ADDED_TO_STAGE));
			} else {
				this.addEventListener(Event.ADDED_TO_STAGE, addedToStage, false, 0, true);
			}
				
			this.addEventListener(Event.UNLOAD, unloadHandler, false, 0, true);
		}
		
		function addedToStage(e:Event)
		{
			trace("Added to stage");
			this.stage.addEventListener(Event.RESIZE, stageResized, false, 0, true);			
			stageResized(new Event(Event.RESIZE));			
			
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);			
		}
		
		function stageResized(e:Event)
		{			
			stage.align = StageAlign.TOP_LEFT;
			stage.displayState = StageDisplayState.FULL_SCREEN;			
			this.x = 0;
			this.y = 0;
			var wd:int = stage.stageWidth;
			var ht:int = stage.stageHeight;		
			
			//this.x = (800-wd)/2;
			//this.y = (600-ht)/2;
			
			mcArenaMask.width = wd;
			mcArenaMask.height = ht - 300;
			mcArenaMask.y = 150;
			mcArenaMask.x = 0;
			mcArena.x = 0;
			mcArena.y = 150;
			
			mcBackground.width = wd;
			mcBackground.height = ht;
			
			
			arenaWidth = mcArenaMask.width;
			arenaHeight = mcArenaMask.height;						
			
			// fixme: scale the player ui's?
			
			playerArray[0].setUIPosition(100, ht-50, 0);
			playerArray[0].setTankPosition(50, arenaHeight - 50, 45);			
			
			playerArray[1].setUIPosition(295, 50, 180);
			playerArray[1].setTankPosition(50, 50, 135);				
			
			playerArray[2].setUIPosition(wd-290, ht-50, 0);			
			playerArray[2].setTankPosition(arenaWidth-50, arenaHeight - 50, -45);
			
			playerArray[3].setUIPosition(wd-100, 50, 180);			
			playerArray[3].setTankPosition(arenaWidth-50, 50, 225);	

		}
		
		function unloadHandler(e:Event)
		{
			try
			{			
				this.removeEventListener(Event.RESIZE, stageResized);
				this.removeEventListener(Event.UNLOAD, unloadHandler);
				//this.removeEventListener(Event.ENTER_FRAME, frameUpdate);					

				this.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			} catch(ex)
			{
			}
		}
		
		function frameUpdate(e:Event)
		{

		}
		
		function projectileHandleCollisions(p:TankProjectile)
		{
			for(var i:int = 0; i<playerArray.length; i++)
			{
				if(p.owner != playerArray[i] && playerArray[i].playerState == "normal" && p.hitTestObject(playerArray[i].mcTank))
				{
					p.removeSelf();
					p.owner.addToScore(1);
					playerArray[i].tankHit();
					
				
				}
			}
		}
		
	}
}