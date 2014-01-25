package love2d.utils;
import flash.Lib;
import love2d.Handler.Point;
import love2d.Love;

/**
 * A Bézier curve object that can evaluate and render Bézier curves of arbitrary degree.
 */

class BezierCurve extends Object
{
	private var _vertices:Array<Point>;
	
	public function new(vertices:Array<Point>)
	{
		super();
		
		_vertices = vertices;
	}
	
	/**
	 * Insert control point after the i-th control point.
	 * @param	x	Position of the control point along the x axis. 
	 * @param	y	Position of the control point along the y axis. 
	 * @param	i	Index of the control point. 
	 */
	public function insertControlPoint(x:Float, y:Float, i:Int = -1) {
		var p:Point = {x: x, y: y};
		
		if (i > _vertices.length - 1) i = -1;
		if (i == -1) i = _vertices.length;
		if (i == -2) i = _vertices.length - 1;
		
		_vertices.insert(i, p);
	}
	
	/**
	 * Set coordinates of the i-th control point.
	 * @param	i	Index of the control point. 
	 * @param	x	Position of the control point along the x-axis. 
	 * @param	y	Position of the control point along the y-axis. 
	 */
	public function setControlPoint(i:Int, x:Float, y:Float) {
		if (i > 0 && i < _vertices.length) _vertices[i] = {x: x, y: y};
	}
	
	/**
	 * Move the Bézier curve by an offset. 
	 * @param	dx	Offset along the x axis. 
	 * @param	dy	Offset along the y axis. 
	 */
	public function translate(dx:Float, dy:Float) {
		for (i in 0..._vertices.length) {
			var cx:Float = _vertices[i].x;
			var cy:Float = _vertices[i].y;
			_vertices[i] = {x: cx + dx, y: cy + dy};
		}
	}
	
	/**
	 * Rotate the Bézier curve by an angle. 
	 * @param	angle	Rotation angle in radians. 
	 * @param	?ox		X coordinate of the rotation center. 
	 * @param	?oy		Y coordinate of the rotation center. 
	 */
	public function rotate(angle:Float, ?ox:Float = 0, ?oy:Float = 0) {
		var c:Float = Math.cos(angle);
		var s:Float = Math.sin(angle);
		
		for (i in 0..._vertices.length) {
			var cx:Float = _vertices[i].x;
			var cy:Float = _vertices[i].y;
			_vertices[i] = {x: c * (cx - ox) - s * (cy - oy) + ox, y: s * (cx - ox) + c * (cy - oy) + oy};
		}
	}
	
	/**
	 * Scale the Bézier curve by a factor. 
	 * @param	s	Scale factor. 
	 * @param	?ox		X coordinate of the scaling center. 
	 * @param	?oy		Y coordinate of the scaling center. 
	 */
	public function scale(s:Float, ?ox:Float = 0, ?oy:Float = 0) {
		for (i in 0..._vertices.length) {
			var cx:Float = _vertices[i].x;
			var cy:Float = _vertices[i].y;
			_vertices[i] = {x: (cx - ox) * s + ox, y: (cy - oy) * s + oy};
		}
	}
	
	/**
	 * Evaluate Bézier curve at parameter t. 
	 * @param	t	Where to evaluate the curve. 
	 * @return The table that contains X and Y coordinates.
	 */
	public function evaluate(t:Float):Point {
		if (t < 0 || t > 1) {
			Love.newError("Invalid evaluation parameter: must be between 0 and 1");
			return null;
		}

		if (_vertices.length < 2) {
			Love.newError("Invalid Bezier curve: Not enough control points.");
			return null;
		}
		
		var points:Array<Point> = _vertices.copy();
		for (step in 1..._vertices.length) {
			for (i in 0..._vertices.length - step) {
				points[i].x = points[i].x * (1 - t) + points[i + 1].x * t;
				points[i].y = points[i].y * (1 - t) + points[i + 1].y * t;
			}
		}
		return points[0];
		
	}
	
	/**
	 * Get the derivative of the Bézier curve. 
	 * @return	The derivative curve. 
	 */
	public function getDerivative():BezierCurve {
		var diff:Array<Point> = [for (i in 0..._vertices.length - 1) {x: 0, y: 0}];
		var degree:Float = getDegree();
		
		for (i in 0...diff.length) {
			diff[i].x = (_vertices[i + 1].x - _vertices[i].x) * degree;
			diff[i].y = (_vertices[i + 1].y - _vertices[i].y) * degree;
		}
		
		return new BezierCurve(diff);
	}
	
	/**
	 * Get a list of coordinates to be used with love.graphics.line. 
	 * @param	?depth	Number of recursive subdivision steps. 
	 * @return	List of x, y-coordinate pairs of points on the curve. 
	 */
	public function render(?depth:Float = 5):Array<Point> {
		return null;
	}
	
	/**
	 * Get coordinates of the i-th control point.
	 * @param	i	Index of the control point. 
	 * @return The table that contains X and Y coordinates.
	 */
	inline public function getControlPoint(i:Int):Point {
		if (i > 0 && i < _vertices.length) return _vertices[i];
		else return null;
	}
	
	/**
	 * Get the number of control points in the Bézier curve. 
	 * @return	The number of control points. 
	 */
	inline public function getControlPointCount():Int {
		return _vertices.length;
	}
	
	/**
	 * Get degree of the Bézier curve. The degree is equal to number-of-control-points - 1. 
	 * @return	Degree of the Bézier curve. 
	 */
	inline public function getDegree():Int {
		return _vertices.length - 1;
	}
	
	private function subdivide(points:Array<Point>, k:Int) {
		/*void subdivide(vector<love::Vector> &points, int k)
		{
			if (k <= 0)
				return;

			vector<love::Vector> left, right;
			left.reserve(points.size());
			right.reserve(points.size());

			for (size_t step = 1; step < points.size(); ++step)
			{
				left.push_back(points[0]);
				right.push_back(points[points.size() - step]);
				for (size_t i = 0; i < points.size() - step; ++i)
					points[i] = (points[i] + points[i+1]) * .5;
			}
			left.push_back(points[0]);
			right.push_back(points[0]);

			// recurse
			subdivide(left, k-1);
			subdivide(right, k-1);

			// merge (right is in reversed order)
			points.resize(left.size() + right.size() - 1);
			for (size_t i = 0; i < left.size(); ++i)
				points[i] = left[i];
			for (size_t i = 1; i < right.size(); ++i)
				points[i-1 + left.size()] = right[right.size() - i - 1];
		}*/
		
		if (k <= 0) return;
		
		var left:Array<Point>, right:Array<Point>;
	}
}