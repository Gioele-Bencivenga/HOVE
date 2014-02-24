package love2d.utils;
import flash.ui.Keyboard;
import love2d.Love;

/**
 * Provides an interface to the user's keyboard.
 */

class LoveKeyboard
{
	private var _textInput:Bool = false;
	static private var _keyChar:Map<String, Int>;
	static private var _keyInt:Map<Int, String>;
	
	public function new()
	{
		_keyChar = new Map();
		_keyInt = new Map();
		_setMap(8, "backspace");
		_setMap(9, "tab");
		_setMap(45, "insert");
		_setMap(13, "return");
		_setMap(46, "delete");
		_setMap(144, "numlock");
		_setMap(20, "capslock");
		_setMap(145, "scrolllock");
		_setMap(16, "lshift");
		_setMap(17, "lctrl");
		_setMap(18, "lalt");
		_setMap(91, "lgui");
		_setMap(92, "rgui");
		_setMap(19, "pause");
		_setMap(27, "escape");
		_setMap(37, "left");
		_setMap(39, "right");
		_setMap(38, "up");
		_setMap(40, "down");
		_setMap(36, "home");
		_setMap(35, "end");
		_setMap(33, "pageup");
		_setMap(34, "pagedown");
		_setMap(48, "0");
		_setMap(49, "1");
		_setMap(50, "2");
		_setMap(51, "3");
		_setMap(52, "4");
		_setMap(53, "5");
		_setMap(54, "6");
		_setMap(55, "7");
		_setMap(56, "8");
		_setMap(57, "9");
		_setMap(96, "kp0");
		_setMap(97, "kp1");
		_setMap(98, "kp2");
		_setMap(99, "kp3");
		_setMap(100, "kp4");
		_setMap(101, "kp5");
		_setMap(102, "kp6");
		_setMap(103, "kp7");
		_setMap(104, "kp8");
		_setMap(105, "kp9");
		_setMap(110, "kp.");
		_setMap(188, "kp,");
		_setMap(111, "kp/");
		_setMap(106, "kp*");
		_setMap(107, "kp+");
		_setMap(109, "kp-");
		_setMap(65, "a");
		_setMap(66, "b");
		_setMap(67, "c");
		_setMap(68, "d");
		_setMap(69, "e");
		_setMap(70, "f");
		_setMap(71, "g");
		_setMap(72, "h");
		_setMap(73, "i");
		_setMap(74, "j");
		_setMap(75, "k");
		_setMap(76, "l");
		_setMap(77, "m");
		_setMap(78, "n");
		_setMap(79, "o");
		_setMap(80, "p");
		_setMap(81, "q");
		_setMap(82, "r");
		_setMap(83, "s");
		_setMap(84, "t");
		_setMap(85, "u");
		_setMap(86, "v");
		_setMap(87, "w");
		_setMap(88, "x");
		_setMap(89, "y");
		_setMap(90, "z");
		_setMap(187, "=");
		_setMap(192, "`");
		_setMap(191, "/");
		_setMap(220, "\\");
		_setMap(219, "[");
		_setMap(221, "]");
		_setMap(186, ";");
		_setMap(222, "'");
		_setMap(112, "f1");
		_setMap(113, "f2");
		_setMap(114, "f3");
		_setMap(115, "f4");
		_setMap(116, "f5");
		_setMap(117, "f6");
		_setMap(118, "f7");
		_setMap(119, "f8");
		_setMap(120, "f9");
		_setMap(121, "f10");
		_setMap(122, "f11");
		_setMap(123, "f12");
		_setMap(124, "f13");
		_setMap(125, "f14");
		_setMap(126, "f15");
		_setMap(127, "f16");
		_setMap(128, "f17");
		_setMap(129, "f18");
		_setMap(32, " ");
		_setMap(189, "-");
		
		/*_setMap(Keyboard.HELP, "help");
		_setMap(Keyboard.MENU, "menu");*/
	}
	
	/**
	 * Checks whether a certain key is down.
	 * @param	key		The key to check. 
	 * @return	True if the key is down, false if not. 
	 */
	public function isDown(key:Dynamic):Bool {
		if (Std.is(key, Int)) {
			return Love.handler.keys[key];
		}
		else if (Std.is(key, String))
		{
			return Love.handler.keys[toInt(key)];
		}
		return false;
	}
	
	/**
	 * Gets whether text input events are enabled. 
	 * @return	Whether text input events are enabled. 
	 */
	inline public function hasTextInput():Bool {
		return _textInput;
	}
	
	/**
	 * Enables or disables text input events.
	 * @param	?enable		Whether text input events should be enabled. 
	 */
	inline public function setTextInput(?enable:Bool = true) {
		_textInput = enable;
	}
	
	/**
	 * Enables or disables key repeat.
	 * @param	enable	Whether repeat keypress events should be enabled when a key is held down. 
	 */
	public function setKeyRepeat(enable:Bool) {
	}
	
	/**
	 * Gets whether key repeat is enabled. 
	 * @return	Whether key repeat is enabled. 
	 */
	inline public function hasKeyRepeat():Bool {
		return false;
	}
	
	static private function _setMap(id:Int, key:String) {
		_keyChar.set(key, id);
		_keyInt.set(id, key);
	}
	
	static public function toChar(n:Int):String {
		if (_keyInt.exists(n)) return _keyInt.get(n);
		else return "unknown";
	}
	
	static public function toInt(n:String):Int {
		if (_keyChar.exists(n)) return _keyChar.get(n);
		else return -1;
	}
}
