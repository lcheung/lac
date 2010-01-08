package core
{
	public class DetectionEngine
	{
		public function DetectionEngine()
		{
		}
		
		
		/* Comparison
		 * The functions related to comparing a reproduced gesture
		 * to a collection of base gestures
		 */
		 
		 //Compare the reproduced path to a collection of base pathes
		 public function comparePathes()
		 {
		 	//iterate through each section
		 	compareSection();
		 } 
		 
		 //Compare two sections
		 private function compareSection()
		 {
		 	//look at direction, slopes, change in slopes, length
		 	
		 	//return integer representing error
		 }
		
		/* Analysis Preparation
		 * The functions related to determining path characteristics
		 * in preparation for comparison 
		 */
		  
		
		//Perform analysis on path
		//i.e. parse into section, determine direction, slope, etc.
		public function preparePath()
		{
			smoothPath();
			parsePath();
			determinePathScale();
		}
		
		//Remove anomalies from the path
		//i.e. remove points that are inconsistent with common trend
		private function smoothPath()
		{
			
		}

		//Split a single blob path into sections based on direction		
		private function parsePath()
		{
			//accept a single path (collection of coords)
			
			//split it up based on changes in direction
			
			//return an array of sections
		}
		
		//Determine the size of the path
		//i.e. the max X & Y deltas 
		private function determinePathScale()
		{
			//accept a single path (collection of coords)
			
			//compute the difference between max & min values for X&Y direction
			
			//return X&Y distance 
		}
		
		
		 

	}
}