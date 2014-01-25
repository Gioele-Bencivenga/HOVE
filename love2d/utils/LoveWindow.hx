package love2d.utils;
import flash.display.BitmapData;
import flash.display.StageDisplayState;
import love2d.Love;
import love2d.utils.LoveWindow.Flags;
import love2d.utils.LoveWindow.Size;
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
		_flags = {fullscreen: false, vsync: true, fsaa: 0, resizable: false, borderless: false, centered: true};
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
		return {width: -1, height: -1}
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
		return true;
	}
	
	/**
	 * Gets whether the window is fullscreen. 
	 * @return True if the window is fullscreen, false otherwise; The type of fullscreen mode used.
	 */
	inline public function getFullscreen():Dynamic {
		return {fullscreen: (Love.stage.displayState == StageDisplayState.FULL_SCREEN)?true:false, fstype: "normal"}
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
	
	// to-do
	
	/**
	 * Changes the display mode. 
	 * @param	width Display width. 
	 * @param	height Display height. 
	 * @param	flags The flags table.
	 * @return	True if successful, false otherwise. 
	 */
	public function setMode(width:Int, height:Int, flags:Flags):Bool {
		width = (width <= 0)?getWidth():width;
		height = (height <= 0)?getHeight():height;
		
		#if html5
		#end
		return false;
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
	 * @return nothing
	 */
	inline public function getFullscreenModes():Dynamic {
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
	fullscreen:Bool,
	vsync:Bool,
	fsaa:Int,
	resizable:Bool,
	borderless:Bool,
	centered:Bool
}

typedef Size = {
	width:Int,
	height:Int
}