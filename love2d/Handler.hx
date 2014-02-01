package love2d;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Loader;
import flash.display.Sprite;
import flash.display.Stage;
import haxe.Timer;
#if !html5
import flash.events.AccelerometerEvent;
import flash.sensors.Accelerometer;
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
import love2d.Handler.Color;
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
	public var joysticks:Array<Joy>;
	public var realJoysticks:Array<Joystick>;
	public var fps:Int = 0;
	
	private var _timer:Int = 0;
	private var _rect:Rectangle;
	private var _point:flash.geom.Point;
	private var _joy:Joystick;
	
	public function new()
	{
		super();
		
		joysticks = [];
		realJoysticks = [];
		
		_rect = new Rectangle();
		_point = new flash.geom.Point();
		
		_joy = new Joystick(0);
		
		for (i in 0...4) {
			var j:Joy = {buttons: [for(it in 0...20) false], axes: [for(it in 0...4) 0], axisCount: 0};
			joysticks.push(j);
			
			// real joysticks
			realJoysticks.push(new Joystick(i));
		}
		
		Lib.current.stage.addChild(this);
		
		keys = [for (i in 0...255) false];
		
		// enterframe
		addEventListener(Event.ENTER_FRAME, function(e:Event) {
			var t:Int = Lib.getTimer();
			dt = (t - _timer) * .001;
			_timer = t;
			
			if (Love.update != null) Love.update(dt);
			if (Love.draw != null) {
				Love.graphics.clear();
				Love.graphics.setColor(color.r, color.g, color.b, color.a);
				Love.draw();
				//Love.graphics.setColor(255, 255, 255, 255);
				if (cursor != null) {
					var img:Image = cursor.getImage();
					Love.graphics.draw(img, Love.mouse.getX(), Love.mouse.getY());
					graphics.clear();
					_rect.width = img.getWidth();
					_rect.height = img.getHeight();
					canvas.copyPixels(img._bitmapData, _rect, _point);
				}
			}
		});
		
		// keydown
		stage.addEventListener(KeyboardEvent.KEY_DOWN, function(e:KeyboardEvent) {
			if (!keys[e.keyCode] && Love.keypressed != null) Love.keypressed(LoveKeyboard.toChar(e.keyCode), false);
			keys[e.keyCode] = true;
			// handling textinput
			if (Love.keyboard.hasTextInput()) {
				var s:String = LoveKeyboard.toChar(e.keyCode);
				if (Love.keyboard.isDown("lshift")) s = s.toUpperCase();
				
				if (s != "LSHIFT") {
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
		
		// it isn't my mistake!
		#if z
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
		#end
		
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
		#if (windows || linux || mac || (android && openfl_ouya))
		// axismove
		stage.addEventListener(JoystickEvent.AXIS_MOVE, function(e:JoystickEvent) {
			var numAxis:Int = e.axis.length;
  
			for (i in 0...numAxis)
			{
				var axis:Float = e.axis[i];
			   
				if (Love.joystickaxis != null) Love.joystickaxis(realJoysticks[e.device], i, Math.round(e.axis[i]), e.device);
				joysticks[e.device].axes[i] = Math.round(e.axis[i]);
			}
		});
		
		// buttondown
		stage.addEventListener(JoystickEvent.BUTTON_DOWN, function(e:JoystickEvent) {
			if (Love.joystickpressed != null) Love.joystickpressed(realJoysticks[e.device], e.id);
			joysticks[e.device].buttons[e.id] = true;
		});
		
		// buttonup
		stage.addEventListener(JoystickEvent.BUTTON_UP, function(e:JoystickEvent) {
			if (Love.joystickpressed != null) Love.joystickreleased(realJoysticks[e.device], e.id);
			joysticks[e.device].buttons[e.id] = false;
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
		
		// close
		stage.addEventListener(Event.CLOSE, function(e:Event) {
			if (Love.quit != null) Love.quit();
		});
		color = {r: 255, g: 255, b: 255, a: 255};
		bgColor = {r: 0, g: 0, b: 0, a: 255};
		
		canvas = new BitmapData(stage.stageWidth, stage.stageHeight, true, 0);
		bitmap = new Bitmap(canvas);
		addChild(bitmap);
	}
	
	public function rgb(r:Int, g:Int, b:Int):Int {
		return (r & 0xFF) << 16 | (g & 0xFF) << 8 | (b & 0xFF);
	}
	
	public function rgba(r:Int, g:Int, b:Int, a:Int):Int {
		return (r & 0xFF) << 16 | (g & 0xFF) << 8 | (b & 0xFF) | a;
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

typedef Joy = {
	buttons:Array<Bool>,
	axes:Array<Int>,
	axisCount:Int
}

typedef Viewport = {
	x:Float,
	y:Float,
	width:Int,
	height:Int
}