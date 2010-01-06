package app.core.action.gestures {

	import flash.geom.Point;

	/**
	 *
	 * This class is used to take a gesture and normalize it so it can be compared
	 * and matched to other gestures. A gesture is simply a collection of Points
	 * which define the path of the stoke (e.g., a collection of the x-y positions
	 * of a mouse during a drag operation). Normalizition simply takes these points 
	 * and resamples them in such a way to make comparisons easier.
	 *
	 * Example usage:
	 * <code>
	 * var gesture:Array = [new Point(0,0),new Point(10,10),new Point(10,0)];
	 * var normalizer:GestureNormalizer = new GestureNormalizer();
	 * var normalizedGesture:Array = normalizer.normalize(gesture);
	 * </code>
	 *
	 * @author Noel Billig
	 * @version 1.0
	 * 
	 *
	 * This code is distributed under a Creative Commons Attribution 2.5 License 
	 * http://creativecommons.org/licenses/by/2.5/
	 *
	 * The code used in this class is based on an excellent tutorial 
	 * provided in a gamedev.net article by Oleg Dopertchouk.
	 * Article: http://www.gamedev.net/reference/articles/article2039.asp
	 * By: Oleg Dopertchouk (http://www.yeoldestuff.com)
	 *
	 */
	public class GestureNormalizer {
		
		
		private static const DEFAULT_STROKE_POINTS:int = 32;
		
		
		function GestureNormalizer() {
		}
		
		
		/**
		 *
		 * Takes a gesture defined by a series of points and returns a normalized version of it
		 * 
		 * @param strokePoints (optional) - The number of points to redefine the gesture in. It defaults to 32.
		 *
		 */
		public function normalizeGesture(gesture:Array,strokePoints:Number=GestureNormalizer.DEFAULT_STROKE_POINTS):Array {
			var normalizedGesture:Array = gesture.concat();
			normalizePoints(normalizedGesture);
			normalizedGesture = setEvenSpacing(normalizedGesture,strokePoints);
			normalizeCenter(normalizedGesture);
			return normalizedGesture;
		}
		
		
		/**
		 *
		 * We want to scale the gesture to a uniform size so we can
		 * compare all gestures regardless to how large a person writes
		 *
		 */
		private function normalizePoints(points:Array):void {
			
			//Find the mins and maxes
			var minX:Number = points[0].x;
			var minY:Number = points[0].y;
			var maxX:Number = points[0].x;
			var maxY:Number = points[0].y;
			for (var i:uint=1; i < points.length; i++) {
				if (points[i].x > maxX) maxX = points[i].x;
				if (points[i].y > maxY) maxY = points[i].y;
				if (points[i].x < minX) minX = points[i].x;
				if (points[i].y < minY) minY = points[i].y;
			}
			
			//Calculate dimensions 
			var width:Number = maxX - minX;
			var height:Number = maxY - minY;
			var scale:Number = (width > height) ? width:height;
			if ( scale <= 0 ) return; //Empty or a single point stroke!
			scale = 1/scale;
			
			//Do the actual scaling
			for (var i:uint=0; i < points.length; i++) {
				points[i].x *= scale;
				points[i].y *= scale;
			}
		}
		
		
		/**
		 *
		 * Calculate the distance between every point and tally them up to
		 * figure out the total size of the stroke
		 *
		 */	 
		private function getStrokeLength(points:Array):Number {
			var length:Number = 0;
			for (var i:Number=1; i < points.length; i++) {
				length += Point.distance(points[i-1],points[i]);
			}
			return length;
		}

		
		/**
		 *
		 * Slice up the stroke into the specified number of points and ensure that
		 * all of the points are an equal distance from each other.
		 *
		 * @param points - The points which make up the gesture
		 * @param strokePoints - Number of points to divide the gesture into
		 *
		 */
		private function setEvenSpacing(points:Array,strokePoints:Number):Array {
			
			var newPnts:Array = new Array();
			var segmentLength:Number = getStrokeLength(points)/(strokePoints-1);

			newPnts.push(points[0]);
			
			var startPt:Point = points[0];
			var endPt:Point = points[0];
		
			var endOldDist:Number=0;
			var startOldDist:Number=0;
			var newDist:Number=0;
			var curSegLen:Number=0;
			
			var count:Number = 1;
			
			//Start a loop
			var tooLong:Number = 2000; //in place to prevent infinite loop erros during testing
			var tooLongCounter:Number=0; //in place to prevent infinite loop erros during testing
			while (tooLongCounter < tooLong) {
				tooLongCounter++;
				var excess:Number = endOldDist - newDist;
				if (excess >= segmentLength) {
					newDist+=segmentLength;
					var ratio:Number = (newDist-startOldDist)/curSegLen;
					var newPoint:Point = new Point(
							(endPt.x - startPt.x) * ratio + startPt.x,
							(endPt.y - startPt.y) * ratio + startPt.y
							);
					newPnts.push(newPoint);
				} else {
					if (count == points.length) break;
					startPt = endPt;
					endPt = points[count];
					count++;
					var dif:Point = endPt.subtract(startPt);
					
					//Start accumulated distance (along the old stroke)
					//at the beginning of the segment
					startOldDist = endOldDist;
					//Add the length of the current segment to the
					//total accumulated length
					curSegLen = dif.length;
					endOldDist+=curSegLen;

				}
				
			}
			
			//Due to floating point errors we may miss the last
			//point of the stroke
			if (newPnts.length < strokePoints ) {
				newPnts.push(endPt);
			}
			
			return newPnts;
		}
		
		
		/**
		 *
		 * Center the gesture on the origin (0,0). We want the center of the averaged center
		 * of the points, NOT the center of the bounding box.
		 *
		 */
		private function normalizeCenter(points:Array):void {
			
			var centerX:Number = 0;
			var centerY:Number = 0;
			
			//Calculate the centroid of the gesture
			for (var i:Number=0; i < points.length; i++) {
				centerX += points[i].x;
				centerY += points[i].y;
			}
			
			//Calculate centroid
			centerX /= points.length;
			centerY /= points.length;
			
			//To move the gesture into the origin, subtract centroid coordinates
			//from point coordinates
			for (var i:Number=0; i < points.length; i++) {
				points[i].x -= centerX;
				points[i].y -= centerY;
			}
			
		}
		
		
		function toString():String {
			return "[GestureNormalizer]";
		}

		
	}
	
}