package love2d.utils;
import openfl.Assets;

/**
 * Defines the shape of characters than can be drawn onto the screen. 
 */

class Font extends Object
{
	private var _flashFont:flash.text.Font;
	private var _size:Float;
	
	public function new(data:Dynamic, ?size:Float = 12) 
	{
		super();
		
		// to-do: File, FontData
		if (Std.is(data, String)) {
			_flashFont = Assets.getFont(data);
		}
		//flash.Lib.trace(_flashFont.fontName);
		_size = size;
	}
	
	/**
	 * Gets whether the Font can render a character or string. 
	 * @param	text	A UTF-8 encoded unicode string. 
	 * @return	Whether the font can render all the UTF-8 characters in the string. 
	 */
	public function hasGlyphs(text:String):Bool {
		#if (!cpp && !neko)
		return _flashFont.hasGlyphs(text);
		#else
		return false;
		#end
	}
	
	public function getFlashFont():flash.text.Font {
		return _flashFont;
	}
	
	public function getSize():Float {
		return _size;
	}
}