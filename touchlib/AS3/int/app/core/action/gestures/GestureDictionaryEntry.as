package app.core.action.gestures {
	/**
	 *
	 * A data class used to pair a gesture with an id
	 *
	 * @author Noel Billig (http://www.dncompute.com)
	 * @version 1.0
	 *
	 * This code is distributed under a Creative Commons Attribution 2.5 License 
	 * http://creativecommons.org/licenses/by/2.5/
	 *
	 */
	public class GestureDictionaryEntry {
		
		public var id:String;
		public var gesture:Array;
		
		function GestureDictionaryEntry(id:String) {
			this.id = id;
			this.gesture = new Array();
		}
		
		function toString():String {
			return "[GestureDictionaryEntry id="+id+"]";
		}
		
	}
	
}