package {

// Node.as 
//  Written by  Masaki SAWAMURA <masaki (at) sawamuland.com>
//  This work is licensed under the Creative Commons Attribution 3.0 License.
//  http://creativecommons.org/licenses/by/3.0/

   import flash.display.Sprite;
   import flash.display.Shape;
   import flash.display.GradientType;
   import flash.geom.Point;
   import flash.events.*;
   import flash.utils.Timer;
   import flash.text.*;
   import flash.filters.*;
   import Graph;
   import Edge;

   public class Node extends Sprite {
      private var node:Sprite = new Sprite();
      public var edges:Array = [];
      public var graph:Graph;
      public var radius:Number = 10;
      public var fontSize:Number = 12;
      public var pos:Object = {x:0,y:0};
      public var disp:Object = {x:0,y:0};
      public var selected:Object = false;

      public var calced_s:Object = {};
      public var calced_r:Object = {};
      public var id:Number;
      public var color:Number;
      public var text:String;
      //private var filterOnMouse:GlowFilter = new GlowFilter(0xff88000,.8);
      //private var filterNormal:BevelFilter = new BevelFilter(1,90,0xffffff,.7);

      public function Node(_x:Number,_y:Number,_graph:Graph,_opt:Object=null){
	 graph = _graph;
	 if(!_opt) _opt = {};
	 color = _opt.color ? _opt.color : 0xff0000;
	 text = _opt.text ? String(_opt.text) : '';
	 x = _x
	 y = _y;
	 id = this.graph.nodes.length + 1;
	 if(text.length > 0) setText(text);
	 normalState();
	 
	 addEventListener(MouseEvent.MOUSE_OVER,function():void{
	    if(graph.draggingNode) return;
	    focusState();
	 });
	 addEventListener(MouseEvent.MOUSE_OUT,function():void{
	    if(graph.draggingNode) return;
	    normalState();
	 });
	 var oj:Node = this;
	 addEventListener(MouseEvent.MOUSE_DOWN,function(ev:MouseEvent):void{
	    oj.graph.stop();
	    startDrag();
	    graph.draggingNode = oj;
	 });
	 addEventListener(MouseEvent.MOUSE_UP,function(ev:MouseEvent):void{
	    stopDrag();
	    graph.draggingNode = null;
	    oj.graph.move(null,oj);
	 });
      }

      private function normalState():void{
	 //filters = [];
	 graphics.clear();
	 graphics.beginFill(color,1);
	 drawBackground();
	 graphics.endFill();
      }
      
      private function drawBackground():void{
	 if(text.length > 1){
	    graphics.drawRoundRect( 0 - radius, 0 - radius, 
				    fontSize * (text.length), 
				    2 * radius , 
				    0.8 * radius,0.8 * radius);
	 } else { 
	    graphics.drawCircle(0,0,radius);
	 }
      }

      private function focusState():void{
	 graphics.clear();
	 graphics.beginFill(color,1);
	 graphics.lineStyle(1,0xffcc00);
	 drawBackground();
	 graphics.endFill();
	 //filters = [filterOnMouse];
      }
      
      private function setText(txt:String):void{
	 var format:TextFormat = new TextFormat();
         format.font = "Verdana";
         format.color = 0xFFffff;
         format.size = fontSize;
         format.underline = false;
	 var tf:TextField = new TextField();
	 tf.defaultTextFormat = format;
	 tf.text = txt;
	 tf.x = 0 - radius;
	 tf.y = 0 - radius;
	 tf.height = 12 * 2;
	 tf.width = 12 * txt.length;
	 tf.mouseEnabled = false;
	 addChild(tf);
      }

      public function add(_x:Number=-1,_y:Number=-1,_opt:Object=null):Node{
	  if(_x == -1 && _y == -1){
	      var ang:Number = 2 * Math.PI * Math.random();
	      _x = this.x + graph.k * 2 * Math.random() * Math.cos(ang);
	      _y = this.y + graph.k * 2 * Math.random() * Math.sin(ang);
	  }
	 var n1:Node = new Node(_x,_y,this.graph,_opt);
	 var e:Edge = new Edge(this,n1,graph);
	 parent.addChildAt(e,0);
	 this.edges.push( { to: n1, edge: e });
	 n1.edges.push( { to: this, edge: e });
	 graph.nodes.push(n1);
	 graph.addChild(n1);
	 return n1;
      }

      public function connect(n:Node):void{
	 var e:Edge = new Edge(this,n,graph);
	 parent.addChildAt(e,0);
	 this.edges.push({ to:n, edge:e});
	 n.edges.push({ to:this, edge:e});
      }
      
      public function isConnected(n:Node):Boolean{
	 var tf:Boolean = false;
	 if( this === n) return tf;
	 for each(var e:Object in edges){
	    if(e.to === n) tf = true;
	 }
	 return tf;
      }

      public function distance(to:Node):Object{
	 var dist:Object = {};
	 dist.dx = to.x - this.x;
	 dist.dy = to.y - this.y;
	 if(dist.dx == 0) dist.dx = .1;
	 if(dist.dy == 0) dist.dy = .1;
	 dist.d = Math.sqrt(Math.pow(dist.dx,2) + Math.pow(dist.dy,2));
	 dist.ddx = dist.dx / dist.d;
	 dist.ddy = dist.dy / dist.d;
	 return dist;
      }

      public function isSelected():Object{
	 return false;
      }
   }
}