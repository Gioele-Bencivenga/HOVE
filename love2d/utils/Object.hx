package love2d.utils;

/**
 * The superclass of all LÖVE types. 
 */

class Object
{
	public function new() {
		
	}
	
	/**
	 * Gets the type of the object as a string.
	 * @return The type as a string. 
	 */
	public function type():String {
		return Type.getClassName(Type.getClass(this));
	}
	
	/**
	 * Checks whether an object is of a certain type.
	 * @param name The name of the type to check for. 
	 * @return True if the object is of the specified type, false otherwise. 
	 */
	public function typeOf(name:String):Bool {
		return false;
	}
}