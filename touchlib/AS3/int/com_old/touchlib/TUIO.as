package com.touchlib {		
	
	import app.core.element.Wrapper;	
	import flash.display.Stage;
	import flash.display.Sprite;
	import flash.display.DisplayObjectContainer;
	import flash.events.DataEvent;
	import flash.events.Event;	
	import flash.events.MouseEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.geom.Point;	
	import flash.net.NetConnection;
	import flash.net.Responder;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.XMLSocket;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;	
	import caurina.transitions.Tweener;

	public class TUIO
	{		
		static var FLOSCSocket:XMLSocket;		
		static var FLOSCSocketHost:String;			
		static var FLOSCSocketPort:Number;			
		public static var thestage:Stage;
		public static var objectArray:Array;
		static var idArray:Array; 				
		static var debugText:TextField;		
		static var xmlPlaybackURL:String; 
		static var xmlPlaybackLoader:URLLoader;
		static var playbackXML:XML;
		static var recordedXML:XML;		
		static var bInitialized:Boolean;
		static var bRecording:Boolean;		
		static var bPlayback:Boolean;	
		static var bDebug:Boolean;			
		static var myService:NetConnection;
    	static var responder:Responder;
    	
	public static function init (s:DisplayObjectContainer, host:String, port:Number, debugXMLFile:String, dbug:Boolean = true):void
	{
			if(bInitialized){return;}	
			
			thestage = s.stage;
			thestage.align = "TL";
			thestage.scaleMode = "noScale";				
			FLOSCSocketHost=host;			
			FLOSCSocketPort=port;					       
			myService = new NetConnection();
			myService.connect("http://nui.mine.nu/amfphp/gateway.php");
			xmlPlaybackURL = "http://nui.mine.nu/amfphp/services/test.xml";			
			bDebug = dbug;				
			bInitialized = true;
			bRecording = false;		
			bPlayback = false;									
			objectArray = new Array();
			idArray = new Array();
			
			try
			{
				FLOSCSocket = new XMLSocket();	
				FLOSCSocket.addEventListener(Event.CLOSE, closeHandler);
				FLOSCSocket.addEventListener(Event.CONNECT, connectHandler);
				FLOSCSocket.addEventListener(DataEvent.DATA, dataHandler);
				FLOSCSocket.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				FLOSCSocket.addEventListener(ProgressEvent.PROGRESS, progressHandler);
				FLOSCSocket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);	
				FLOSCSocket.connect(host, port);				
			} 
			catch(e){}			
			if(bDebug)
			{
				activateDebugMode();				
			}  
			else 
			{		
				recordedXML = new XML();	
				recordedXML = <OSCPackets></OSCPackets>;
				bRecording = false;			
			}			
		}
		
		public static function processMessage(msg:XML)
		{
			var fseq:String;
			var node:XML;
			for each(node in msg.MESSAGE)
			{
				if(node.ARGUMENT[0] && node.ARGUMENT[0].@VALUE == "fseq")
					fseq = node.ARGUMENT[1].@VALUE;					
			}
			
			for each(node in msg.MESSAGE)
			{
				if(node.ARGUMENT[0] && node.ARGUMENT[0].@VALUE == "alive")
				{
					for each (var obj1:TUIOObject in objectArray)
					{
						obj1.isAlive = false;
					}
					
					var newIdArray:Array = new Array();					
					for each(var aliveItem:XML in node.ARGUMENT.(@VALUE != "alive"))
					{
						if(getObjectById(aliveItem.@VALUE))
							getObjectById(aliveItem.@VALUE).isAlive = true;

					}   
					idArray = newIdArray;
				}
			}				
							
			for each(node in msg.MESSAGE)
			{
				if(node.ARGUMENT[0])
				{
					var type:String;
										
					if(node.@NAME == "/tuio/2Dobj")
					{
						/*
						
						// fixme: ensure everything is working properly here.
						
						type = node.ARGUMENT[0].@VALUE;				
						if(type == "set")
						{
							var sID = node.ARGUMENT[1].@VALUE;
							var id = node.ARGUMENT[2].@VALUE;
							var x = Number(node.ARGUMENT[3].@VALUE) * thestage.stageWidth;
							var y = Number(node.ARGUMENT[4].@VALUE) * thestage.stageHeight;
							var a = Number(node.ARGUMENT[5].@VALUE);
							var X = Number(node.ARGUMENT[6].@VALUE);
							var Y = Number(node.ARGUMENT[7].@VALUE);
							var A = Number(node.ARGUMENT[8].@VALUE);
							var m = node.ARGUMENT[9].@VALUE;
							var r = node.ARGUMENT[10].@VALUE;
							
							// send object update event..
							
							var objArray:Array = thestage.getObjectsUnderPoint(new Point(x, y));
							var stagePoint:Point = new Point(x,y);					
							var displayObjArray:Array = thestage.getObjectsUnderPoint(stagePoint);							
							var dobj = null;
							
//							if(displayObjArray.length > 0)								
//								dobj = displayObjArray[displayObjArray.length-1];										

							
						
							var tuioobj = getObjectById(id);
							if(tuioobj == null)
							{
								tuioobj = new TUIOObject("2Dobj", id, x, y, X, Y, sID, a, 0, 0, dobj);
								thestage.addChild(tuioobj.spr);
								
								objectArray.push(tuioobj);
								tuioobj.notifyCreated();								
							} else {
								tuioobj.spr.x = x;
								tuioobj.spr.y = y;								
								tuioobj.x = x;
								tuioobj.y = y;
								tuioobj.oldX = tuioobj.x;
								tuioobj.oldY = tuioobj.y;
								tuioobj.dX = X;
								tuioobj.dY = Y;
								
								tuioobj.setObjOver(dobj);
								tuioobj.notifyMoved();								
							}
							
							try
							{
								if(tuioobj.obj && tuioobj.obj.parent)
								{							
									
									var localPoint:Point = tuioobj.obj.parent.globalToLocal(stagePoint);							
									tuioobj.obj.dispatchEvent(new TouchEvent(TouchEvent.MOUSE_MOVE, true, false, x, y, localPoint.x, localPoint.y, tuioobj.oldX, tuioobj.oldY, tuioobj.obj, false,false,false, true, m, "2Dobj", id, sID, a));
								}
							} catch (e)
							{
							}

		
						}
						*/
						
					} 
					else if(node.@NAME == "/tuio/2Dcur")
					{
						type = node.ARGUMENT[0].@VALUE;				
						if(type == "set")
						{
							var id:int;
							
							var x:Number,
								y:Number,
								X:Number,
								Y:Number,
								m:Number,
								wd:Number = 0, 
								ht:Number = 0;
							try 
							{
								id = node.ARGUMENT[1].@VALUE;
								x = Number(node.ARGUMENT[2].@VALUE) * thestage.stageWidth;
								y = Number(node.ARGUMENT[3].@VALUE) *  thestage.stageHeight;
								X = Number(node.ARGUMENT[4].@VALUE);
								Y = Number(node.ARGUMENT[5].@VALUE);
								m = Number(node.ARGUMENT[6].@VALUE);
								
								if(node.ARGUMENT[7])
									wd = Number(node.ARGUMENT[7].@VALUE) * thestage.stageWidth;							
								
								if(node.ARGUMENT[8])
									ht = Number(node.ARGUMENT[8].@VALUE) * thestage.stageHeight;
							} catch (e)
							{
								trace("Error parsing");
							}
							
							//trace("Blob : ("+id + ")" + x + " " + y + " " + wd + " " + ht);
							
							var stagePoint:Point = new Point(x,y);					
							var displayObjArray:Array = thestage.getObjectsUnderPoint(stagePoint);
							var dobj = null;
							
							if(displayObjArray.length > 0)								
							dobj = displayObjArray[displayObjArray.length-1];	
																				
							var tuioobj = getObjectById(id);
							if(tuioobj == null)
							{
								tuioobj = new TUIOObject("2Dcur", id, x, y, X, Y, -1, 0, wd, ht, dobj);
								thestage.addChild(tuioobj.spr);								
								objectArray.push(tuioobj);
								tuioobj.notifyCreated();
							} else {
								tuioobj.spr.x = x;
								tuioobj.spr.y = y;
								tuioobj.x = x;
								tuioobj.y = y;
								tuioobj.oldX = tuioobj.x;
								tuioobj.oldY = tuioobj.y;
								tuioobj.width = wd;
								tuioobj.height = ht;
								tuioobj.area = wd * ht;								
								tuioobj.dX = X;
								tuioobj.dY = Y;
								tuioobj.setObjOver(dobj);
								tuioobj.notifyMoved();
							}  

							try
							{
								if(tuioobj.obj && tuioobj.obj.parent)
								{							
									var localPoint:Point = tuioobj.obj.parent.globalToLocal(stagePoint);							
									tuioobj.obj.dispatchEvent(new TouchEvent(TouchEvent.MOUSE_MOVE, true, false, x, y, localPoint.x, localPoint.y, tuioobj.oldX, tuioobj.oldY, tuioobj.obj, false,false,false, true, m, "2Dcur", id, 0, 0));
								}
							} catch (e)
							{
								trace("(" + e + ")Dispatch event failed " + tuioobj.ID);
							}	
						}
					}
				}
			}
			if(bDebug)
			{
				debugText.text = "";
				debugText.y = -2000;
				debugText.x = -2000;		
			}	
			for (var i=0; i<objectArray.length; i++ )
			{	
				if(objectArray[i].isAlive == false)
				{
					objectArray[i].kill();
					thestage.removeChild(objectArray[i].spr);
					objectArray.splice(i, 1);
					i--;

				} else {
					if(bDebug)
					{	var tmp = (int(objectArray[i].area)/-100000);
						//trace('area: '+tmp);
						debugText.appendText("  " + (i + 1) +" - " +objectArray[i].ID + "  X:" + int(objectArray[i].x) + "  Y:" + int(objectArray[i].y) +
						"  A:" + int(tmp) + "  \n");						
						debugText.x = thestage.stageWidth-200;
						debugText.y = 25;	
					}
					}
			}
		}
		
		public static function addObjectListener(id:Number, reciever:Object)
		{
			var tmpObj:TUIOObject = getObjectById(id);			
			if(tmpObj)
			{
				tmpObj.addListener(reciever);				
			}
		}
		
		public static function getObjectById(id:Number): TUIOObject
		{
			if(id == 0)
			{
				return new TUIOObject("mouse", 0, thestage.mouseX, thestage.mouseY, 0, 0, 0, 0, 10, 10, null);
			}
			for(var i=0; i<objectArray.length; i++)
			{
				if(objectArray[i].ID == id)
				{
					return objectArray[i];
				}
			}
			return null;
		}
		
        private static function activateDebugMode():void 
        {
  				var format:TextFormat = new TextFormat("Verdana", 10, 0xFFFFFF);
				debugText = new TextField();       
				debugText.defaultTextFormat = format;
				debugText.autoSize = TextFieldAutoSize.LEFT;
				debugText.background = true;	
				debugText.backgroundColor = 0x000000;	
				debugText.border = true;	
				debugText.borderColor = 0x333333;	
				thestage.addChild( debugText );						
				thestage.setChildIndex(debugText, thestage.numChildren-1);	
		
				recordedXML = <OSCPackets></OSCPackets>;	
				
				var debugBtn = new Sprite();						
				debugBtn.graphics.beginFill(0xFFFFFF,1);
				//debugBtn.graphics.drawRect(thestage.stageWidth-210, 0, 200, 50);	
				debugBtn.graphics.beginFill(0xFFFFFF, 0.65);	
	   			debugBtn.graphics.drawRoundRect(-25, -25, 50,50,10);		
	  		 	debugBtn.graphics.endFill();	
	 		  	debugBtn.graphics.lineStyle( 4, 0x000000 );	   	
				debugBtn.graphics.moveTo( 0, -12 );
				debugBtn.graphics.lineTo( 0, 12 );
				debugBtn.graphics.moveTo( -12, 0 );
				debugBtn.graphics.lineTo( 12, 0 );	
				debugBtn.x=50; 
				debugBtn.y=50;  
		
				debugBtn.addEventListener(MouseEvent.CLICK, toggleDebug);
				var debugBtnW:Wrapper = new Wrapper(debugBtn);			
				debugBtnW.alpha = 0.85; 			 
				thestage.addChildAt(debugBtnW, thestage.numChildren-1);								
				
				var recordBtn = new Sprite();						
				recordBtn.graphics.beginFill(0xFF0000);
				recordBtn.graphics.drawRect(10, 70, 50, 50);	
				recordBtn.addEventListener(MouseEvent.CLICK, toggleRecord);
				var recordBtnW:Wrapper = new Wrapper(recordBtn);			
				recordBtnW.alpha = 0.25; //recordBtnW.y = 120;				
				//thestage.addChildAt(recordBtnW, thestage.numChildren-1);	
				
				var playbackBtn = new Sprite();						
				playbackBtn.graphics.beginFill(0x00FF00);
				playbackBtn.graphics.drawRect(10, 120, 50, 50);	
				playbackBtn.addEventListener(MouseEvent.CLICK, togglePlayback);
				var playbackBtnW:Wrapper = new Wrapper(playbackBtn);			
				playbackBtnW.alpha = 0.25; //playbackBtnW.y = 70;				
				//thestage.addChildAt(playbackBtnW, thestage.numChildren-1);
        }	
        
        private static function xmlPlaybackLoaded(evt:Event) 
        {
			trace("Playing from XML file...");
			playbackXML = new XML(xmlPlaybackLoader.data);			
		}
		
		private static function frameUpdate(evt:Event)
		{
			if(playbackXML && playbackXML.OSCPACKET && playbackXML.OSCPACKET[0])
			{
				processMessage(playbackXML.OSCPACKET[0]);
				delete playbackXML.OSCPACKET[0];
			}
		}		
		
		private static function toggleDebug(e:Event)
		{ 
			if(!bDebug){
			bDebug=true;		
			FLOSCSocket.connect(FLOSCSocketHost, FLOSCSocketPort);
			e.target.parent.alpha=0.85;
			}
			else{
			bDebug=false;
			FLOSCSocket.connect(FLOSCSocketHost, FLOSCSocketPort);
			e.target.parent.alpha=0.5;	
			}
		}
		public static function startSocket()
		{ 	
			FLOSCSocket.connect(FLOSCSocketHost, FLOSCSocketPort);
		}
		public static function stopSocket()
		{ 	
			FLOSCSocket.close();
		}
		private static function toggleRecord(e:Event)
		{ 	
			var responder = new Responder(saveSession_Result, onFault);
			
			if(!bRecording){
			bRecording = true;
			e.target.parent.alpha=1.0;			
			trace(e.target.parent);
			trace('-----------------------------------------------------------------------------------------------------');		
			trace('-------------------------------------- Record ON ----------------------------------------------------');
			trace('-----------------------------------------------------------------------------------------------------');	
			myService.call("touchlib.clearSession", responder);
			}
			else{
			bRecording = false;
			e.target.parent.alpha=0.25;
			trace('-----------------------------------------------------------------------------------------------------');		
			trace('-------------------------------------- Record OFF ---------------------------------------------------');
			trace('-----------------------------------------------------------------------------------------------------');	
			myService.call("touchlib.saveSession", responder, recordedXML.toXMLString());
			//trace(recordedXML.toString());		
			trace('-------------------------------------- Recording END ------------------------------------------------');
			}
		}
			
		private static function saveSession_Result(result)
		{	
		debugText.x = debugText.y = 5;
		debugText.text = result;
		trace(result);
		}
			
		private static function togglePlayback(e:Event)
		{ 	
			if(xmlPlaybackURL != "")
				 {	
				 	Tweener.addTween(e.target.parent, {alpha:1, time:0.45, transition:"easeinoutquad"});	
				 	Tweener.addTween(e.target.parent, {alpha:0.25, delay:0.45,time:0.45, transition:"easeinoutquad"});	
					xmlPlaybackLoader = new URLLoader();
					xmlPlaybackLoader.addEventListener("complete", xmlPlaybackLoaded);
					xmlPlaybackLoader.load(new URLRequest(xmlPlaybackURL));			
					thestage.addEventListener(Event.ENTER_FRAME, frameUpdate);
				 }
		}
		
        private static function dataHandler(event:DataEvent):void 
        {           			
			if(bRecording)
			recordedXML.appendChild( XML(event.data) );			
			processMessage(XML(event.data));
        }     			
        private static function onFault(e:Event )
		{
			//trace("There was a problem: " + e.description);
		}
     	private static function connectHandler(event:Event):void 
     	{
            //trace("connectHandler: " + event);
        }       
        private static function ioErrorHandler(event:IOErrorEvent):void 
        {
            //trace("ioErrorHandler: " + event);
        }
        private static function progressHandler(event:ProgressEvent):void 
        {
            //trace("Debug XML Loading..." + event.bytesLoaded + " out of: " + event.bytesTotal);
        }
        private static function closeHandler(event:Event):void 
        {
            //trace("closeHandler: " + event);
        }
        private static function securityErrorHandler(event:SecurityErrorEvent):void 
        {
            //trace("securityErrorHandler: " + event);
        }  
    }
}