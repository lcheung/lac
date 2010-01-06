package{

// Graph.as  
//  - verion 0.1  - 2007-6-26
//  Written by  Masaki SAWAMURA <masaki (at) sawamuland.com>
//  This work is licensed under the Creative Commons Attribution 3.0 License.
//  http://creativecommons.org/licenses/by/3.0/

   import flash.display.Sprite;
   import flash.display.Shape;
   import flash.display.GradientType;
   import flash.display.StageAlign;
   import flash.geom.Point;
   import flash.events.*;
   import Node;
   import flash.utils.Timer;
   import flash.display.Stage;

   public class Graph extends Sprite {
       public var draggingNode:Node;      
       public var nodes:Array = [];
       public var edges:Array = [];
       private var timer:Timer = new Timer(100,10);
       public var k:Number;
       
       public function Graph(){
       }
       
       public function init():void{
	  // stage.align = StageAlign.TOP_LEFT;
	   stage.addEventListener(MouseEvent.MOUSE_MOVE,function(ev:Event):void{
		   if(draggingNode){
		       try{
			   var nd:Node = draggingNode;
			   for each (var n1:Object in nd.edges){
				   n1.edge.line();
			       }
		       } catch (e:Error){
			   trace(e);
		       }
		   }
	       });
       }
       
      public function createNode(_x:Number,_y:Number,_opt:Object=null):Node{
	 if(!k){ init(); }
	 var n:Node = new Node(_x,_y,this,_opt);
	 this.addChild(n);
	 nodes.push(n);
	 return n;
      }
       
      public function move(evt:TimerEvent=null,lockNode:Node=null):void{
	 var area:Number = stage.stageHeight * stage.stageWidth;
	   k =  Math.sqrt(area / (nodes.length * 1.3) );
	   //trace("k",k);
	   var f_a:Function = function(d:Number):Number{ return (d * d) / k; };
	   var f_r:Function = function(d:Number):Number{ return (k * k) / ((d == 0) ? 1 : d); };
	   var sp:Number = .05;
	   var drawLinwSpan:Number = 4;
	   timer = new Timer(20,100);
	   
	   var moveStep:Function = function(evt:TimerEvent):void{
	       // repulsive
	       (function():void{
		   for each(var v1:Node in nodes){
			   v1.disp = { x:0,y:0};
			   for each(var v2:Node in nodes){
				   if(v1 === v2) continue;
				   var dist:Object = v2.distance(v1);
				   var fr:Number  = f_r(dist.d);
				   if(4 * k < dist.d) continue;
				   v1.disp = { x : v1.disp.x + dist.ddx * fr,
					       y : v1.disp.y + dist.ddy * fr }
			       }
			   //trace("r",v1.id,v1.disp.x,v1.disp.y);
		       }
	       })();
	       
	       // from wall
	       (function():void{
		   for each(var v1:Node in nodes){
			   var w:Number = 0.2 * Math.log(v1.edges.length);
			   //trace(stage.stageWidth,stage.stageHeight,v1.x,v1.y);
			   var fwx1:Number = 0;
			   var fwy1:Number = 0;
			   var fwx2:Number = 0;
			   var fwy2:Number = 0;
			   var wlimit:Number = k;
			   if(Math.abs(v1.x) < wlimit){
			       fwx1 = w * f_r(Math.abs(v1.x));
			   }
			   if(Math.abs(v1.y) < wlimit){
			       fwy1 = w * f_r(Math.abs(v1.y));
			   }
			   if( Math.abs(stage.stageWidth - v1.x) < wlimit){
			       fwx2 = w * f_r(Math.abs(stage.stageWidth - v1.x));
			   }
			   if( Math.abs(stage.stageHeight - v1.y) < wlimit){
			       fwy2  = w * f_r(Math.abs(stage.stageHeight - v1.y));
			   }
			   //trace("fw",v1.x,fwx1,fwy1,fwx2,fwy2);
			   v1.disp = { x : v1.disp.x +  fwx1 - fwx2,
				       y : v1.disp.y + fwy2 - fwy2 }
			   
	       }
	    })();
	    // attractive
	    (function():void{	    
	       for each(var e:Edge in edges){
		  var dist:Object = e.n2.distance(e.n1);
		  var fa:Number = f_a(dist.d);
		  e.n1.disp = { x: e.n1.disp.x - dist.ddx * fa,
				y: e.n1.disp.y - dist.ddy * fa }
		  e.n2.disp = { x: e.n2.disp.x + dist.ddx * fa,
				y: e.n2.disp.y + dist.ddy * fa }
	       }
	    })();
	    sp *= 0.9
	    for each(var v1:Node in nodes){
	       if(lockNode && lockNode === v1) continue;
	       v1.pos = { x : v1.x, y:v1.y }
	       v1.pos.x +=  sp * v1.disp.x;
	       v1.pos.y +=  sp * v1.disp.y;
	       v1.x = (v1.pos.x <= 0) ? 1 : (v1.pos.x >= stage.stageWidth) ? 
		  (stage.stageWidth - 10 * Math.random()) : v1.pos.x;
	       v1.y = (v1.pos.y <= 0) ? 1 : (v1.pos.y >= stage.stageHeight) ? 
		  (stage.stageHeight - 10 * Math.random() ) : v1.pos.y;
	    }
	    if(timer.currentCount % drawLinwSpan == 0){
	       for each(var e:Edge in edges){
		  e.line();
	       }
	       drawLinwSpan ++;
	    }
	 };
         timer.addEventListener(TimerEvent.TIMER, moveStep);
         timer.start();
      }

       public function clear():void{
	   for each(var e:Edge in edges){
		   removeChild(e);   
	       }
	   for each(var n:Node in nodes){
		   removeChild(n);
	       }
       }
      
      public function stop():void{
	 timer.stop();
      }
   }
}