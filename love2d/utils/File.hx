package love2d.utils;
import love2d.Love;

/**
 * Represents a file on the filesystem. 
 */

class File extends Object
{
	private var _mode:String;
	private var _filename:String;
	
	public function new(filename:String, ?mode:String = null) 
	{
		super();
		
		_mode = "c";
		if (!Love.filesystem.exists(filename)) Love.filesystem.write(filename, "");
		
		if (mode == "r" || mode == "w" || mode == "a") _mode = mode;
		else {
			if (mode != null) Love.newError("Wrong FileMode.");
		}
		_filename = filename;
	}
	
	/**
	 * Gets the FileMode the file has been opened with. 
	 * @return	The mode this file has been opened with. 
	 */
	inline public function getMode():String {
		return _mode;
	}
	
	/**
	 * Returns the file size 
	 * @return	The file size 
	 */
	inline public function getSize():Int {
		return Love.filesystem.getSize(_filename);
	}
	
	/**
	 * Gets whether the file is open. 
	 * @return	True if the file is currently open, false otherwise. 
	 */
	inline public function isOpen():Bool {
		return _mode != "c";
	}
	
	/**
	 * Open the file for write, read or append. 
	 * @param	mode	The mode to open the file in. 
	 * @return	True on success, false otherwise. 
	 */
	public function open(mode:String):Bool {
		if (!isOpen()) {
			if (mode == "r" || mode == "w" || mode == "a") _mode = mode;
			else {
				if (mode != null) {
					Love.newError("Wrong FileMode.");
					return false;
				}
			}
			return true;
		}
		Love.newError("The file is already opened");
		return false;
	}
	
	/**
	 * Closes a file 
	 * @return	     Whether closing was successful 
	 */
	public function close():Bool {
		if (_mode == "c") return false;
		_mode = "c";
		return true;
	}
}