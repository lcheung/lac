package app.core.canvas{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display.Bitmap;

	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.*;
	//import caurina.transitions.Tweener;	

	public class BrowserBackground extends Sprite{
		private var  m_stage:Stage;
		private var _imageHolder:Sprite;
		private var _bitmap:Bitmap;
		private var _loader:Loader;
		private var _urlReqest:URLRequest;
				
		
		function BrowserBackground(url:String,e:Stage) {
			m_stage =e;
			_loader = new Loader();
			_urlReqest = new URLRequest(url);
			configureListeners(_loader.contentLoaderInfo);
			_loader.load(_urlReqest);		
		}
		private function configureListeners(dispatcher:IEventDispatcher):void {
			dispatcher.addEventListener(Event.COMPLETE, completeHandler, false, 0, true);
		}
		private function completeHandler(event:Event):void {
			var sW:Number = m_stage.stageWidth;
			var sH:Number = m_stage.stageHeight;
			var loader:Loader = Loader(event.target.loader);
			_bitmap = Bitmap(loader.content);
			_imageHolder = new Sprite();

			_bitmap.y -= _bitmap.height;
			_bitmap.smoothing = true;			
			addChild(_imageHolder);
			_imageHolder.addChild(_bitmap);
			_imageHolder.width = sW;
			_imageHolder.scaleY = _imageHolder.scaleX;
			
			if (_imageHolder.height < sH) {
				_imageHolder.height = sH;
				_imageHolder.scaleX = _imageHolder.scaleY;
			}
			_imageHolder.y = sH ;
			_imageHolder.alpha = 1;
			//Tweener.addTween(_imageHolder, {alpha:1, delay:0.35,time:0.35, transition:"easeinoutquad"});
			m_stage.scaleMode = StageScaleMode.NO_SCALE;
			m_stage.stage.align = StageAlign.TOP_LEFT;
			m_stage.addEventListener(Event.RESIZE, stageResized, false, 0, true);
			//dispatchEvent(new Event(BrowserBackground.BACKGROUND_LOADED));
		}		
		private function stageResized(event:Event):void {
			var sH:Number = m_stage.stageHeight;
			_imageHolder.width = m_stage.stageWidth;
			_imageHolder.scaleY = _imageHolder.scaleX;
			if (_imageHolder.height < sH) {
				_imageHolder.height = sH;
				_imageHolder.scaleX = _imageHolder.scaleY;
			}
			_imageHolder.y = sH;
		}
			}
}