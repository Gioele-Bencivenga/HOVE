package love2d.utils;

/**
 * Attach multiple bodies together to interact in unique ways. 
 */

class Joint extends Object
{
	public function new() 
	{
		super();
	}
	
	/**
	 * Gets an string representing the type. 
	 * @return	A string with the name of the Joint type. 
	 */
	public function getType():String {
		return "unknown";
	}
}