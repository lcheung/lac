package app.demo.pong
{	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;

	public class Score extends Sprite
	{
		private var score:TextField;	
		private var scoreP1:TextField;
		private var scoreP2:TextField;
		private var format:TextFormat;
	
		function Score()
		{

			format = new TextFormat("_sans", 25, 0xFFFFFF);
			
			scoreP1 = new TextField();
			scoreP1.x = 40;
			scoreP1.y = 10;
			addChild(scoreP1);
			
			scoreP2 = new TextField();
			scoreP2.x = 100;
			scoreP2.y = 10;
			addChild(scoreP2);			
		
			scoreP1.defaultTextFormat = format;
			scoreP2.defaultTextFormat = format;
			
			setScore(0, 0);
		}
		
		function setScore(score1:Number, score2:Number):void
		{
			this.scoreP1.text = score1;
			this.scoreP2.text = score2;			
		}
		
		function getScores():Array
		{
			//var scores:Array = this.score.text.split("   ");			
			var scores:Array = [];
			scores.push(this.scoreP1.text);
			scores.push(this.scoreP2.text);
			for (var i:String in scores)
			{
				scores[i] = Number(scores[i]);
			}
			
			return scores;
		}
	}
}