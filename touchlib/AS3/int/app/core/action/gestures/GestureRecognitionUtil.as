package app.core.action.gestures {
		
	/**
	 *
	 * This class is used to compare gestures to each other. The closeness of the
	 * gestures is rated with a score from 0 to 1. A score of 0 indicates that
	 * the gestures are unmatchable, while a score of 1 indicates and exacting match.
	 *
	 * @author Noel Billig
	 * @version 1.0
	 * 
	 *
	 * This code is distributed under a Creative Commons Attribution 2.5 License 
	 * http://creativecommons.org/licenses/by/2.5/
	 *
	 * The code used in this class is based on and excellent tutorial 
	 * provided in a gamedev.net article by Oleg Dopertchouk.
	 * Article: http://www.gamedev.net/reference/articles/article2039.asp
	 * By: Oleg Dopertchouk (http://www.yeoldestuff.com)
	 *
	 */
	public class GestureRecognitionUtil {
		
		/**
		 *
		 * Generates the dot productts of each Point in the gestures and tallys them together.
		 * The dot product let's us see how closely each vector points in the same direction, a 1
		 * indicating that they point in the same direction and low and geative numbers indicate
		 * opposite directions.
		 *
		 */
		static function gestureDotProduct(gesture1:Array,gesture2:Array):Number {
			if (gesture1.length != gesture2.length) {
				//throw new Error("Gesture lengths must be the same: "+gesture1.length+"!="+gesture2.length );
			}
			var dotProduct:Number = 0;
			for (var i:Number=0; i < gesture1.length; i++) {
				dotProduct += gesture1[i].x * gesture2[i].x + gesture1[i].y * gesture2[i].y;
			}
			return dotProduct;
		}
		
		
		/**
		 *
		 * We use the dot product of the individual vectors to calculate a score
		 *
		 */
		static function getScore(gesture1:Array, gesture2:Array):Number {
			var score:Number = gestureDotProduct(gesture1,gesture2);
			if (score <= 0) return 0;
			//at this point our gesture-vectors are not quite normalizeD
			//yet - their dot product with themselves is not 1.
			
			//we normalize the score itself
			
			//this is basically a version of a famous formula for a cosine of the 
			//angle between 2 vectors:
			//cos a = (u.v) / (sqrt(u.u) * sqrt(v.v)) = (u.v) / sqrt((u.u) * (v.v))
			score /= Math.sqrt( gestureDotProduct(gesture1, gesture1) *
					gestureDotProduct(gesture2, gesture2));
			
			return score;
		}

	}
	
}