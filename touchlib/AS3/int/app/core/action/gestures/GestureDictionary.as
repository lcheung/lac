package app.core.action.gestures {

	/**
	 *
	 * This class is used to store a collection of gestures.
	 * Once stored, you can match any future gestures against the
	 * dictionary to come up with close matches.
	 *
	 * Example usage:
	 * <code>
	 * var dict:GestureDictionary = new GestureDictionary();
	 * dict.addEntry(entry1);
	 * dict.addEntry(entry2);
	 * var results:Array = dict.search(targetGesture);
	 * var closestMatch:SearchResult = SearchResult( results[0] );
	 * trace("The closest match was:"+closestMatch.entry.id);
	 * trace("It scored:"+closestMatch.score);
	 * </code>
	 *
	 * @author Noel Billig (http://www.dncompute.com)
	 * @version 1.0
	 *
	 * This code is distributed under a Creative Commons Attribution 2.5 License 
	 * http://creativecommons.org/licenses/by/2.5/
	 *
	 */
	public class GestureDictionary {
		
		
		var entries:Array;
		
		
		function GestureDictionary() {
			entries = new Array();
		}
		
		/**
		 * Returns the first entry with the specified ID
		 */
		public function getEntry(entryID:String):GestureDictionaryEntry {
			for (var i:Number=0; i < entries.length; i++) {
				if (entries[i].id == entryID) return entries[i];
			}
		}
		
		/**
		 * Add an entry. There can be multiple entries with the same id (i.e.,
		 * you can have different gestures with the same results)
		 */
		public function addEntry(entry:GestureDictionaryEntry):void {
			entries.push(entry);
		}
		
		
		/**
		 *
		 * @returns an array of SearchResult objects sorted with the closest 
		 * 		matching results first
		 *
		 */
		public function search(targetGesture:Array):Array {
			var searchList:Array = new Array();
			for (var i:Number=0; i < entries.length; i++) {
				var result:SearchResult = new SearchResult();
		
				result.entry = entries[i];
				result.score = GestureRecognitionUtil.getScore(result.entry.gesture,targetGesture);
				searchList.push(result);
			}
			searchList = searchList.sortOn("score", Array.NUMERIC | Array.DESCENDING);
			return searchList;		
		}
		
		
		public function toString():String {
			return "[GestureDictionary size="+entries.length+"]";
		}
		
	}
}