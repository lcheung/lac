package tools
{
	import mx.containers.Canvas;
	import mx.containers.ViewStack;
	import mx.core.Application;
	
	public class UIHelper
	{
		// the applications main view stack
		private static var mainViewStack:ViewStack = Application.application.mainViewStack;
	
		// Pushes a new view onto the main applications
		// view stack
		public static function pushView(view:Canvas):void
		{
			UIHelper.mainViewStack.addChild(view);
			UIHelper.mainViewStack.selectedIndex = UIHelper.mainViewStack.numChildren-1;
		}
		
		// Pops the top view off the stack
		public static function popView():void
		{
			UIHelper.mainViewStack.removeChildAt(UIHelper.mainViewStack.numChildren-1);
		}
		
		//TODO: Add different types of transitions, fades, etc.
	}
}
