package love2d.utils;
import flash.display.BitmapData;
import flash.display.StageDisplayState;
import flash.Lib;
import flash.system.Capabilities;
import love2d.Handler.Size;
import love2d.Love;
import love2d.utils.LoveWindow.Flags;
#if html5
import js.Browser;
#end

/**
 * Provides an interface for the program's window.
 */

class LoveWindow
{
	private var _flags:Flags;
	
	public function new() 
	{
		_flags = {};
		setMode(getWidth(), getHeight(), {});
	}
	
	/**
	 * Gets the width of the window. 
	 * @return The width of the window. 
	 */
	inline public function getWidth():Int {
		return Love.stage.stageWidth;
	}
	
	/**
	 * Gets the height of the window. 
	 * @return The height of the window. 
	 */
	inline public function getHeight():Int {
		return Love.stage.stageHeight;
	}
	
	/**
	 * Gets the width and height of the window. 
	 * @return The width of the window, the height of the window.
	 */
	inline public function getDimensions():Size {
		return {width: getWidth(), height: getHeight()};
	}
	
	/**
	 * Gets the width and height of the desktop. 
	 * @param	?display The index of the display, if multiple monitors are available. 
	 * @return The width of the desktop, the height of the desktop. 
	 */
	public function getDesktopDimensions(?display:Int = 1):Size {
		#if html5
		return {width: Browser.window.screen.width, height: Browser.window.screen.height};
		#else
		return {width: Std.int(Capabilities.screenResolutionX), height: Std.int(Capabilities.screenResolutionY)};
		#end
	}
	
	/**
	 * Checks if the window has been created. 
	 * @return True if the window has been created, false otherwise. 
	 */
	inline public function isCreated():Bool {
		return true;
	}
	
	/**
	 * Enters or exits fullscreen.
	 * @param	fullscreen Whether to enter or exit fullscreen mode. 
	 * @return True if successful, false otherwise. 
	 */
	public function setFullscreen(fullscreen:Bool):Bool {
		Love.stage.displayState = (!fullscreen)?StageDisplayState.NORMAL:StageDisplayState.FULL_SCREEN;
		Love.handler.canvas = new BitmapData(Love.stage.stageWidth, Love.stage.stageHeight);
		Love.handler.bitmap.bitmapData = Love.handler.canvas;
		_flags.fullscreen = fullscreen;
		return true;
	}
	
	/**
	 * Gets whether the window is fullscreen. 
	 * @return True if the window is fullscreen, false otherwise; The type of fullscreen mode used.
	 */
	inline public function getFullscreen():Bool {
		return _flags.fullscreen;
	}
	
	/**
	 * Sets the window title. 
	 * @param	title The new window title. 
	 */
	public function setTitle(title:String) {
		#if html5
		Browser.document.title = title;
		#end
	}
	
	/**
	 * Gets the window title. 
	 * @return The current window title. 
	 */
	public function getTitle():String {
		#if html5
		return Browser.document.title;
		#else
		return "unknown";
		#end
	}
	
	/**
	 * Changes the display mode. 
	 * @param	width	Display width. 
	 * @param	height	Display height. 
	 * @param	?flags	The flags table.
	 * @return	True if successful, false otherwise. 
	 */
	public function setMode(width:Int, height:Int, ?flags:Flags = null):Bool {
		// to-do
		width = (width <= _flags.minwidth)?getWidth():width;
		height = (height <= _flags.minheight)?getHeight():height;
		if (flags == null) return false;
		
		if (flags.fullscreen == null) flags.fullscreen = getFullscreen();
		if (flags.fullscreentype == null) flags.fullscreentype = "normal";
		if (flags.vsync == null) flags.vsync = true;
		if (flags.fsaa == null) flags.fsaa = 0;
		if (flags.resizable == null) flags.resizable = false;
		if (flags.borderless == null) flags.borderless = false;
		if (flags.centered == null) flags.centered = true;
		if (flags.display == null) flags.display = 1;
		if (flags.minwidth == null) flags.minwidth = 1;
		if (flags.minheight == null) flags.minheight = 1;
		
		
		// width, height
		#if (cpp || neko)
		Lib.current.stage.resize(width, height);
		#end
		// fullscreen
		setFullscreen(flags.fullscreen);
		
		//
		_flags = flags;
		return true;
	}
	
	/**
	 * Returns the current display mode. 
	 * @param callBack callback function to be used.
	 */
	public function getMode(callBack:Int->Int->Flags->Void) {
		callBack(getWidth(), getHeight(), _flags);
	}
	
	/**
	 * Sets the window icon until the game is quit.
	 * @param imagedata The window icon image. 
	 * @return Whether the icon has been set successfully. 
	 */
	public function setIcon(imagedata:ImageData):Bool {
		return false;
	}
	
	/**
	 * Gets a list of supported fullscreen modes. 
	 * @param	?display	The index of the display, if multiple monitors are available. 
	 * @return	A table of width/height pairs. (Note that this may not be in order.) 
	 */
	public function getFullscreenModes(?display:Int = 1):Array<Array<Int>> {
		#if (cpp || neko)
		return Capabilities.screenResolutions;
		#end
		return null;
	}
	
	/**
	 * Checks if the game window is visible. 
	 * @return True if the window is visible or false if not. 
	 */
	inline public function isVisible():Bool {
		return Love.handler.hasFocus;
	}
	
	/**
	 * Checks if the game window has keyboard focus. 
	 * @return True if the window has the focus or false if not. 
	 */
	inline public function hasFocus():Bool {
		return Love.handler.hasFocus;
	}
	
	/**
	 * Gets the window icon. 
	 * @return The window icon imagedata, or nil if no icon has been set with love.window.setIcon. 
	 */
	public function getIcon():ImageData {
		return null;
	}
	
	/**
	 * Checks if the game window has mouse focus. 
	 * @return True if the window has mouse focus or false if not. 
	 */
	inline public function hasMouseFocus():Bool {
		return true;
	}
}

typedef Flags = {
	?fullscreen:Null<Bool>,
	?fullscreentype:String,
	?vsync:Null<Bool>,
	?fsaa:Null<Int>,
	?resizable:Null<Bool>,
	?borderless:Null<Bool>,
	?centered:Null<Bool>,
	?display:Null<Int>,
	?minwidth:Null<Int>,
	?minheight:Null<Int>
}