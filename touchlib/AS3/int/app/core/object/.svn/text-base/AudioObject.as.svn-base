package app.core.object
{
	import flash.display.MovieClip;
	import flash.utils.Timer;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
    import flash.events.TimerEvent;
    import flash.media.Sound;
    import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.utils.ByteArray;
    import flash.net.URLRequest;
	import fl.controls.Button;	
	import app.core.element.*;
	import flash.events.*;
	
	public class AudioObject extends MovieClip
	{
		private var url:String='local/audio/aphex_rmx.mp3';
			
		private var _channel:SoundChannel;
		
        private var _sound:Sound;
		
		private var timer:Timer;
		
		private var grafico:BitmapData;	
		
		//private var fireButton:Button;
		
		public function AudioObject()
		{
			init();
			initSound();
			initTimer();
		}
		
		private function init():void
		{
		
			grafico=new BitmapData(250,50,true,0x00000000);
			var bitmap:Bitmap=new Bitmap(grafico);
			bitmap.x=-135;
			bitmap.y=-25;
			bitmap.blendMode="invert";
			addChild(bitmap);	
			
			//fireButton = new Button();
			//fireButton.setSize(68, 68);
			//fireButton.addEventListener(MouseEvent.CLICK, toggleSound, false, 0, true);
			//fireButton.label = "Play";
			
		//	var WrapperObject:Wrapper = new Wrapper(fireButton);
		//	WrapperObject.x = -195;
		//	WrapperObject.y = -33;			
		//	this.addChild( WrapperObject );	
		}
		
		private function initSound():void
		{
			_sound=new Sound(new URLRequest(url));
            _sound = new Sound();
			_sound.load(new URLRequest(url));
			_channel = _sound.play(0, 1000);
		
		}

		
		private function initTimer():void
		{
			timer=new Timer(20,0);
			timer.addEventListener(TimerEvent.TIMER,update);
			timer.start();
		}
		
		private function update(evt:TimerEvent):void
		{
			var spectrum:ByteArray=new ByteArray();
			SoundMixer.computeSpectrum(spectrum);
			grafico.fillRect(grafico.rect,0x0000FF00);
			grafico.fillRect(new Rectangle(1,1,250,30),0x00FF00);
			for(var i:Number=0;i<250;i++) 
			{
				grafico.setPixel32(20+i,20+spectrum.readFloat()*35,0xFF000000);
			}
			for(var j:Number=0;j<250;j++) 
			{
				grafico.setPixel32(20+j,30+spectrum.readFloat()*35,0xFF000000);
			}
		}
	}
}