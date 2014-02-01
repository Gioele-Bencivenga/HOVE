package love2d.utils;
#if nape
import nape.geom.Vec2;
import nape.shape.Circle;

/**
 * Circle extends Shape and adds a radius and a local position. 
 */

class CircleShape extends Shape<Circle>
{
	public function new(x:Float = 0, y:Float = 0, radius:Float) 
	{
		super();
		
		_shape = new Circle(radius, Vec2.weak(x, y));
	}
	
	/**
	 * Sets the radius of the circle. 
	 * @param	radius	The radius of the circle 
	 */
	public function setRadius(radius:Float) {
		_shape.radius = radius;
	}
	
	/**
	 * Gets the radius of the circle shape. 
	 * @return	The radius of the circle 
	 */
	public function getRadius():Float {
		return _shape.radius;
	}
	
	override public function getType():String {
		return "circle";
	}
}
#else
class CircleShape {}
#end