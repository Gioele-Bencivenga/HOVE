package love2d.utils;
import flash.display.Bitmap;
import flash.display.BitmapData;
import haxe.ds.ObjectMap;
import haxe.Timer;
import love2d.Handler.Size;
import love2d.Love;
import openfl.Assets;

/**
 * Drawable image type. 
 */

class Image extends Drawable
{
	@:allow(love2d) private var _bitmapData:BitmapData;
	@:allow(love2d) private var _quad:Quad;
	@:allow(love2d) private var _batch:SpriteBatch;
	
	private var _source:Dynamic = null;
	
	public function new(data:Dynamic) 
	{
		super();
		// to-do: File
		
		// file path
		if (Std.is(data, String)) {
			_bitmapData = Assets.getBitmapData(data);
		}
		else if (Std.is(data, BitmapData)) {
			_bitmapData = data.clone();
		}
		else if (Std.is(data, ImageData)) {
			_bitmapData = data._bitmapData.clone();
			_source = data;
		}
		
		_quad = new Quad(0, 0, getWidth(), getHeight());
		_batch = new SpriteBatch(this);
		_batch._buffer.userData = "image";
		_batch._buffer.targetBitmapData = Love.handler.canvas;
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
	inline public function getDimensions():Size {
		return {width: getWidth(), height: getHeight()};
	}
	
	/**
	 * Gets the original ImageData or CompressedData used to create the Image. 
	 * @return	The original data used to create the Image
	 */
	inline public function getData():Data {
		return _source;
	}
	
	/**
	 * Reloads the Image's contents from the ImageData or CompressedData used to create the image. 
	 */
	public function refresh() {
		if (_source == null) {
			Love.newError("Source data doesn't exist.");
			return;
		}
		_bitmapData = _source._bitmapData.clone();
	}
	
	override public function draw(?x:Float, ?y:Float, ?r:Float, ?sx:Float, ?sy:Float, ?ox:Float, ?oy:Float, ?kx:Float, ?ky:Float, ?quad:Quad) {
		_batch.setColor(Love.handler.color.r, Love.handler.color.g, Love.handler.color.b, Love.handler.color.a);
		_batch.add(quad, x, y, r, sx, sy, ox, oy, kx, ky);
	}
}