// ActionScript file
package gestures.models
{
	public class Blob
	{
		private var id:Number;
		private var x:Number;
		private var y:Number;
		
		public function Blob(id:Number, x:Number, y:Number):void
		{
			this.id = id;
			this.x = x;
			this.y = y;
		}
		
		public function getId():Number
		{
			return this.id;
		}
		
		public function getX():Number
		{
			return this.x;
		}
		
		public function getY():Number
		{
			return this.y;
		}
	}
}