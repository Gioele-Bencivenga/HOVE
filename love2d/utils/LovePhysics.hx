package love2d.utils;
import love2d.Handler.Point;
#if nape
import nape.geom.Geom;
import nape.geom.Vec2;
import love2d.utils.LovePhysics.Distance;

/**
 * Can simulate 2D rigid body physics in a realistic manner.
 * This module is based on Nape, and this API corresponds to the Nape API as closely as possible. 
 */

class LovePhysics
{
	public function new() 
	{
		
	}
	
	/**
	 * Returns the two closest points between two fixtures and their distance. 
	 * @param	fixture1	The first fixture. 
	 * @param	fixture2	The second fixture. 
	 * @return	The distance of the two points, coordinates of first point, coordinates of second point.
	 */
	public function getDistance(fixture1:Fixture, fixture2:Fixture):Distance {
		var vec1:Vec2 = new Vec2(), vec2:Vec2 = new Vec2(), distance:Float;
		distance = Geom.distanceBody(fixture1.getBody()._body, fixture2.getBody()._body, vec1, vec2);
		return {distance: distance, x1: vec1.x, y1: vec1.y, x2: vec2.x, y2: vec2.y};
	}
	
	// constructors
	
	/**
	 * Creates a new World. 
	 * @param	?xg		The x component of gravity. 
	 * @param	?yg		The y component of gravity. 
	 * @param	?sleep	Whether the bodies in this world are allowed to sleep. 
	 * @return	A brave new World. 
	 */
	public function newWorld(?xg:Float = 0, ?yg:Float = 0, ?sleep:Bool = true):World {
		return new World(xg, yg, sleep);
	}
	
	/**
	 * Creates a new body. 
	 * @param	world	The world to create the body in. 
	 * @param	?x	The x position of the body. 
	 * @param	?y	The y position of the body. 
	 * @param	type	The type of the body. 
	 * @return	A new body. 
	 */
	public function newBody(world:World, ?x:Float = 0, ?y:Float = 0, type:String = "static"):Body {
		return new Body(world, x, y, type);
	}
	
	/**
	 * Creates and attaches a Fixture to a body. 
	 * @param	body	The body which gets the fixture attached. 
	 * @param	shape	The shape of the fixture. 
	 * @param	?density	The density of the fixture. 
	 * @return	The new fixture. 
	 */
	public function newFixture(body:Body, shape:Shape<Dynamic>, ?density:Float = 1):Fixture {
		return new Fixture(body, shape, density);
	}
	
	/**
	 * Creates a new CircleShape. 
	 * @param	x	The x position of the circle. 
	 * @param	y	The y position of the circle. 
	 * @param	radius	The radius of the circle. 
	 * @return	The new shape. 
	 */
	public function newCircleShape(x:Float, y:Float, radius:Float):CircleShape {
		return new CircleShape(x, y, radius);
	}
	
	/**
	 * Creates a new PolygonShape. 
	 * @param	vertices	Vertices of the polygon. 
	 * @return	A new PolygonShape. 
	 */
	public function newPolygonShape(vertices:Array<Point>):PolygonShape {
		return new PolygonShape(vertices);
	}
	
	/**
	 * Shorthand for creating rectanglar PolygonShapes. 
	 * @param	x	The offset along the x-axis. 
	 * @param	y	The offset along the y-axis. 
	 * @param	width	The width of the rectangle. 
	 * @param	height	The height of the rectangle. 
	 * @param	?angle	The initial angle of the rectangle. 
	 * @return	A new PolygonShape. 
	 */
	public function newRectangleShape(x:Float, y:Float, width:Int, height:Int, ?angle:Float = 0):PolygonShape {
		return new PolygonShape([], true, x, y, width, height);
	}
}

typedef Distance = {
	distance:Float,
	x1:Float,
	y1:Float,
	x2:Float,
	y2:Float
}

#else
class LovePhysics {}
#end