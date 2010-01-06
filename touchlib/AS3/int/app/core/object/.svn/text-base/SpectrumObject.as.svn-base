package app.core.object
{
	import flash.display.MovieClip;
	import flash.utils.Timer;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
    import flash.events.TimerEvent;
    import flash.media.Sound;	
    import flash.media.SoundTransform;
    import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.utils.ByteArray;
    import flash.net.URLRequest;
	import fl.controls.Button;	
	import app.core.element.*;
	import flash.events.*;
	
	public class SpectrumObject extends MovieClip
	{
		private var _channel:SoundChannel;
		
		private var timer:Timer;		
		
		private var grafico:BitmapData;
		
		public function SpectrumObject()
		{
			init();
			initTimer();
		}
		
		private function init():void
		{	
			//_channel.soundT = new SoundTransform(0.5);
			
		    //var _channel:SoundTransform = new SoundTransform(0.5);
		    
			grafico=new BitmapData(250,50,true,0x00000000);
			var bitmap:Bitmap=new Bitmap(grafico);
			bitmap.x=-135;
			bitmap.y=-25;
			//bitmap.blendMode="invert";
			addChild(bitmap);	
		}
		
		
    	private function initTimer():void
		{
			
			timer=new Timer(20,0);
			timer.addEventListener(TimerEvent.TIMER,update);
			timer.start();
		}
		
		private function update(evt:TimerEvent):void
		{   
		   //  _channel.soundTransform(0.5);
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