/* 
Created by Laurence Muller
Site: www.multigesture.net
License: GPL

References: Based on the example: http://www.adobe.com/devnet/flash/samples/puzzle_game/
Notes: Puzzle images need to be resized to 800x600 and added manual into the sourcecode.
*/

package app.demo.puzzle {
	
	import flash.display.*;		
	import flash.events.*;
	import flash.net.*;
	import flash.utils.*;
	import flash.geom.*;
	import flash.text.*;
	
	import flash.events.*;
	import app.demo.puzzle.*;
	
	public class PuzzleGame extends MovieClip
	{
		// Class properties
		private var thestage:DisplayObject;
				
		private var puzzlePiecesArr:Array;
		private var puzzlePiecesFound:Array;
		private var topDepth:Number;
		private var totalPuzzlePieces:Number;
		private var correctPuzzlePieces:Number;
		private var puzzleBmp:BitmapData;
		private var intervalID:Number;
		private var threshold:Number;
		private var imagesArr:Array;
		
		private var imageLoader:Loader;
		private var requestURL:URLRequest;	
		
		private var puzzleBoardClip:MovieClip;
		private var holder:MovieClip;

		private var totalPuzzlePieces_x:Number;
		private var totalPuzzlePieces_y:Number;
		
		private var puzzleDifficulty:Number;
		
		public function PuzzleGame(d:DisplayObject) 
		{
			thestage = d;
					
			puzzleDifficulty = 4;
			DifficultySelectionButtons();			
			init(puzzleDifficulty, puzzleDifficulty);			
		}
		
		function DifficultySelectionButtons() {
			
			var easy_mode:Sprite = new Sprite();			
			easy_mode.graphics.lineStyle(2, 0x202020);
			if(puzzleDifficulty == 4)
				easy_mode.graphics.beginFill(0xFFFFFF,0.75);
			else
				easy_mode.graphics.beginFill(0xFFFFFF,0.5);
			easy_mode.graphics.drawRoundRect(512, 700, 80, 40,8);
			easy_mode.graphics.endFill();			
			
			var easy_mode_text:TextField = new TextField();
			easy_mode_text.x = 535;
			easy_mode_text.y = 708;
			easy_mode_text.width = 80;
			easy_mode_text.height = 40;			
			easy_mode_text.selectable = false;
		    easy_mode_text.text = "Easy";			
			easy_mode_text.setTextFormat(new TextFormat("Arial", 14));
			easy_mode.addChild(easy_mode_text);			
			easy_mode.addEventListener(TouchEvent.MOUSE_DOWN, addArguments(multibuttontouch, "easy"));
			easy_mode.addEventListener("mouseDown", addArguments2(mousebuttontouch, "easy"));
			this.addChild(easy_mode);
						
			var medium_mode:Sprite = new Sprite();
			medium_mode.graphics.lineStyle(2, 0x202020);
			if(puzzleDifficulty == 6)
				medium_mode.graphics.beginFill(0xFFFFFF,0.75);
			else
				medium_mode.graphics.beginFill(0xFFFFFF,0.5);
			medium_mode.graphics.drawRoundRect(612, 700, 80, 40,8);
			medium_mode.graphics.endFill();			
			
			var medium_mode_text:TextField = new TextField();
			medium_mode_text.x = 625;
			medium_mode_text.y = 708;			
			medium_mode_text.width = 80;
			medium_mode_text.height = 40;			
			medium_mode_text.selectable = false;
		    medium_mode_text.text = "Medium";			
			medium_mode_text.setTextFormat(new TextFormat("Arial", 14));
			medium_mode.addChild(medium_mode_text);			
			medium_mode.addEventListener(TouchEvent.MOUSE_DOWN, addArguments(multibuttontouch, "medium"));
			medium_mode.addEventListener("mouseDown", addArguments2(mousebuttontouch, "medium"));			
			this.addChild(medium_mode);
			
			var hard_mode:Sprite = new Sprite();
			hard_mode.graphics.lineStyle(2, 0x202020);
			if(puzzleDifficulty == 8)
				hard_mode.graphics.beginFill(0xFFFFFF,0.75);
			else
				hard_mode.graphics.beginFill(0xFFFFFF,0.5);			
			hard_mode.graphics.drawRoundRect(712, 700, 80, 40,8);
			hard_mode.graphics.endFill();			
			
			var hard_mode_text:TextField = new TextField();
			hard_mode_text.x = 735;
			hard_mode_text.y = 708;			
			hard_mode_text.width = 80;
			hard_mode_text.height = 40;			
			hard_mode_text.selectable = false;
		    hard_mode_text.text = "Hard";			
			hard_mode_text.setTextFormat(new TextFormat("Arial", 14));
			hard_mode.addChild(hard_mode_text);			
			hard_mode.addEventListener(TouchEvent.MOUSE_DOWN, addArguments(multibuttontouch, "hard"));
			hard_mode.addEventListener("mouseDown", addArguments2(mousebuttontouch, "hard"));			
			this.addChild(hard_mode);
			
			var insane_mode:Sprite = new Sprite();
			insane_mode.graphics.lineStyle(2, 0x202020);
			if(puzzleDifficulty == 10)
				insane_mode.graphics.beginFill(0xFFFFFF,0.75);
			else
				insane_mode.graphics.beginFill(0xFFFFFF,0.5);				
			insane_mode.graphics.drawRoundRect(812, 700, 80, 40,8);
			insane_mode.graphics.endFill();			
			
			var insane_mode_text:TextField = new TextField();
			insane_mode_text.x = 830;
			insane_mode_text.y = 708;			
			insane_mode_text.width = 80;
			insane_mode_text.height = 40;			
			insane_mode_text.selectable = false;
		    insane_mode_text.text = "Insane";			
			insane_mode_text.setTextFormat(new TextFormat("Arial", 14));
			insane_mode.addChild(insane_mode_text);			
			insane_mode.addEventListener(TouchEvent.MOUSE_DOWN, addArguments(multibuttontouch, "insane"));
			insane_mode.addEventListener("mouseDown", addArguments2(mousebuttontouch, "insane"));			
			this.addChild(insane_mode);
		}
		
		
		function multibuttontouch(evt:TouchEvent, button:String)		
		{						
			while (this.numChildren > 0) 			
				this.removeChildAt(0);				
				
			if(button=="easy")
				puzzleDifficulty = 4;
			else if(button=="medium")
				puzzleDifficulty = 6;
			else if(button=="hard")
				puzzleDifficulty = 8;
			else if(button=="insane")
				puzzleDifficulty = 10;
				
			DifficultySelectionButtons();			
			init(puzzleDifficulty, puzzleDifficulty);			
		}
		
		function mousebuttontouch(evt:Event, button:String)		
		{						
			while (this.numChildren > 0) 			
				this.removeChildAt(0);				
				
			if(button=="easy")
				puzzleDifficulty = 4;
			else if(button=="medium")
				puzzleDifficulty = 6;
			else if(button=="hard")
				puzzleDifficulty = 8;
			else if(button=="insane")
				puzzleDifficulty = 10;
				
			DifficultySelectionButtons();			
			init(puzzleDifficulty, puzzleDifficulty);			
		}
		
		// Wrapper to pass values to an event.
		public function addArguments(method:Function, additionalArguments:String):Function {
			return function(evt:TouchEvent):void {
				method.apply(null, [evt].concat(additionalArguments));
			}
		}

		public function addArguments2(method:Function, additionalArguments:String):Function {
			return function(evt:Event):void {
				method.apply(null, [evt].concat(additionalArguments));
			}
		}
		
		public function init(piecesx:Number, piecesy:Number)
		{
			puzzleBoardClip = new MovieClip();
			this.addChild(puzzleBoardClip);
	
			totalPuzzlePieces_x = piecesx;
			totalPuzzlePieces_y = piecesy;
			totalPuzzlePieces = totalPuzzlePieces_x * totalPuzzlePieces_y;
				
			imagesArr = new Array("1.jpg", "2.jpg", "3.jpg", "4.jpg");
	
			puzzlePiecesArr = new Array();
			puzzlePiecesFound = new Array();
			correctPuzzlePieces = 0;
			threshold = 0xFFFF;
			
			/* Create the image Loader */
			imageLoader = new Loader();
			imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadImg);
			
			/* Create the URL Request */
			var index:Number = Math.floor(Math.random() * imagesArr.length);
			requestURL = new URLRequest("www/img/puzzle/" + imagesArr[index]);
			
			// Load the image
			imageLoader.load(requestURL);
			
			// Setup a holdery mc to hold the puzzle pieces
			holder = new MovieClip();
			this.addChild(holder);
		}
				
		function onLoadImg(evt:Event):void
		{
			// Determine the width and height of each puzzle piece.
			// Each puzzle consists of 4 columns and 2 rows.
			var widthPuzzlePiece:Number = imageLoader.width / totalPuzzlePieces_x;
			var heightPuzzlePiece:Number = imageLoader.height / totalPuzzlePieces_y;
			
			// Draw the image from the movie clip into a BitmapData Obj.
			puzzleBmp = new BitmapData(imageLoader.width, imageLoader.height);
			puzzleBmp.draw(imageLoader, new Matrix());
			
			var puzzlePieceBmp:BitmapData;
			var x:Number = 0;
			var y:Number = 0;
			
			// Loop 8 times to make each piece
			for (var i:Number = 0; i < totalPuzzlePieces; i++)
			{
				puzzlePieceBmp = new BitmapData(widthPuzzlePiece, heightPuzzlePiece);
				puzzlePieceBmp.copyPixels(puzzleBmp, new Rectangle(x,y,widthPuzzlePiece,heightPuzzlePiece), new Point(0,0));
				
				makePuzzlePiece(puzzlePieceBmp, i);
				
				x += widthPuzzlePiece;
				if(x >= puzzleBmp.width)
				{
					x = 0;
					y += heightPuzzlePiece;
				}
			}
			
			makePuzzleBoard(puzzleBmp.width, puzzleBmp.height);
			
			arrangePuzzlePieces();
		}
		
		function makePuzzlePiece(puzzlePiece:BitmapData, index:int)
		{	
			var widthPuzzlePiece:Number = imageLoader.width / totalPuzzlePieces_x;
			var heightPuzzlePiece:Number = imageLoader.height / totalPuzzlePieces_y;
			
			var puzzlePieceClip:Bitmap = new Bitmap(puzzlePiece);
			puzzlePieceClip.addEventListener(TouchEvent.MOUSE_UP, multiMove);			
				
			var tmp2:PuzzleGameTile = new PuzzleGameTile();		
			tmp2.name = String(index) 	// Added for Strict Mode		
			tmp2.addChild(puzzlePieceClip);
						
			holder.addChild(tmp2);		
			holder.addEventListener("mouseDown", pieceMove);
			holder.addEventListener("mouseUp", pieceMove);	
									
			puzzlePiecesArr.push(tmp2);
			
			// This is used to check if the same piece has been placed
			puzzlePiecesFound.push(tmp2.name);		
		}

		function multiMove(evt:TouchEvent)
		{			
			trace("Eventype: " + evt.type);
			if(evt.type=="flash.events.TouchEvent.MOUSE_UP")
			{				
				var puzzlePieceIndex:Number = evt.target.parent.name;
				var puzzleBoardSpaceClip:MovieClip;	
				puzzleBoardSpaceClip = puzzleBoardClip.getChildByName(puzzlePieceIndex);
				
				var coordinate:Point = new Point(puzzleBoardSpaceClip.x, puzzleBoardSpaceClip.y);
				var coordinateGlobal:Point = new Point();
			
				coordinateGlobal = puzzleBoardClip.localToGlobal(coordinate);
				
				if(Math.abs(evt.target.parent.x-coordinateGlobal.x) < 50 && Math.abs(evt.target.parent.y-coordinateGlobal.y) < 50 )
				{
					//trace("tolerance ok");
					evt.target.parent.x = coordinateGlobal.x;
					evt.target.parent.y = coordinateGlobal.y;
							
					if(puzzlePiecesFound.length != 0)
					{
						for(var i:int = 0; i < puzzlePiecesFound.length; i++)
						{
							if(puzzlePiecesFound[i] == puzzlePieceIndex)
							{
								puzzlePiecesFound[i] = "Correct";
								correctPuzzlePieces++;
							}
						}
					}
					
					if(correctPuzzlePieces == totalPuzzlePieces)
					{
						puzzleSolved();
					}
				}
				else
				{
						//trace("tolerance not ok");
				}
			}
		}

		function pieceMove(evt:Event):void
		{	
			if(evt.type == "mouseDown"){
				evt.target.startDrag();
			} else if(evt.type == "mouseUp"){
				
				evt.target.stopDrag();
				var puzzlePieceIndex:Number = evt.target.name;
		
				// ADDED VV 4.3. Check if droppped inside of the grid
				if(evt.target.dropTarget){
					var puzzleBoardSpaceIndex:Number = evt.target.dropTarget.name;			
				}
				
				if(puzzlePieceIndex == puzzleBoardSpaceIndex)
				{			
					var coordinate:Point = new Point(evt.target.dropTarget.x, evt.target.dropTarget.y);
					var coordinateGlobal:Point = new Point();
			
					coordinateGlobal = puzzleBoardClip.localToGlobal(coordinate);
			
					evt.target.x = coordinateGlobal.x;
					evt.target.y = coordinateGlobal.y;
					
					if(puzzlePiecesFound.length != 0)
					{
						for(var i:int = 0;i < puzzlePiecesFound.length; i++)
						{
							if(puzzlePiecesFound[i] == puzzlePieceIndex)
							{
								puzzlePiecesFound[i] = "Correct";
								correctPuzzlePieces++;
							}
						}
					}
					
					if(correctPuzzlePieces == totalPuzzlePieces)
					{
						puzzleSolved();
					}
				}
			}
		}
		
		function arrangePuzzlePieces():void
		{
			var widthPuzzlePiece:Number = puzzlePiecesArr[0].width;
			var heightPuzzlePiece:Number = puzzlePiecesArr[0].height;
			
			for(var i:Number = 0; i < totalPuzzlePieces; i++)
			{
				puzzlePiecesArr[i].x = Math.floor(Math.random() * 1024)-(widthPuzzlePiece/2);
				puzzlePiecesArr[i].y = Math.floor(Math.random() * 768)-(heightPuzzlePiece/2);
			}
		}
				
		function makePuzzleBoard(width:Number, height:Number):void
		{
			var widthPuzzlePiece:Number = width / totalPuzzlePieces_x;
			var heightPuzzlePiece:Number = height / totalPuzzlePieces_y;
			
			var puzzleBoardSpaceClip:MovieClip;
			var x:Number = 0;
			var y:Number = 0;
			
			for(var i:Number = 0; i < totalPuzzlePieces; i++)
			{
				puzzleBoardSpaceClip = new MovieClip();
				puzzleBoardSpaceClip.graphics.lineStyle(0);
				puzzleBoardSpaceClip.graphics.beginFill(0xFFFFFF,0.2);
				puzzleBoardSpaceClip.graphics.lineTo(widthPuzzlePiece,0);
				puzzleBoardSpaceClip.graphics.lineTo(widthPuzzlePiece,heightPuzzlePiece);
				puzzleBoardSpaceClip.graphics.lineTo(0,heightPuzzlePiece);
				puzzleBoardSpaceClip.graphics.lineTo(0,0);
				puzzleBoardSpaceClip.graphics.endFill();
				puzzleBoardSpaceClip.x = x;
				puzzleBoardSpaceClip.y = y;
				x += widthPuzzlePiece;
				if(x >= width)
				{
					x = 0;
					y += heightPuzzlePiece;
				}
				puzzleBoardSpaceClip.name = String(i);	// Added for Strict Mode
				
				puzzleBoardClip.addChild(puzzleBoardSpaceClip);
			}
			
			puzzleBoardClip.x = 110;
			puzzleBoardClip.y = 50;
		}
				
		function puzzleSolved():void
		{
			holder.visible = false;
			var tmp:Bitmap = new Bitmap(puzzleBmp);
			puzzleBoardClip.addChild(tmp);
			
			var timer:Timer = new Timer(50);
			timer.start();
			timer.addEventListener("timer", puzTrash);
		}
				
		function puzTrash(evt:Event):void
		{
			if(threshold > 0xFFFFFF)
			{
				threshold = 0xFFFFFF;
				evt.target.stop();
				init(puzzleDifficulty, puzzleDifficulty);			
			}
			puzzleBmp.threshold(puzzleBmp, new Rectangle(0,0, puzzleBmp.width, puzzleBmp.height), new Point(0,0), "<=", 0xFF000000 | threshold);
			threshold *= 1.2;
		}

	}
}