package love2d.utils;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.geom.Rectangle;
import haxe.ds.ObjectMap;
import love2d.Handler.Viewport;
import openfl.display.Tilesheet;

/**
 * A quadrilateral (a polygon with four sides and four corners) with texture coordinate information. 
 */

class Quad extends Object
{
	@:allow(love2d.utils) private var _x:Float;
	@:allow(love2d.utils) private var _y:Float;
	@:allow(love2d.utils) private var _width:Int;
	@:allow(love2d.utils) private var _height:Int;
	private var _sx:Int;
	private var _sy:Int;
	
	@:allow(love2d.utils.SpriteBatch) private var _halfWidth:Float;
	@:allow(love2d.utils.SpriteBatch) private var _halfHeight:Float;
	
	public function new(x:Float = 0, y:Float = 0, width:Int = 1, height:Int = 1, ?sx:Int = -1, ?sy:Int = -1) 
	{
		super();
		
		_x = x; _y = y;
		_width = width; _height = height;
		if (sx != -1) _sx = (sx < 1)?1:sx;
		else sx = _width;
		if (sy != -1) _sy = (sy < 1)?1:sy;
		else sy = _height;
		
		_halfWidth = 0.5 * _width;
		_halfHeight = 0.5 * _height;
	}
	
	/**
	 * Sets the texture coordinates according to a viewport. 
	 * @param	x	The top-left corner along the x-axis. 
	 * @param	y	The top-right corner along the y-axis. 
	 * @param	width	The width of the viewport. 
	 * @param	height	The height of the viewport. 
	 */
	public function setViewport(x:Float = 0, y:Float = 0, width:Int = 1, height:Int = 1) {
		_x = x; _y = y;
		_width = width; _height = height;
	}
	
	/**
	 * Gets the current viewport of this Quad. 
	 * @return	A viewport.
	 */
	inline public function getViewport():Viewport {
		return {x: _x, y: _y, width: _width, height: _height};
	}
}