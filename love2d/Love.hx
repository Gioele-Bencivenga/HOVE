package love2d;
import flash.display.Sprite;
import flash.display.Stage;
import flash.events.Event;
import flash.Lib;
import love2d.utils.Joystick;
import love2d.utils.LoveAudio;
import love2d.utils.LoveEvent;
import love2d.utils.LoveFilesystem;
import love2d.utils.LoveFont;
import love2d.utils.LoveGraphics;
import love2d.utils.LoveImage;
import love2d.utils.LoveJoystick;
import love2d.utils.LoveKeyboard;
import love2d.utils.LoveMath;
import love2d.utils.LoveMouse;
import love2d.utils.LovePhysics;
import love2d.utils.LoveSound;
import love2d.utils.LoveSystem;
import love2d.utils.LoveThread;
import love2d.utils.LoveTimer;
import love2d.utils.LoveTouch;
import love2d.utils.LoveWindow;
import love2d.utils.Touch;

class Love
{
	// callbacks
	
	/**
	 * Love.load();
	 * This function is called exactly once at the beginning of the game.
	 */
	static public var load:Void->Void = null;
	/**
	 * Love.update(dt:Float);
	 * Callback function used to update the state of the game every frame.
	 */
	static public var update:Float->Void = null;
	/**
	 * Love.run();
	 * The main function, containing the main loop. A sensible default is used when left out.
	 * Not avalaible.
	 */
	static public var run:Void->Void = null;
	/**
	 * Love.draw();
	 * Callback function used to draw on the screen every frame.
	 */
	static public var draw:Void->Void = null;
	/**
	 * Love.keypressed(key:String, isrepeat:Bool);
	 * Callback function triggered when a key is pressed.
	 */
	static public var keypressed:String->Bool->Void = null;
	/**
	 * Love.keyreleased(key:String);
	 * Callback function triggered when a key is released.
	 */
	static public var keyreleased:String->Void = null;
	/**
	 * Love.mousepressed(x:Float, y:Float, button:String);
	 * Callback function triggered when a mouse button is pressed.
	 */
	static public var mousepressed:Float->Float->String->Void = null;
	/**
	 * Love.mousereleased(x:Float, y:Float, button:String);
	 * Callback function triggered when a mouse button is released.
	 */
	static public var mousereleased:Float->Float->String->Void = null;
	/**
	 * Love.joystickpressed(joystick:Joystick, button:Int);
	 * Called when a joystick button is pressed.
	 */
	static public var joystickpressed:Joystick->Int->Void = null;
	/**
	 * Love.joystickreleased(joystick:Joystick, button:Int);
	 * Called when a joystick button is released.
	 */
	static public var joystickreleased:Joystick->Int->Void = null;
	/**
	 * Love.gamepadpressed(joystick:Joystick, button:String);
	 * Called when a Joystick's virtual gamepad button is pressed.
	 * Not avalaible.
	 */
	static public var gamepadpressed:Joystick->String->Void = null;
	/**
	 * Love.gamepadreleased(joystick:Joystick, button:String);
	 * Called when a Joystick's virtual gamepad button is released.
	 * Not avalaible.
	 */
	static public var gamepadreleased:Joystick->String->Void = null;
	/**
	 * Love.gamepadaxis(joystick:Joystick, axis:String);
	 * Called when a Joystick's virtual gamepad axis is moved.
	 * Not avalaible.
	 */
	static public var gamepadaxis:Joystick->String->Void = null;
	/**
	 * Love.joystickadded(joystick:Joystick);
	 * Called when a Joystick is connected.
	 * Not avalaible.
	 */
	static public var joystickadded:Joystick->Void = null;
	/**
	 * Love.joystickremoved(joystick:Joystick);
	 * Called when a Joystick is disconnected.
	 * Not avalaible.
	 */
	static public var joystickremoved:Joystick->Void = null;
	/**
	 * Love.joystickaxis(joystick:Joystick, axis:Int, value:Int);
	 * Called when a joystick axis moves.
	 */
	static public var joystickaxis:Joystick->Int->Int->Int->Void = null;
	/**
	 * Love.joystickhat(joystick:Joystick, hat:Int, direction:String);
	 * Called when a joystick hat direction changes.
	 * Not avalaible.
	 */
	static public var joystickhat:Joystick->Int->String->Void = null;
	/**
	 * Love.touchpressed(x:Float, y:Float, touch:Touch);
	 * Called when a finger touches the screen.
	 */
	static public var touchpressed:Float->Float->Touch->Void = null;
	/**
	 * Love.touchreleased(x:Float, y:Float, touch:Touch);
	 * Called when a finger stops to touch the screen.
	 */
	static public var touchreleased:Float->Float->Touch->Void = null;
	/**
	 * Love.touchmove(x:Float, y:Float, touch:Touch);
	 * Called when a finger is moving.
	 */
	static public var touchmove:Float->Float->Touch->Void = null;
	/**
	 * Love.accelerometerupdate(x:Float, y:Float, z:Float);
	 * Called when a accelerometer data updates.
	 */
	static public var accelerometerupdate:Float->Float->Float->Void = null;
	/**
	 * Love.androidkeypressed(key:String);
	 * Can be "back".
	 * Called when Android hardware key is pressed.
	 */
	static public var androidkeypressed:String->Void = null;
	/**
	 * Love.resize(w:Int, h:Int);
	 * Called when the window is resized.
	 */
	static public var resize:Int->Int->Void = null;
	/**
	 * Love.focus(f:Bool);
	 * Callback function triggered when window receives or loses focus.
	 */
	static public var focus:Bool->Void = null;
	/**
	 * Love.textinput(text:String);
	 * Called when text has been entered by the user.
	 */
	static public var textinput:String->Void = null;
	/**
	 * Love.threaderror(thread:Thread, errorstr:String);
	 * Callback function triggered when a Thread encounters an error.
	 * Not avalaible.
	 */
	static public var threaderror:Dynamic->String->Void = null; // not avalaible
	/**
	 * Love.visible(v:Bool);
	 * Callback function triggered when window is shown or hidden.
	 * Not avalaible.
	 */
	static public var visible:Bool->Void = null;
	/**
	 * Love.mousefocus(f:Bool);
	 * Callback function triggered when window receives or loses mouse focus.
	 * Not avalaible.
	 */
	static public var mousefocus:Bool->Void = null;
	/**
	 * Love.errhand(msg:String);
	 * The error handler, used to display error messages.
	 */
	static public var errhand:String->Void = null;
	/**
	 * Love.quit();
	 * Callback function triggered when the game is closed.
	 */
	static public var quit:Void->Void = null;
	
