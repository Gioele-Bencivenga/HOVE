package love2d.utils;
import love2d.Love;

/**
 * Provides an interface to connected joysticks.
 */

class LoveJoystick
{
	static private var _buttonsString:Map<String, Int>;
	static private var _buttonsInt:Map<Int, String>;
	
	public function new()
	{
		_buttonsString = new Map();
		_buttonsInt = new Map();
		
		// XBOX360 stuff
		// PS3 stuff
		// OUYA stuff
		
		// Well, I don't know what do with it until Joystick.getName() isn't avalaible.
	}
	
	static private function setMap(button:String, id:Int) {
		_buttonsString.set(button, id);
		_buttonsInt.set(id, button);
	}
	
	static public function toString(button:Int):String {
		return '';
	}
	
	static public function toInt(button:String):Int {
		return 0;
	}
	
	/**
	 * Gets a list of connected Joysticks. 
	 * @return The list of currently connected Joysticks. 
	 */
	inline public function getJoysticks():Array<Joystick> {
		return Love.handler.realJoysticks;
	}
	
	/**
	 * Gets the number of connected joysticks. 
	 * @return The number of connected joysticks. 
	 */
	inline public function getJoystickCount():Int {
		return Love.handler.realJoysticks.length;
	}
	
	/**
	 * Binds a virtual gamepad input to a button, axis or hat for all Joysticks of a certain type.
	 * @param	guid	The OS-dependent GUID for the type of Joystick the binding will affect. 
	 * @param	button	The virtual gamepad button to bind. 
	 * @param	inputtype	The type of input to bind the virtual gamepad button to. 
	 * @param	inputindex	The index of the axis, button, or hat to bind the virtual gamepad button to. 
	 * @param	?hatdir	The direction of the hat, if the virtual gamepad button will be bound to a hat. nil otherwise. 
	 * @return
	 */
	inline public function setGamepadMapping(guid:String, button:String, inputtype:String, inputindex:Int, ?hatdir:String = null):Bool {
		return false;
	}
}

// thanks openfl-ouya!
class OUYA {
	static inline public var O:Int = 0; // 96;
	static inline public var U:Int = 3; // 99;
	static inline public var Y:Int = 4; // 100;
	static inline public var A:Int = 1; // 97;
	static inline public var L1:Int = 6; // 102;
	static inline public var L2:Int = 8; // 104;
	static inline public var R1:Int = 7; // 103;
	static inline public var R2:Int = 9; // 105;
	static inline public var MENU:Int = 0x01000012; // 82;
	static inline public var AXIS_LS_X:Int = 0;
	static inline public var AXIS_LS_Y:Int = 1;
	static inline public var AXIS_RS_X:Int = 11;
	static inline public var AXIS_RS_Y:Int = 14;
	static inline public var AXIS_L2:Int = 17;
	static inline public var AXIS_R2:Int = 18;
	static inline public var DPAD_UP:Int = 19;
	static inline public var DPAD_RIGHT:Int = 22;
	static inline public var DPAD_DOWN:Int = 20;
	static inline public var DPAD_LEFT:Int = 21;
	static inline public var R3:Int = 11; // 107;
	static inline public var L3:Int = 10; // 106;
}