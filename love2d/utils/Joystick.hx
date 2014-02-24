package love2d.utils;
import love2d.Love;

/**
 * Represents a physical joystick. 
 */

class Joystick extends Object
{
	private var _id:Int;
	@:allow(love2d.Handler) private var _buttons:Array<Bool>;
	@:allow(love2d.Handler) private var _axes:Array<Int>;
	@:allow(love2d.Handler) private var _axisCount:Int;
	
	public function new(id:Int) 
	{
		super();
		
		_id = id;
		_buttons = [];
		_axes = [];
		_axisCount = 0;
	}
	
	/**
	 * Gets the joystick's unique identifier.
	 * @return	The Joystick's unique identifier.
	 */
	inline public function getID():Int {
		return _id;
	}
	
	/**
	 * Gets a stable GUID unique to the type of the physical joystick which does not change over time.
	 * @return	The Joystick type's OS-dependent unique identifier. 
	 */
	inline public function getGUID():Int {
		return _id;
	}
	
	/**
	 * Gets the direction of an axis. 
	 * @param	axis	The index of the axis to be checked. 
	 * @return	Current value of the axis. 
	 */
	inline public function getAxis(axis:Int):Int {
		return _axes[axis];
	}
	
	/**
	 * Gets the direction of each axis. 
	 * @return An array containing all the axes.
	 */
	inline public function getAxes():Array<Int> {
		return _axes;
	}
	
	/**
	 * Checks if a button on the Joystick is pressed. 
	 * @param	button	The index of a button to check. 
	 * @return	True if any supplied button is down, false if not. 
	 */
	inline public function isDown(button:Int):Bool {
		return _buttons[button];
	}
	
	/**
	 * Gets the direction of a virtual gamepad axis.
	 * @param	axis	The virtual axis to be checked. 
	 * @return	Current value of the axis. 
	 */
	inline public function getGamepadAxis(axis:Int):Int {
		return getAxis(axis);
	}
	
	/**
	 * Gets the number of axes on the joystick. 
	 * @return	The number of axes available. 
	 */
	inline public function getAxisCount():Int {
		return _axisCount;
	}
	
	// to-do
	
	/**
	 * Gets the direction of a hat. 
	 * @param	hat		The index of the hat to be checked. 
	 * @return	The direction the hat is pushed. 
	 */
	inline public function getHat(hat:Int):String {
		return "unknown";
	}
	
	/**
	 * Gets the number of hats on the joystick. 
	 * @return	How many hats the joystick has.
	 */
	inline public function getHatCount():Int {
		return 2;
	}
	
	/**
	 * Gets the number of buttons on the joystick. 
	 * @return	The number of buttons available. 
	 */
	inline public function getButtonCount():Int {
		return _buttons.length;
	}
	
	/**
	 * Gets whether the Joystick supports vibration. 
	 * @return	True if rumble / force feedback vibration is supported on this Joystick, false if not. 
	 */
	inline public function isVibrationSupported():Bool {
		return false;
	}
	
	/**
	 * Gets the current vibration motor strengths on a Joystick with rumble support. 
	 * @return	Current strength of the left and right vibration motors on the Joystick.
	 */
	inline public function getVibration():Dynamic {
		return {left: 0, right: 0};
	}
	
	/**
	 * Sets the vibration motor speeds on a Joystick with rumble support.
	 * @param	?left	Strength of the left vibration motor on the Joystick. Must be in the range of [0, 1]. 
	 * @param	?right	Strength of the right vibration motor on the Joystick. Must be in the range of [0, 1]. 
	 * @return	True if the vibration was successfully applied, false if not. 
	 */
	inline public function setVibration(?left:Int = 0, ?right:Int = 0):Bool {
		return false;
	}
	
	/**
	 * Gets the name of the joystick. 
	 * @return	The name of the joystick. 
	 */
	inline public function getName():String {
		return "unknown";
	}
	
	/**
	 * Gets whether the Joystick is connected. 
	 * @return	True if the Joystick is currently connected, false otherwise. 
	 */
	inline public function isConnected():Bool {
		return true;
	}
	
	/**
	 * Gets whether the Joystick is recognized as a gamepad.
	 * @return	True if the Joystick is recognized as a gamepad, false otherwise. 
	 */
	inline public function isGamepad():Bool {
		return true;
	}
	
	/**
	 * Checks if a virtual gamepad button on the Joystick is pressed.
	 * @param	button	The gamepad button to check. 
	 * @return	True if any supplied button is down, false if not. 
	 */
	inline public function isGamepadDown(button:String):Bool {
		return false;
	}
	
	/**
	 * Gets the button, axis or hat that a virtual gamepad input is bound to. 
	 * @param	axis	The virtual gamepad axis to get the binding for. 
	 * @param	callBack	callback function
	 */
	inline public function getGamepadMapping(axis:String, callBack:String->Int->String->Void) {
	}
}