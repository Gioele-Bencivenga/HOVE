package love2d.utils;
import flash.system.System;
import love2d.Love;

/**
 * Manages events, like keypresses.
 */

class LoveEvent
{
	public function new() 
	{
		
	}
	
	/**
	 * Clears the event queue. 
	 */
	public function clear() {
	}
	
	/**
	 * Returns an iterator for messages in the event queue. 
	 * @return Iterator function usable in a for loop. 
	 */
	public function poll():Dynamic {
		return null;
	}
	
	/**
	 * Like love.event.poll(), but blocks until there is an event in the queue. 
	 * @return actually, nothing.
	 */
	public function wait():Dynamic {
		return null;
	}
	
	/**
	 * Pump events into the event queue.
	 */
	public function pump() {
	}
	
	/**
	 * Adds an event to the event queue. 
	 * @param	e The name of the event. 
	 * @param	a First event argument. 
	 * @param	b Second event argument. 
	 * @param	c Third event argument. 
	 * @param	d Fourth event argument. 
	 */
	public function push(e:String, a:Dynamic, b:Dynamic, c:Dynamic, d:Dynamic) {
	}
	
	/**
	 * Adds the quit event to the queue. 
	 */
	public function quit() {
		if (Love.quit != null) Love.quit();
		System.exit(0);
	}
}