package love2d;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Loader;
import flash.display.Sprite;
import flash.display.Stage;
import haxe.Timer;
import love2d.Handler.FloatColor;
#if !html5
import flash.events.AccelerometerEvent;
import flash.sensors.Accelerometer;
#else
import js.Browser;
import js.html.Gamepad;
import js.html.GamepadList;
#end
import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.events.ProgressEvent;
import flash.events.TouchEvent;
import flash.geom.Rectangle;
import flash.Lib;
import flash.system.System;
import flash.ui.Mouse;
import love2d.utils.Cursor;
import love2d.utils.Image;
import love2d.utils.Joystick;
import love2d.utils.LoveKeyboard;
import love2d.utils.Touch;
#if (windows || linux || mac || (android && openfl_ouya))
import openfl.events.JoystickEvent;
#end

/* 
 * This is a long file that you shouldn't care about!
 * Actually, this is a heart of the whole system.
*/

class Handler extends Sprite
{
	public var color:Color;
	public var intColor(get, null):Int;
	public var bgColor:Color;
	public var intBgColor(get, null):Int;
	public var canvas:BitmapData;
	public var bitmap:Bitmap;
	public var keys:Array<Bool>;
	public var mouseLeftPressed:Bool = false;
	public var mouseRightPressed:Bool = false;
	public var mouseMiddlePressed:Bool = false;
	public var mouseWheel:Int = 0;
	public var dt:Float;
	public var hasFocus:Bool = true;
	public var cursor:Cursor;
	public var joysticks:Array<Joystick>;
	
	private var _timer:Int = 0;
	private var _rect:Rectangle;
	private var _point:flash.geom.Point;
	private var _joy:Joystick;
	
	#if html5
	private var joyList:Dynamic;
	#end
	
