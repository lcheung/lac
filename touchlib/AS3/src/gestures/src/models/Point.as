package models
{
	public class Point
	{
		private var pathId:int = 0;
		private var x:int = 0;
		private var y:int = 0;
		private var timestamp:int = 0;
		
		public function Point()
		{
		}
		
		public function Point()
		{
		}
		
		public function setPathId(var id:int):void
		{
			this.pathId = id;
		}
		
		public function getPathId():int
		{
			return this.pathId;
		}
		
		public function setX(var x:int):void
		{
			this.x = x;
		}
		
		public function getX():int
		{
			return this.x;
		}
		
		public function setY(var y:int):void
		{
			this.y = y;
		}
		
		public function getY():int
		{
			return this.y;
		}

		public function setTimestamp(var ts:int):void
		{
			this.timestamp = ts;
		}
		
		public function getTimestamp():int
		{
			return this.timestamp;
		}
	}
}