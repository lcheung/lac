package app.core.object{ 			
public class DesktopObject extends RotatableScalable {	 		
public function DesktopObject(host:String, port:Number, fitScreen:Boolean):void
			{
				doubleTapEnabled = false;	
				
				remoteScreen = new FVNC()
				remoteScreen.host = host;
				remoteScreen.port = port;
				remoteScreen.fitToScreen = fitScreen;				
				this.addChild(remoteScreen);
			
				try
				{
					remoteScreen.connect();		   	
				}
				catch ( e:Error )
				{
					trace(e);
				}
				
			}		
			
		public override function doubleTap()
		{
	   	if(!doubleTapEnabled){   	
 	   //this.noMove = false; 	
	   //this.noRotate = false;
	   //this.noScale = false;	 
	   //remoteScreen.togglefullScreen(this);
	   	doubleTapEnabled = true;
	   	}
	   	else{		
	    //this.noMove = true;  
	   	//this.noRotate = true;
	    //this.noScale = true;	
	   	 doubleTapEnabled = false;	   	
		//remoteScreen.togglefullScreen(this);
	   	 }
	   	}
	 public var remoteScreen:FVNC;		
	 public var doubleTapEnabled: Boolean;
	}   
	import flash.display.Sprite;
    import fvnc.FVNC;
	import fvnc.events.FVNCEvent;
	import fvnc.events.ConnectEvent;		
	import caurina.transitions.Tweener;		
	import app.core.action.RotatableScalable;	
}