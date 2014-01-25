package love2d.utils;
import love2d.Handler;
import love2d.Love;

/**
 * Provides system-independent mathematical functions.
 */

class LoveMath
{
	private var _seed:Int;
	private var rng:RandomGenerator;

	public function new() 
	{
		_seed = Math.round(Math.random() * 2147483646);
		rng = newRandomGenerator();
	}
	
	/**
	 * Generates a pseudo random number in a platform independent way. 
	 * @param	?min	The minimum possible value it should return. 
	 * @param	?max	The maximum possible value it should return. 
	 * @return	The pseudo random number. 
	 */
	inline public function random(?min:Float = null, ?max:Float = null):Float {
		return rng.random(min, max);
	}
	
	/**
	 * Get a normally distributed pseudo random number. 
	 * @param	stddev	Standard deviation of the distribution. 
	 * @param	mean	     The mean of the distribution. 
	 * @return	Normally distributed random number with variance (stddev)² and the specified mean. 
	 */
	inline public function randomNormal(stddev:Float = 1, mean:Float = 0):Float {
		return rng.randomNormal(stddev, mean);
	}
	
	/**
	 * Generates a Simplex noise value in 1-4 dimensions. 
	 * @param	x	The first value of the 4-dimensional vector used to generate the noise value. 
	 * @param	y	The second value of the 4-dimensional vector used to generate the noise value. 
	 * @param	z	The third value of the 4-dimensional vector used to generate the noise value. 
	 * @param	w	The fourth value of the 4-dimensional vector used to generate the noise value. 
	 * @return	The noise value in the range of [0, 1]. 
	 */
	public function noise(x:Float, y:Float, z:Float, w:Float):Float {
		return 0;
	}
	
	/**
	 * Sets the seed of the random number generator using the specified integer number. 
	 * @param	seed	The integer number with which you want to seed the randomization. Must be within the range of [0, 2147483645].
	 */
	inline public function setRandomSeed(seed:Int) {
		rng.setSeed(seed);
	}
	
	/**
	 * Gets the seed of the random number generator. 
	 * @return The seed number.
	 */
	inline public function getRandomSeed():Int {
		return rng.getSeed();
	}
	
	/**
	 * Checks whether a polygon is convex. 
	 * @param	vertices	The vertices of the polygon as a table in the form of {{x1, y1}, {x2, y2}, {x3, y3}, ...}. 
	 * @return	Whether the given polygon is convex. 
	 */
	public function isConvex(vertices:Array<Handler.Point>):Bool {
		var i:Int, j:Int, k:Int, z:Float;
		var flag:Int = 0;
		var n:Int = vertices.length;
		
		for (i in 0...n) {
			j = (i + 1) % n;
			k = (i + 2) % n;
			z = (vertices[j].x - vertices[i].x) * (vertices[k].y - vertices[j].y);
			z -= (vertices[j].y - vertices[i].y) * (vertices[k].x - vertices[j].x);
			
			if (z < 0) flag |= 1;
			else if (z > 0) flag |= 2;
			if (flag == 3) return false;
		}
		
		if (flag != 0) return true;
		return false;
	}
	
	/**
	 * Decomposes a simple convex or concave polygon into triangles. 
	 * @param	polygon	Polygon to triangulate. Must not intersect itself. 
	 * @return	List of triangles the polygon is composed of.
	 */
	public function triangulate(polygon:Array<Handler.Point>):Dynamic {
		return null;
	}
	
	// constructors
	
	/**
	 * Creates a new RandomGenerator object which is completely independent of other RandomGenerator objects and random functions. 
	 * @param	?state	The state ("seed") number to use for this instance of the object. 
	 * @return	A Random Number Generator object. 
	 */
	public function newRandomGenerator(?state:Int = null):RandomGenerator {
		return new RandomGenerator(state);
	}
	
	/**
	 * Creates a new BezierCurve object. 
	 * @param	vertices	The vertices of the control polygon as a table in the form of {{x1, y1}, {x2, y2}, {x3, y3}, ...}. 
	 * @return	A Bézier curve object. 
	 */
	public function newBezierCurve(vertices:Array<Handler.Point>):BezierCurve {
		return new BezierCurve(vertices);
	}
}