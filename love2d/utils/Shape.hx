package love2d.utils;
#if nape
import nape.shape.Circle;
import nape.shape.Edge;
import nape.shape.Polygon;

/**
 * Shapes are solid 2d geometrical objects used in love.physics. 
 */

class Shape<T> extends Object
{
	@:allow(love2d.utils) private var _shape:T;
	
	public function new() 
	{
		super();
	}
	
	/**
	 * Gets a string representing the Shape.
	 * @return	The type of the Shape. 
	 */
	public function getType():String {
		return "unknown";
	}
}
#else
class Shape { }
#end