	// modules
	static public var audio(default, null):LoveAudio;
	static public var event(default, null):LoveEvent;
	static public var filesystem(default, null):LoveFilesystem;
	static public var font(default, null):LoveFont;
	static public var graphics(default, null):LoveGraphics;
	static public var image(default, null):LoveImage;
	static public var joystick(default, null):LoveJoystick;
	static public var keyboard(default, null):LoveKeyboard;
	static public var math(default, null):LoveMath;
	static public var mouse(default, null):LoveMouse;
	static public var physics(get, null):LovePhysics;
	static public var sound(default, null):LoveSound;
	static public var system(default, null):LoveSystem;
	static public var thread(default, null):LoveThread;
	static public var timer(default, null):LoveTimer;
	static public var touch(default, null):LoveTouch;
	static public var window(default, null):LoveWindow;
	
	// public stuff
	@:allow(love2d) static private var stage(get, null):Stage;
	/**
	 * Current Love API version.
	 */
	inline static public var _version:String = "0.9.0";
	
	/**
	 * Current HÖVE version.
	 */
	inline static public var _hoveversion:String = "0.1.1";
	
	// private stuff
	/*@:allow(love2d)*/ static /*private*/public var handler:Handler;
	static private var _inited:Bool = false;

	static public function init() {
		var h:Sprite = new Sprite();
		h.addEventListener(Event.ADDED_TO_STAGE, function(e:Event) {
			// initializing modules
			audio = new LoveAudio();
			event = new LoveEvent();
			filesystem = new LoveFilesystem();
			font = new LoveFont();
			image = new LoveImage();
			joystick = new LoveJoystick();
			keyboard = new LoveKeyboard();
			math = new LoveMath();
			mouse = new LoveMouse();
			#if nape
			physics = new LovePhysics();
			#end
			sound = new LoveSound();
			system = new LoveSystem();
			thread = new LoveThread();
			timer = new LoveTimer();
			touch = new LoveTouch();
			window = new LoveWindow();
			
			handler = new Handler();
			graphics = new LoveGraphics();
			if (!_inited && load != null) {
				load();
				_inited = true;
			}
		});
		
		Lib.current.stage.addChild(h);
	}
	
	// utils
	
	/**
	 * Traces data to console.
	 * @param	s Data
	 */
	inline static public function print(s:Dynamic) {
		flash.Lib.trace(s);
	}
	
	/**
	 * Returns the current stage object.
	 * @return Stage object.
	 */
	inline static private function get_stage():Stage {
		return Lib.current.stage;
	}
	
	/**
	 * Creates a new error and traces text of one to the console.
	 * Note: love.errhand can handle this one.
	 * @param	msg		Text of the error.
	 */
	inline static public function newError(msg:String) {
		if (Love.errhand != null) Love.errhand(msg);
		Lib.trace(msg);
	}
	
	static private function get_physics():LovePhysics {
		#if nape
		return physics;
		#else
		newError("You need to install nape to have access to the love.physics.");
		return null;
		#end
	}
}