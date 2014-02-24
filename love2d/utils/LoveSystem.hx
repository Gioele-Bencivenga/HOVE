package love2d.utils;
import flash.desktop.Clipboard;
import flash.desktop.ClipboardFormats;
import flash.system.System;
import love2d.utils.LoveSystem.PowerInfo;
#if !html5
import flash.sensors.Accelerometer;
#else
import js.Browser;
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
		System.setClipboard(text);
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
	 * Gets the number of CPU cores in the system. 
	 * @return	The number of CPU cores. 
	 */
	public function getProcessorCount():Int {
		#if (!flash && !js)
		if (Sys.environment().exists("NUMBER_OF_PROCESSORS")) return Std.parseInt(Sys.environment().get("NUMBER_OF_PROCESSORS"));
		#end
		return 0;
	}
	
	/**
	 * Gets information about the system's power supply. 
	 * @return The basic state of the power supply; percentage of battery life left, between 0 and 100;	seconds of battery life left.
	 */
	public function getPowerInfo():PowerInfo {
		#if html5
		// TO-DO: "battery" state
		var state:String = "unknown";
		if (Browser.navigator.battery.charging) state = "charging";
		if (Browser.navigator.battery.level == 1) state = "nobattery";
		if (Browser.navigator.battery.chargingTime == 0) state = "charged";
		
		return {state: state, percent: Browser.navigator.battery.level * 100, seconds: Browser.navigator.battery.dischargingTime};
		#end
		return {state: "unknown", percent: 0, seconds: 0};
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

typedef PowerInfo = {
	state:String,
	percent:Int,
	seconds:Float
}