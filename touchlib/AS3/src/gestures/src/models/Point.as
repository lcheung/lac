package models
{
	public class Point
	{
		private var x:int = 0;
		private var y:int = 0;
		private var timestamp:int = 0;
		
		public function Point()
		{
		}
		
		public function setX(var x:int)
		{
			this.x = x;
		}
		
		public function getX()
		{
			return this.x;
		}
		
		public function setY(var y:int)
		{
			this.y = y;
		}
		
		public function getY()
		{
			return this.y;
		}

		public function setTimestamp(var ts:int)
		{
			this.timestamp = ts;
		}
		
		public function getTimestamp()
		{
			return this.timestamp;
		}
	}
}