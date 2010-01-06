package app.core.action.gestures {
	import flash.geom.Point;
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	

	/**
	 *
	 * This class is used to capture mouse movements on the screen
	 * and generate a normalized gesture from them.
	 *
	 * Example usage:
	 * <code>
	 * var capturer:GestureCapturer = new GestureCapturer();
	 * var clip:MovieClip = _root;
	 * clip.onMouseDown = function( capturer.start(); };
	 * clip.onMouseUp = function( 
	 * 		capturer.end(); 
	 * 		trace(capturer.getGesture()); 
	 * };
	 * </code>
	 *
	 * @author Noel Billig
	 * @version 1.0
	 *
	 * This code is distributed under a Creative Commons Attribution 2.5 License 
	 * http://creativecommons.org/licenses/by/2.5/
	 *
	 */
	public class GestureCapturer extends Sprite {
		
		private static var STROKE_POINTS:int = 32;	

		private var gesture:Array;
		private var normalizer:GestureNormalizer;
		
		function GestureCapturer() {
			normalizer = new GestureNormalizer();
		}
		
		/**
		 *
		 * Whenever a capture is started, any previously saved data within the capture
		 * class is lost.
		 *
		 */
		public function startGesture():void {
			gesture = new Array();
			var pnt:Point = new Point(mouseX,mouseY);
			gesture.push( pnt );
			stage.addEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler);
		}
		
		
		public function mouseMoveHandler(event:MouseEvent):void {
			gesture.push( new Point(mouseX,mouseY) );
		}
		
		public function stopGesture():void {
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler);
			gesture = normalizer.normalizeGesture(gesture);
		}
		
		public function getGesture():Array {
			return gesture;
		}
		
		override public function toString():String {
			return "[GestureCapturer]";
		}
		
	}
}