package love2d.utils;
import love2d.Handler;
#if nape
import nape.geom.Vec2;
import nape.shape.Polygon;

/**
 * Polygon is a convex polygon with up to 8 sides. 
 */

class PolygonShape extends Shape<Polygon>
{
	@:allow(love2d.utils) private var _angle:Float;
	
	public function new(vertices:Array<Point>, ?rect:Bool = false, ?x:Float, ?y:Float, ?width:Int, ?height:Int, ?angle:Float) 
	{
		super();
		
		_angle = angle;
		
		var _list:Array<Vec2>;
		
		if (!rect) _list = [for (v in vertices) new Vec2(v.x, v.y)];
		else _list = Polygon.rect(x, y, width, height);
		
		_shape = new Polygon(_list);
	}
	
	override public function getType():String {
		return "polygon";
	}
}
#else
class PolygonShape {}
#end