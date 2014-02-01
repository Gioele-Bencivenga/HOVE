package love2d.utils;
import love2d.Handler.Point;
import love2d.Handler.Size;

/**
 * Represents a touch point.
 */

class Touch extends Object
{
	private var _id:Int;
	@:allow(love2d) private var _isDown:Bool;
	@:allow(love2d) private var _pressure:Float;
	@:allow(love2d) private var _x:Float;
	@:allow(love2d) private var _y:Float;
	@:allow(love2d) private var _sizeX:Float;
	@:allow(love2d) private var _sizeY:Float;
	
	public function new(?id:Int) 
	{
		super();
		_id = id;
		_isDown = false;
		_x = _y = _sizeX = _sizeY = 0;
		_pressure = 1;
	}
	
	/**
	 * Returns the current x-position of the touch point.
	 * @return The X position.
	 */
	inline public function getX():Float {
		return _x;
	}
	
	/**
	 * Returns the current y-position of the touch point.
	 * @return The Y position.
	 */
	inline public function getY():Float {
		return _y;
	}
	
	/**
	 * Returns whether the finger, attached to the touch point, is on the screen.
	 * @return True if the finger is on the screen.
	 */
	inline public function isDown():Bool {
		return _isDown;
	}
	
	/**
	 * Returns the current position of the touch point.
	 * @return The position.
	 */
	inline public function getPosition():Point {
		return {x: _x, y: _y};
	}
	
	/**
	 * Returns the width of the finger.
	 * @return	The width of the finger.
	 */
	inline public function getWidth():Int {
		return _sizeX;
	}
	
	/**
	 * Returns the height of the finger.
	 * @return	The height of the finger.
	 */
	inline public function getheight():Int {
		return _sizeY;
	}
	
	/**
	 * Returns a size of the finger (essentially, how fat the finger is).
	 * @return Width of the finger, height of the finger.
	 */
	inline public function getSize():Size {
		return {width: Std.int(_sizeX), height: Std.int(_sizeY)};
	}
	
	/**
	 * Returns force of the contact between the finger and the device.
	 * @return A value between 0 and 1.
	 */
	inline public function getPressure():Float {
		return _pressure;
	}
}