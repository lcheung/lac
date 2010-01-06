package{

// Edge.as 
//  Written by  Masaki SAWAMURA <masaki (at) sawamuland.com>
//  This work is licensed under the Creative Commons Attribution 3.0 License.
//  http://creativecommons.org/licenses/by/3.0/

   import flash.display.Sprite;
   import flash.geom.Point;
   import Node;
   import Graph;

   public class Edge extends Sprite{
      public var graph:Graph;
      public var n1:Node;
      public var n2:Node;
      public function Edge(_n1:Node,_n2:Node,_graph:Graph){
	 graph = _graph;
	 n1 = _n1;
	 n2 = _n2;
	 line();
	 graph.edges.push(this);
      }
      public function line():void{
	 graphics.clear();
	 x = n1.x;
	 y = n1.y;
	 var p1:Point = new Point(n1.x,n1.y);
	 var p2:Point = new Point(n2.x,n2.y);
	 var dest:Point = p2.subtract(p1);
	 graphics.lineStyle(1,0x444444);
	 graphics.lineTo(dest.x,dest.y);
      }
   }
}