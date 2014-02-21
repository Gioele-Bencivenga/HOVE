package love2d.utils;
import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Rectangle;
import love2d.Handler.Color;
import love2d.Handler.Size;
import love2d.Love;

/**
 * Raw (decoded) image data. 
 */

class ImageData extends Data
{
	@:allow(love2d.utils) private var _bitmapData:BitmapData;
	private var _bufferRect:Rectangle;
	private var _bufferPoint:Point;
	
	public function new(width:Int, height:Int)
	{
		super();
		// to-do: from File, FileData
		
		_bitmapData = new BitmapData(width, height);
		_bufferRect = new Rectangle();
		_bufferPoint = new Point();
	}
	
	/**
	 * Gets the width of the ImageData. 
	 * @return	The width of the ImageData. 
	 */
	inline public function getWidth():Int {
		return _bitmapData.width;
	}
	
	/**
	 * Gets the height of the ImageData. 
	 * @return	The height of the ImageData. 
	 */
	inline public function getHeight():Int {
		return _bitmapData.height;
	}
	
	/**
	 * Gets the width and height of the ImageData. 
	 * @return The width and height of the ImageData. 
	 */
	inline public function getDimensions():Size {
		return {width: getWidth(), height: getHeight()};
	}
	
	/**
	 * Sets the color of a pixel. Valid x and y values start at 0 and go up to image width and height minus 1. 
	 * @param	x	The position of the pixel on the x-axis. 
	 * @param	y	The position of the pixel on the y-axis. 
	 * @param	r	The red component (0-255). 
	 * @param	g	The green component (0-255). 
	 * @param	b	The blue component (0-255). 
	 * @param	a	The alpha component (0-255). 
	 */
	public function setPixel(x:Int, y:Int, r:Int, g:Int, b:Int, a:Int) {
		if (x > -1 && y > -1 && x < getWidth() && y < getHeight()) _bitmapData.setPixel32(x, y, Love.handler.rgba(r, g, b, a));
		else Love.newError("The X and Y must be in range of [0, w - 1 or h - 1]");
	}
	
	/**
	 * Gets the pixel at the specified position. Valid x and y values start at 0 and go up to image width and height minus 1. 
	 * @param	x	The position of the pixel on the x-axis. 
	 * @param	y	The position of the pixel on the y-axis. 
	 * @return	The color.
	 */
	public function getPixel(x:Int, y:Int):Color {
		if (x > -1 && y > -1 && x < getWidth() && y < getHeight()) {
			var c:Int = _bitmapData.getPixel32(x, y);
			return {r: Love.handler.getRed(c), g: Love.handler.getGreen(c), b: Love.handler.getBlue(c), a: Love.handler.getAlpha(c)};
		}
		else Love.newError("The X or Y is out of range.");
		return null;
	}
	
	/**
	 * Paste into ImageData from another source ImageData. 
	 * @param	source	Source ImageData from which to copy. 
	 * @param	dx	Destination top-left position on x-axis. 
	 * @param	dy	Destination top-left position on y-axis. 
	 * @param	sx	Source top-left position on x-axis. 
	 * @param	sy	Source top-left position on y-axis. 
	 * @param	sw	Source width. 
	 * @param	sh	Source height. 
	 */
	public function paste(source:ImageData, dx:Float, dy:Float, sx:Float, sy:Float, sw:Int, sh:Int) {
		_bufferRect.setTo(sx, sy, sw, sh);
		_bufferPoint.setTo(dx, dy);
		_bitmapData.copyPixels(source._bitmapData, _bufferRect, _bufferPoint);
	}
	
	/**
	 * Transform an image by applying a function to every pixel. 
	 * @param	pixelFunction	Function parameter to apply to every pixel. 
	 */
	public function mapPixel(pixelFunction:Int->Int->Int->Int->Int->Int->Color) {
	}
}