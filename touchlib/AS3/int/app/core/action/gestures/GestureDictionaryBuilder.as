package app.core.action.gestures {

	import flash.geom.Point;
	
	/**
	 *
	 * You could use XPath or some sort of automatic XML Serializer to make this more
	 * elegant, but I wanted to package as little extraneous code as possible.
	 *
	 * Anyway, it simply populates a gesture dictionary with entries based on the content
	 * of an XML file.
	 *
	 * @author Noel Billig
	 * @version 1.0
	 *
	 * This code is distributed under a Creative Commons Attribution 2.5 License 
	 * http://creativecommons.org/licenses/by/2.5/
	 *
	 */
	public class GestureDictionaryBuilder {
		
		static function populate(dictionary:GestureDictionary,xml:XML):void {
			
			for each (var entryXML:XML in xml.Entry) {
				var entry:GestureDictionaryEntry = new GestureDictionaryEntry( entryXML.@id );
				dictionary.addEntry(entry);
				for each (var pointXML:XML in entryXML.Gesture.Point) {
					var pnt:Point = new Point(pointXML.@x,pointXML.@y);
					entry.gesture.push( pnt );
				}
            }
			
		}
		
	}
}