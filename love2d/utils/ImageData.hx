package love2d.utils;
import flash.display.BitmapData;
import love2d.Handler.Color;
import love2d.Handler.Size;
import love2d.Love;

/**
 * Raw (decoded) image data. 
 */

class ImageData extends Data
{
	private var _bitmapData:BitmapData;
	
	public function new(width:Int, height:Int)
	{
		super();
		// to-do: from File, FileData
		
		_bitmapData = new BitmapData(width, height);
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
		}
		else Love.newError("The X and Y must be in range of [0, w - 1 or h - 1]");
		return null;
	}
	
	/**
	 * Transform an image by applying a function to every pixel. 
	 * @param	pixelFunction	Function parameter to apply to every pixel. 
	 */
	public function mapPixel(pixelFunction:Int->Int->Int->Int->Int->Int->Color) {
	}
}