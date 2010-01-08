// ActionScript file
package controllers
{
	import tools.UIHelper;
	import views.RecordView;
	
	public class RecordController
	{
		public function RecordController():void
		{
			trace("here");
			
			var view:RecordView = new RecordView();
			UIHelper.pushView(view); 
		}
	}
}