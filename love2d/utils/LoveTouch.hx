package love2d.utils;
import flash.ui.Multitouch;

/**
 * Provides an interface to the multitouch.
 */

class LoveTouch
{
	@:allow(love2d) private var _list:Array<Touch>;
	@:allow(love2d) private var _count:Int;
	
	public function new() 
	{
		_list = [for (i in 0...10) new Touch(i)];
		_count = 0;
	}
	
	/**
	 * Returns a list of Touch objects.
	 * @return List of Touch objects.
	 */
	inline public function getList():Array<Touch> {
		return _list;
	}
	
	/**
	 * Return a number of fingers on the screen.
	 * @return Number of fingers.
	 */
	inline public function getPointsCount():Int {
		return _count;
	}
}