package love2d.utils;

/**
 * The superclass of all data. 
 */

class Data extends Object
{
	public function new() {
		super();
	}
	
	/**
	 * Gets a pointer to the Data.
	 * @return A raw pointer to the Data. 
	 */
	public function getPointer():Dynamic {
		return null;
	}
	
	/**
	 * Gets the size in bytes of the Data. 
	 * @return The size of the Data in bytes. 
	 */
	public function getSize():Int {
		return 0;
	}
	
	/**
	 * Gets the full Data as a string. 
	 * @return The raw data. 
	 */
	public function getString():String {
		return "";
	}
}