	public function new()
	{
		super();
		
		joysticks = [];
		
		_rect = new Rectangle();
		_point = new flash.geom.Point();
		
		_joy = new Joystick(0);
		
		var n:Int;
		#if (cpp || neko)
		n = 4;
		#elseif (html5)
		if (untyped navigator.webkitGetGamepads) {
			joyList = untyped navigator.webkitGetGamepads();
		} else joyList = cast [];
		n = joyList.length;
		#elseif (flash)
		n = 0;
		#end
		
		for (i in 0...n) {
			var j:Joystick = new Joystick(i);
			joysticks.push(j);
			
			#if html5
			var g:Gamepad = joyList[i];
			#end
			
			var bn:Int; // buttons
			#if (cpp || neko || html5)
			bn = 20;
			#elseif (flash)
			bn = 0;
			#end
			
			j._buttons = [for (it in 0...bn) false];
			
			var an:Int; // axes
			#if (cpp || neko || html5)
			an = 4;
			#elseif (flash)
			an = 0;
			#end
			
			j._axes = [for (it in 0...an) 0];
			
			var name:String; // name
			#if (cpp || neko || flash)
			name = "Unknown";
			#elseif (html5)
			name = "x";
			#end
			j._name = name;
			
			var guid:Int; // GUID
			#if (cpp || neko || html5)
			guid = 0;
			#elseif (flash)
			guid = -1;
			#end
		}

		Lib.current.stage.addChild(this);
		
		keys = [for (i in 0...255) false];
		
		// enterframe
		addEventListener(Event.ENTER_FRAME, function(e:Event) {if (Love.update != null) Love.update(dt);
			var t:Int = Lib.getTimer();
			dt = (t - _timer) * .001;
			_timer = t;
			
			if (Love.update != null) Love.update(dt);
			if (Love.draw != null) {
				Love.graphics.clear();
				for (v in Love.graphics._dust.list) {
					if (v.userData == "image") v.clear();
				}
				Love.draw();
				for (v in Love.graphics._dust.list) {
					v.draw();
				}
				Love.graphics.setColor(255, 255, 255, 255);
				if (cursor != null) {
					var img:Image = cursor.getImage();
					Love.graphics.draw(img, Love.mouse.getX(), Love.mouse.getY());
					graphics.clear();
					_rect.width = img.getWidth();
					_rect.height = img.getHeight();
					canvas.copyPixels(img._bitmapData, _rect, _point);
				}
			}
			
			// joysticks
			#if html5
			for (i in 0...joysticks.length) {
				var g:Gamepad = joyList[i];
				var j:Joystick = joysticks[i];
				
				if (g != null) j._buttons = [for (it in 0...g.buttons.length) (g.buttons[it] > 0)?true:false];
				if (g != null) j._axes = [for (it in 0...g.axes.length) Std.int(g.axes[it])];
				
				if (j._name == "x" && g != null) j._name = g.id;
				if (g != null) j._guid = g.index;
			}
			#end
		});
		
		// keydown
		stage.addEventListener(KeyboardEvent.KEY_DOWN, function(e:KeyboardEvent) {
			if (!keys[e.keyCode] && Love.keypressed != null) Love.keypressed(LoveKeyboard.toChar(e.keyCode), false);
			keys[e.keyCode] = true;
			
			if (LoveKeyboard.isPressed != null) LoveKeyboard.isPressed(LoveKeyboard.toChar(e.keyCode));
			
			// handling textinput
			if (Love.keyboard.hasTextInput()) {
				var s:String = LoveKeyboard.toChar(e.keyCode);
				
				if ((e.keyCode > 64 && e.keyCode < 91) || (e.keyCode > 47 && e.keyCode < 58) || e.keyCode == 32) {
					if (Love.keyboard.isDown("lshift")) s = s.toUpperCase();
					if (Love.keyboard.isDown(" ")) s = " ";
					if (Love.textinput != null) Love.textinput(s);
				}
			}
			
			// handling back key on Android
			#if android
			if (e.keyCode == 27) System.exit(0);
			#end
			
		});
		
		// keyup
		stage.addEventListener(KeyboardEvent.KEY_UP, function(e:KeyboardEvent) {
			if (keys[e.keyCode] && Love.keyreleased != null) Love.keyreleased(LoveKeyboard.toChar(e.keyCode));
			keys[e.keyCode] = false;
			if (LoveKeyboard.isReleased != null) LoveKeyboard.isReleased(LoveKeyboard.toChar(e.keyCode));
		});
		
		// mousebuttondown / up
		stage.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent) {
			if (!mouseLeftPressed && Love.mousepressed != null) Love.mousepressed(e.stageX, e.stageY, "l");
			mouseLeftPressed = true;
		});
		
		stage.addEventListener(MouseEvent.MOUSE_UP, function(e:MouseEvent) {
			if (mouseLeftPressed && Love.mousereleased != null) Love.mousereleased(e.stageX, e.stageY, "l");
			mouseLeftPressed = false;
		});
		
		stage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, function(e:MouseEvent) {
			if (!mouseRightPressed && Love.mousepressed != null) Love.mousepressed(e.stageX, e.stageY, "r");
			mouseRightPressed = true;
		});
		
		stage.addEventListener(MouseEvent.RIGHT_MOUSE_UP, function(e:MouseEvent) {
			if (mouseRightPressed && Love.mousereleased != null) Love.mousereleased(e.stageX, e.stageY, "r");
			mouseRightPressed = false;
		});
		
		stage.addEventListener(MouseEvent.MIDDLE_MOUSE_DOWN, function(e:MouseEvent) {
			if (!mouseMiddlePressed && Love.mousepressed != null) Love.mousepressed(e.stageX, e.stageY, "m");
			mouseMiddlePressed = true;
		});
		
		stage.addEventListener(MouseEvent.MIDDLE_MOUSE_UP, function(e:MouseEvent) {
			if (mouseMiddlePressed && Love.mousereleased != null) Love.mousereleased(e.stageX, e.stageY, "m");
			mouseMiddlePressed = false;
		});
		
		stage.addEventListener(MouseEvent.MOUSE_WHEEL, function(e:MouseEvent) {
			if (mouseWheel != e.delta) {
				var dir:String = (sign(e.delta) == 1)?"wu":"wd";
				if (Love.mousepressed != null) Love.mousepressed(e.stageX, e.stageY, dir);
				if (Love.mousereleased != null) Love.mousereleased(e.stageX, e.stageY, dir);
			}
			mouseWheel = e.delta;
		});
		
		// touchbegin
		stage.addEventListener(TouchEvent.TOUCH_BEGIN, function(e:TouchEvent) {
			var t:Touch = Love.touch._list[e.touchPointID];
			// touch params
			t._x = e.stageX;
			t._y = e.stageY;
			if (Reflect.hasField(e, "pressure")) {
				t._pressure = Reflect.getProperty(e, "pressure");
			}
			else
			{
				t._pressure = 1;
			}
			#if !html5
			t._sizeX = e.sizeX;
			t._sizeY = e.sizeY;
			#end
			t._isDown = true;
			
			if (Love.touchpressed != null) Love.touchpressed(e.stageX, e.stageY, t);
			
			Love.touch._count++;
		});
		
		// touchend
		stage.addEventListener(TouchEvent.TOUCH_END, function(e:TouchEvent) {
			var t:Touch = Love.touch._list[e.touchPointID];
			// touch params
			t._x = e.stageX;
			t._y = e.stageY;
			if (Reflect.hasField(e, "pressure")) {
				t._pressure = Reflect.getProperty(e, "pressure");
			}
			else
			{
				t._pressure = 1;
			}
			#if !html5
			t._sizeX = e.sizeX;
			t._sizeY = e.sizeY;
			t._isDown = false;
			#end
			
			if (Love.touchreleased != null) Love.touchreleased(e.stageX, e.stageY, t);
			
			Love.touch._count--;
		});
		
		// touchmove
		stage.addEventListener(TouchEvent.TOUCH_MOVE, function(e:TouchEvent) {
			var t:Touch = Love.touch._list[e.touchPointID];
			// touch params
			t._x = e.stageX;
			t._y = e.stageY;
			if (Reflect.hasField(e, "pressure")) {
				t._pressure = Reflect.getProperty(e, "pressure");
			}
			else
			{
				t._pressure = 1;
			}
			#if !html5
			t._sizeX = e.sizeX;
			t._sizeY = e.sizeY;
			t._isDown = false;
			#end
			
			if (Love.touchmove != null) Love.touchmove(e.stageX, e.stageY, t);
			
			Love.touch._count++;
		});
		
		// accelerometerupdate
		#if !html5
		if (Love.system.isAccelerometerSupported()) {
			var acc:Accelerometer = new Accelerometer();
			acc.addEventListener(AccelerometerEvent.UPDATE, function(e:AccelerometerEvent) {
				if (Love.accelerometerupdate != null) Love.accelerometerupdate(e.accelerationX, e.accelerationY, e.accelerationZ);
			});
		}
		#end
		
		// joystick
		#if (windows || neko)
		// axismove
		stage.addEventListener(JoystickEvent.AXIS_MOVE, function(e:JoystickEvent) {
			var numAxis:Int = e.axis.length;
  
			for (i in 0...numAxis)
			{
				var axis:Float = e.axis[i];
			   
				if (Love.joystickaxis != null) Love.joystickaxis(joysticks[e.device], i, Math.round(e.axis[i]), e.device);
				joysticks[e.device]._axes[i] = Math.round(e.axis[i]);
			}
	
		});
		
		// buttondown
		stage.addEventListener(JoystickEvent.BUTTON_DOWN, function(e:JoystickEvent) {
			if (Love.joystickpressed != null) Love.joystickpressed(joysticks[e.device], e.id);
			joysticks[e.device]._buttons[e.id] = true;
		});
		
		// buttonup
		stage.addEventListener(JoystickEvent.BUTTON_UP, function(e:JoystickEvent) {
			if (Love.joystickpressed != null) Love.joystickreleased(joysticks[e.device], e.id);
			joysticks[e.device]._buttons[e.id] = false;
		});
			
		// hatmove
		stage.addEventListener(JoystickEvent.HAT_MOVE, function(e:JoystickEvent) {
			Lib.trace(e.id);
		});
		
		// ballmove
		stage.addEventListener(JoystickEvent.BALL_MOVE, function(e:JoystickEvent) {
			Lib.trace("ball: " + e.id);
		});
		#end
		
		// resize
		stage.addEventListener(Event.RESIZE, function(e:Event) {
			// TODO: maybe use this line later
			//	if (canvas != null) canvas.dispose();
			canvas = new BitmapData(Love.window.getWidth(), Love.window.getHeight());
			bitmap.bitmapData = canvas;
			if (Love.resize != null) Love.resize(Love.window.getWidth(), Love.window.getHeight());
		});
		
		// focusin
		stage.addEventListener(FocusEvent.FOCUS_IN, function(e:FocusEvent) {
			if (Love.focus != null) Love.focus(true);
			hasFocus = true;
		});
		
		// focusout
		stage.addEventListener(FocusEvent.FOCUS_OUT, function(e:FocusEvent) {
			if (Love.focus != null) Love.focus(false);
			hasFocus = false;
		});
		
		//
		
		// close
		stage.addEventListener(Event.CLOSE, function(e:Event) {
			if (Love.quit != null) Love.quit();
		});
		color = { r: 255, g: 255, b: 255, a: 255 };
		bgColor = {r: 0, g: 0, b: 0, a: 255};
		
		canvas = new BitmapData(stage.stageWidth, stage.stageHeight, true, 0);
		bitmap = new Bitmap(canvas);
		addChild(bitmap);
	}

	public function rgb(r:Int, g:Int, b:Int):Int {
		return (r & 0xFF) << 16 | (g & 0xFF) << 8 | (b & 0xFF);
	}
	
	// Thank you, HaxeFlixel! :)
	public function rgba(r:Int, g:Int, b:Int, a:Int):Int {
		return a << 24 | r << 16 | g << 8 | b;
	}
	
	inline public function getAlpha(color:Int):Int
	{
		return (color >> 24) & 0xFF;
	}

	inline public function getRed(color:Int):Int
	{
		return color >> 16 & 0xFF;
	}

	inline public function getGreen(color:Int):Int
	{
		return color >> 8 & 0xFF;
	}
	
	inline public function getBlue(color:Int):Int
	{
		return color & 0xFF;
	}

	public function sign(n:Float):Int {
		if (n == 0) return 0;
		return (n < 0)? -1:1;
	}
	
	private function get_intColor():Int {
		return rgb(color.r, color.g, color.b);
	}
	
	private function get_intBgColor():Int {
		return rgb(bgColor.r, bgColor.g, bgColor.b);
	}
}

typedef Color = {
	r:Int,
	g:Int,
	b:Int,
	a:Int
}

typedef FloatColor = {
	r:Float,
	g:Float,
	b:Float,
	a:Float
}

typedef Point = {
	x:Float,
	y:Float
}

typedef Size = {
	width:Int,
	height:Int
}

typedef Range = {
	min:Float,
	max:Float
}

typedef Viewport = {
	x:Float,
	y:Float,
	width:Int,
	height:Int
}