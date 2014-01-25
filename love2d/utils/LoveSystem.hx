package love2d.utils;
import flash.desktop.Clipboard;
import flash.desktop.ClipboardFormats;
#if !html5
import flash.sensors.Accelerometer;
#end

/**
 * Provides access to information about the user's system.
 */

class LoveSystem
{
	public function new() 
	{
		
	}
	
	/**
	 * Check for the support of accelerometer.
	 * @return True if accelerometer is supported, false otherwise. 
	 */
	public function isAccelerometerSupported():Bool {
		#if html5
		return false;
		#else
		return Accelerometer.isSupported;
		#end
	}
	
	/**
	 * Puts text in the clipboard. 
	 * @param	text The new text to hold in the system's clipboard. 
	 */
	public function setClipboardText(text:String) {
		#if flash
		Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT, text, true);
		#end
	}
	
	/**
	 * Gets text from the clipboard. 
	 * @return The text currently held in the system's clipboard. 
	 */
	public function getClipboardText():String {
		//return Clipboard.generalClipboard.getData(ClipboardFormats.TEXT_FORMAT);
		return "";
	}
	
	/**
	 * Gets the current operating system.
	 * @return The current operating system.
	 */
	public function getOS():String {
		return
		#if (flash) "Flash"
		#elseif (js) "HTML5"
		#elseif (windows) "Windows"
		#elseif (linux) "Linux"
		#elseif (mac) "OS X"
		#elseif (neko) "Neko"
		#elseif (android) "Android"
		#elseif (ios) "iOS"
		#elseif (blackberry) "Blackberry"
		#elseif (webos) "WebOS"
		#elseif (tizen) "Tizen"
		#elseif (android || openfl_ouya) "OUYA"
		#end
		;
	}
}