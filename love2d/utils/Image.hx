package love2d.utils;
import flash.display.Bitmap;
import flash.display.BitmapData;
import haxe.ds.ObjectMap;
import love2d.Handler.Size;
import love2d.Love;
import openfl.Assets;
import openfl.display.Tilesheet;
import love2d.utils.SpriteBatch;

/**
 * Drawable image type. 
 */

class Image extends Drawable
{
	@:allow(love2d) private var _bitmapData:BitmapData;
	private var _source:Dynamic = null;
	
	private var _tilesheet:TilesheetExt;
	
	@:allow(love2d) var _quad:Quad;
	
	public function new(data:Dynamic) 
	{
		super();
		// to-do: ImageData, File
		
		// file path
		if (Std.is(data, String)) {
			_bitmapData = Assets.getBitmapData(data);
		}
		else if (Std.is(data, ImageData)) {
			_bitmapData = data._bitmapData.clone();
			_source = data;
		}
		
		_quad = new Quad(0, 0, getWidth(), getHeight());
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
		//Love.graphics.bitmap(_bitmapData, x, y, sx, sy, r, ox, oy, quad);
		
		if (_tilesheet == null)
		{
			_tilesheet = TilesheetCache.get(this);
		}
		
		var isColored:Bool = ((Love.handler.color.r != 255) || (Love.handler.color.g != 255) || (Love.handler.color.b != 255));
		
		var isAlpha:Bool = (Love.handler.color.a != 255);
		
		var renderItem:RenderItem = Love.graphics.getRenderItem(_tilesheet, isAlpha, isColored);
		
		if (quad == null)	quad = _quad;
		
		var csx:Float = 1;
		var ssy:Float = 0;
		var ssx:Float = 0;
		var csy:Float = 1;
		
		var sin:Float = 0;
		var cos:Float = 1;
		
		var x1:Float = (ox - quad._halfWidth) * sx;
		var y1:Float = (oy - quad._halfHeight) * sy;
		
		var x2:Float = x1;
		var y2:Float = y1;
		
		if (r != 0)
		{
			sin = Math.sin(r);
			cos = Math.cos(r);
			
			csx = cos * sx;
			ssy = sin * sy;
			ssx = sin * sx;
			csy = cos * sy;
			
			x2 = x1 * cos + y1 * sin;
			y2 = -x1 * sin + y1 * cos;
		}
		
		// transformation matrix coefficients
		var a:Float = csx;
		var b:Float = ssx;
		var c:Float = ssy;
		var d:Float = csy;
		
		var list:Array<Float> = renderItem.renderList;
		
		var currIndex = list.length;
		
		list[currIndex++] = x - x2;
		list[currIndex++] = y - y2;
		
		list[currIndex++] = _tilesheet.addTileRectID(quad);
		
		list[currIndex++] = a;
		list[currIndex++] = -b;
		list[currIndex++] = c;
		list[currIndex++] = d;
		
		if (renderItem.isColored)
		{
			list[currIndex++] = Love.handler.color.r / 255;
			list[currIndex++] = Love.handler.color.g / 255;
			list[currIndex++] = Love.handler.color.b / 255;
		}
		
		if (renderItem.isAlpha)
			list[currIndex++] = Love.handler.color.a / 255;
		
		renderItem.numQuads++;
	}
}