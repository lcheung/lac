package app.core.object.Bezier {
	
    import flash.display.Graphics;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.events.Event;  
     
    import app.core.utl.ColorUtil;

    public class BezierObject extends Sprite {
       
        private var p1:BezierPoint = new BezierPoint();
        private var p2:BezierPoint = new BezierPoint();
        private var p3:BezierPoint = new BezierPoint();
        private var p4:BezierPoint = new BezierPoint();
    	private var p5:BezierPoint = new BezierPoint();
    	private var lineColor;
    	
        public var s:Shape = new Shape;
        public function BezierObject() {
        	
        	lineColor=ColorUtil.random(0,0,0);
     
         //   this.x = 100;
        //    this.y = 100;

            addChild(p1);p1.x = 0; p1.y = 0;
            addChild(p2);p2.x = 50; p2.y = 100;
            addChild(p3);p3.x = 150; p3.y = 100;
            addChild(p4);p4.x = 200; p4.y = 0;  
           // addChild(p5);p5.x = 300; p5.y = 0;

            Graphics.prototype.curveTo3 = function(x0:Number,y0:Number,x1:Number,y1:Number,x2:Number,y2:Number,x3:Number,y3:Number,vertex:uint = 100):void {
                this.moveTo(x0, y0);
                var up:Number = 1.0 / (vertex + 1);
                var tm:Number;
                for (var t:Number = 0; t < 1;t += up) {
                    tm = 1 - t;
                    this.lineTo(
                        x0 * Math.pow(tm, 3) + 3 * x1 * t *Math.pow(tm, 2) + 3 * x2 * Math.pow(t, 2) * tm + x3 * Math.pow(t, 3),
                        y0 * Math.pow(tm, 3) + 3 * y1 * t *Math.pow(tm, 2) + 3 * y2 * Math.pow(t, 2) * tm + y3 * Math.pow(t, 3)
                    );

                }
                this.lineTo(x3, y3);
            }
            Object(Graphics).setPropertyIsEnumerable('curveTo3', false);

            addChild(s);
            addEventListener(Event.ENTER_FRAME, enterFrameHandler);
        }

        public function enterFrameHandler(e:Event):void {
            s.graphics.clear();
            s.graphics.lineStyle(5, lineColor,0.75);
            s.graphics['curveTo3'](p1.x, p1.y, p2.x, p2.y, p3.x, p3.y, p4.x, p4.y);
            s.graphics.endFill();

            graphics.clear();
            graphics.lineStyle(1, 0xFFFFFF, 0.45);
            graphics.moveTo(p1.x, p1.y);
            graphics.lineTo(p2.x, p2.y);
            graphics.moveTo(p3.x, p3.y);
            graphics.lineTo(p4.x, p4.y); 
           // graphics.lineTo(p5.x, p5.y);
            graphics.endFill();
        }
    }
}

// from d:id:nitoyon
import flash.display.Sprite; 
import app.core.element.Wrapper; 
import app.core.action.RotatableScalable; 

internal class BezierPoint extends RotatableScalable
{
    private const COLOR:int = 0xFFFFFF;
    private const RADIUS:int = 30;
	
    public function BezierPoint()
    {		
    	bringToFront = true;			
		noScale = true;
		noRotate = true;
		noSelection = true;		
		graphics.lineStyle(1,0xFFFFFF,0.35);
        graphics.beginFill(COLOR,0.55);
        graphics.drawCircle(0, 0, RADIUS);
        graphics.endFill();

        buttonMode = true;
           
       // addEventListener("mouseDown", function(event:*):void{startDrag()});
       // addEventListener("mouseUp", function(event:*):void{stopDrag()});
    }
}
