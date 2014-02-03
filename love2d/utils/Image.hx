package love2d.utils;
import flash.display.Bitmap;
import flash.display.BitmapData;
import haxe.ds.ObjectMap;
import love2d.Love;
import openfl.Assets;
import openfl.display.Tilesheet;

/**
 * Drawable image type. 
 */

class Image extends Drawable
{
	@:allow(love2d) private var _bitmapData:BitmapData;
	
	public function new(data:Dynamic) 
	{
		super();
		// to-do: ImageData, File
		if (Std.is(data, String)) {
			_bitmapData = Assets.getBitmapData(data);
		}
	}
	
	/**
	 * Gets the width of the Image. 
	 * @return	The width of the Image, in pixels. 
	 */
	inline public function getWidth():Int {
		return _bitmapData.width;
	}
	
	/**
	 * Gets the height of the Image. 
	 * @return	The height of the Image, in pixels. 
	 */
	inline public function getHeight():Int {
		return _bitmapData.height;
	}
	
	/**
	 * Gets the width and height of the Image. 
	 * @return	A table that contains width and height;
	 */
	inline public function getDimensions():Dynamic {
		return {width: getWidth(), height: getHeight()};
	}
	
	override public function draw(?x:Float, ?y:Float, ?r:Float, ?sx:Float, ?sy:Float, ?ox:Float, ?oy:Float, ?kx:Float, ?ky:Float, ?quad:Quad) {
		Love.graphics.bitmap(_bitmapData, x, y, sx, sy, r, ox, oy, quad);
		
		if (!Love.graphics._batchMap.exists(this)) {
			var sb:SpriteBatch = new SpriteBatch(this);
			Love.graphics._batchMap.set(this, sb);
		}
		
		if (Love.graphics._batchMap.exists(this)) {
			Love.graphics._batchMap.get(this).add(quad, x, y, r, sx, sy, ox, oy, kx, ky);
		}
	}
}