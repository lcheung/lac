package app.core.action.gestures {

public class GestureXMLPrinter {
	
	private var xmlDoc:XML;
		
	public function GestureXMLPrinter():void {
		xmlDoc = new XML();		
	}
	
	
	function getDictionaryXML(dict:GestureDictionary):XMLNode {
		var dictXML:XMLNode = xmlDoc.createElement("Dictionary");		
		for (var i:Number=0; i < dict.entries.length; i++) {
			var entry:GestureDictionaryEntry = dict.entries[i];
			dictXML.appendChild( getGestureXML( entry.gesture, entry.id ) );
		}
		return dictXML;
	}
	
	
	function getGestureXML(gesture:Array,id:String):XMLNode {
		
		var entryXML:XMLNode = xmlDoc.createElement("Entry");
		entryXML.attributes["id"] =  id;
		
		var gestureXML:XMLNode = xmlDoc.createElement("Gesture");
		entryXML.appendChild(gestureXML);
		
		for (var i:Number=0; i < gesture.length; i++) {
			var pointXML:XMLNode = xmlDoc.createElement("Point");
			pointXML.attributes["x"] = gesture[i].x;
			pointXML.attributes["y"] = gesture[i].y;
			gestureXML.appendChild(pointXML);			
		}
		
		return entryXML;

	}

}
}