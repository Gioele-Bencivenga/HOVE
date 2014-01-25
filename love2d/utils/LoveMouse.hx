package love2d.utils;
import flash.ui.Mouse;
import love2d.Handler.Point;
import love2d.Love;

/**
 * Provides an interface to the user's mouse.
 */

class LoveMouse
{
	private var _visible:Bool;
	
	public function new()
	{

	}
	
	/**
	 * Returns the current x-position of the mouse. 
	 * @return	The position of the mouse along the x-axis. 
	 */
	inline public function getX():Float {
		return Love.stage.mouseX;
	}
	
	/**
	 * Returns the current y-position of the mouse. 
	 * @return	The position of the mouse along the y-axis. 
	 */
	inline public function getY():Float {
		return Love.stage.mouseY;
	}
	
	/**
	 * Returns the current position of the mouse. 
	 * @return	The position of the mouse along the x-axis, the position of the mouse along the y-axis. 
	 */
	inline public function getPosition():Point {
		return {x: getX(), y: getY()};
	}
	
	/**
	 * Sets the current X position of the mouse. 
	 * @param	x	The new position of the mouse along the x-axis. 
	 */
	public function setX(x:Float) {
	}
	
	/**
	 * Sets the current Y position of the mouse. 
	 * @param	y	The new position of the mouse along the y-axis. 
	 */
	public function setY(y:Float) {
	}
	
	/**
	 * Sets the current position of the mouse. 
	 * @param	x The new position of the mouse along the x-axis. 
	 * @param	y The new position of the mouse along the y-axis. 
	 */
	public function setPosition(x:Float, y:Float) {
	}
	
	/**
	 * Grabs the mouse and confines it to the window. 
	 * @param	grab True to confine the mouse, false to let it leave the window. 
	 */
	public function setGrabbed(grab:Bool) {
	}
	
	/**
	 * Checks if the mouse is grabbed. 
	 * @return True if the cursor is grabbed, false if it is not. 
	 */
	public function isGrabbed():Bool {
		return false;
	}
	
	/**
	 * Checks whether a certain mouse button is down.
	 * @param	button The button to check. 
	 * @return True if the specified button is down. 
	 */
	public function isDown(button:String):Bool {
		switch(button) {
			case "l": return Love.handler.mouseLeftPressed;
			case "r": return Love.handler.mouseRightPressed;
			case "m": return Love.handler.mouseMiddlePressed;
			case "wu": return Love.handler.sign(Love.handler.mouseWheel) == 1;
			case "wd": return Love.handler.sign(Love.handler.mouseWheel) == -1;
			default: return false;
		}
	}
	
	/**
	 * Sets the current visibility of the cursor. 
	 * @param	visible True to set the cursor to visible, false to hide the cursor. 
	 */
	public function setVisible(visible:Bool) {
		if (visible) {
			Mouse.show();
			_visible = true;
		}
		else
		{
			Mouse.hide();
			_visible = false;
		}
	}
	
	/**
	 * Checks if the cursor is visible. 
	 * @return True if the cursor to visible, false if the cursor is hidden. 
	 */
	inline public function isVisible():Bool {
		return _visible;
	}
	
	/**
	 * Sets the current mouse cursor. 
	 * @param	cursor The Cursor object to use as the current mouse cursor. 
	 */
	inline public function setCursor(cursor:Cursor) {
		Love.handler.cursor = cursor;
	}
	
	/**
	 * Gets the current Cursor. 
	 * @return The current cursor.
	 */
	inline public function getCursor():Cursor {
		return Love.handler.cursor;
	}
	
	/**
	 * Gets a Cursor object representing a system-native hardware cursor. 
	 * @param	ctype The type of system cursor to get. 
	 * @return The Cursor object representing the system cursor type. 
	 */
	inline public function getSystemCursor(ctype:String):Cursor {
		return null;
	}
	
	// constructors
	
	/**
	 * Creates a new hardware Cursor object from an image file or ImageData. 
	 * @param	data The ImageData to use for the new Cursor. 
	 * @param	?hotx The x-coordinate in the ImageData of the cursor's hot spot. 
	 * @param	?hoty The y-coordinate in the ImageData of the cursor's hot spot. 
	 * @return The new Cursor object. 
	 */
	public function newCursor(data:Dynamic, ?hotx:Float = 0, ?hoty:Float):Cursor {
		return new Cursor(data, hotx, hoty);
	}
}