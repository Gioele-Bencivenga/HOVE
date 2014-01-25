package love2d.utils;
import love2d.Love;

/**
 * A random number generation object which has its own random state. 
 */

class RandomGenerator extends Object
{
	private var _seed:Int;
	
	public function new(?state:Int = null) 
	{
		super();
		
		if (state == null) state = Math.round(Math.random() * 2147483646);
		_seed = state;
	}
	
	/**
	 * Generates a pseudo random number in a platform independent way. 
	 * @param	?min	The minimum possible value it should return. 
	 * @param	?max	The maximum possible value it should return. 
	 * @return	The pseudo random number. 
	 */
	public function random(?min:Float = null, ?max:Float = null):Float {
		if (min == null && max == null) {
			min = 0; max = 1;
		}
		if (min != null && max == null) {
			var _min:Float = min;
			min = 0;
			max = _min;
		}
		if (min > max) {
			var _min:Float = min;
			min = max;
			max = _min;
		}
		
		_seed = Std.int((_seed * 16807.0) % 2147483646);
		return min + (_seed / 2147483646) * Math.abs(max - min);
	}
	
	/**
	 * Get a normally distributed pseudo random number. 
	 * @param	stddev	Standard deviation of the distribution. 
	 * @param	mean	The mean of the distribution. 
	 * @return	Normally distributed random number with variance (stddev)² and the specified mean. 
	 */
	public function randomNormal(stddev:Float = 1, mean:Float = 0):Float {
		return -1;
	}
	
	/**
	 * Sets the seed of the random number generator using the specified integer number. 
	 * @param	seed	The integer number with which you want to seed the randomization. Must be within the range of [1, 2147483646]. 
	 */
	inline public function setSeed(seed:Int) {
		if (seed >= 1 && seed <= 2147483646) _seed = seed;
		else Love.newError("The seed number must be within the range of [1, 2147483646].");
	}
	
	/**
	 * Gets the seed of the random number generator object. 
	 * @return The seed.
	 */
	inline public function getSeed():Int {
		return _seed;
	}
}