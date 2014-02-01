package love2d.utils;
import flash.Lib;
import love2d.Love;
import openfl.display.FPS;

/**
 * Provides an interface to your system's clock.
 */

class LoveTimer
{
	private var fps:FPS;
	
	public function new() 
	{
		fps = new FPS();
		Lib.current.stage.addChild(fps);
	}
	
	/**
	 * Returns the current frames per second. 
	 * @return	The current FPS. 
	 */
	public function getFPS():Int {
		return Std.parseInt(fps.text.substr(5));
	}
	
	/**
	 * Returns the time between the last two frames. 
	 * @return	The time passed (in seconds). 
	 */
	inline public function getDelta():Float {
		return Love.handler.dt;
	}
	
	/**
	 * Returns the average delta time (seconds per frame) over the last second. 
	 * @return	The average delta time over the last second. 
	 */
	inline public function getAverageDelta():Float {
		// to-do
		return Love.handler.dt;
	}
	
	/**
	 * Returns the value of a timer with an unspecified starting time.
	 * @return	The time in seconds. 
	 */
	public function getTime():Int {
		return Lib.getTimer();
	}
	
	/**
	 * Measures the time between two frames.
	 */
	public function step() {
	}
	
	/**
	 * Pauses the current thread for the specified amount of time. 
	 * @param	ms	Milliseconds to sleep for. 
	 */
	public function sleep(ms:Int) {
		#if cpp
		Sys.sleep(ms / 1000);
		#else
			#if flash
			var init:Int = Lib.getTimer();
			while (true) {
				if (Lib.getTimer() - init >= ms) break;
			}
			#end
		#end
	}
}