package love2d.utils;

/**
 * Provides an interface to decode encoded image data.
 */

class LoveImage
{
	public function new() 
	{
		
	}
	
	// constructors
	
	/**
	 * Creates a new ImageData object. 
	 * @param	width The width of the ImageData. 
	 * @param	height The height of the ImageData. 
	 * @return	The new blank ImageData object. 
	 */
	public function newImageData(width:Int, height:Int):ImageData {
		return new ImageData(width, height);
	}
}