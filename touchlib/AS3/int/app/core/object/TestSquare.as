	package app.core.object{
	import flash.display.Shape;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;	
	
	import app.core.utl.ColorUtil;
	import app.core.action.RotatableScalable;
	
	public class TestSquare extends RotatableScalable 
	{		
		[Embed(source="Arial.ttf", fontFamily="myFont")]  var myFont:Class;
		
		private var clickGrabber:Shape = new Shape();			
		public var clickBorder:Shape = new Shape();
		public var _count:String;	
		public var label:TextField;		
		
		public function TestSquare (count:String, wt:Number, ht:Number)
		{	
			_count=count;				 
			//color = ColorUtil.random(0,150,150);						    			
			clickGrabber.graphics.beginFill(0x222222,1);	
			clickGrabber.graphics.lineStyle(2.5,0x666666,1);
			clickGrabber.graphics.drawRect(-wt/2, -ht/2, wt,ht);
			clickGrabber.graphics.endFill();		
			
			clickBorder.graphics.lineStyle(2.5,0xFFFFFF,1);
			clickBorder.graphics.drawRect(-wt/2, -ht/2, wt,ht);		
			clickBorder.alpha = 0;
			
			this.addChild( clickGrabber );	
			this.addChild( clickBorder );
			drawLabel();				
		}
		public function drawLabel ()
		{				
			var format:TextFormat = new TextFormat();
			format.font= "myFont";
			format.color = 0xFFFFFF;
			format.size = 32;				
			var count:int = 0;	
			
			label = new TextField();						
			label.autoSize = TextFieldAutoSize.CENTER;
			label.selectable = false;
			label.defaultTextFormat = format;
			label.embedFonts = true;
			label.text = _count;
			label.alpha = 0;
			label.x = -label.width/2;
			label.y = -label.height/2;
			this.addChild( label );
		}
	}
}