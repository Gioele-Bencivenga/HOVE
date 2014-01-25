package love2d.utils;
import love2d.Love;
import openfl.Assets;

/**
 * Represents a hardware cursor. 
 */

class Cursor extends Object
{
	private var _image:Image;
	private var _hotx:Float;
	private var _hoty:Float;
	private var _type:String;
	
	public function new(data:Dynamic, ?hotx:Float = 0, ?hoty:Float = 0)
	{
		super();
		
		// to-do: ImageData, FileData
		if (Std.is(data, String)) {
			_image = Love.graphics.newImage(data);
			_type = "image";
		}
		_hotx = hotx; _hoty = hoty;
	}
	
	/**
	 * Gets the type of the Cursor. 
	 * @return	The type of the Cursor. 
	 */
	inline public function getType():String {
		return _type;
	}
	
	inline public function getImage():Image { 
		return _image;
	}
}