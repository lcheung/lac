package controllers
{
	import tools.UIHelper;
	import views.HomeView;
	
	public class HomeController
	{
		public function HomeController():void
		{
			var view:HomeView = new HomeView();
			UIHelper.pushView(view);
		}
	}
}