package love2d.utils;
#if (!flash && !js)
import sys.FileSystem;
import sys.io.File;
import sys.FileStat;
#end

/**
 * Provides an interface to the user's filesystem.
 */

class LoveFilesystem
{
	public function new() 
	{
		init();
	}
	
	/**
	 * Initializes love.filesystem, will be called internally, so should not be used explicitly. 
	 */
	public function init() {
	}
	
	/**
	 * Check whether a file or directory exists. 
	 * @param	filename	The path to a potential file or directory. 
	 * @return	True if there is a file or directory with the specified name. False otherwise. 
	 */
	inline public function exists(filename:String):Bool {
		#if (!flash && !js)
		return FileSystem.exists(filename);
		#else
		return false;
		#end
	}
	
	/**
	 * Removes a file or empty directory. 
	 * @param	name	The file or directory to remove. 
	 * @return	True if the file/directory was removed, false otherwise. 
	 */
	public function remove(name:String):Bool {
		#if (!flash && !js)
		FileSystem.deleteFile(name);
		return !FileSystem.exists(name);
		#else
		return false;
		#end
	}
	
	/**
	 * Read the contents of a file 
	 * @param	name	The name (and path) of the file 
	 * @param	?size	How many bytes to read 
	 * @return	The file contents 
	 */
	public function read(name:String, ?size:Int = -1):String {
		#if (!flash && !js)
		if (FileSystem.exists(name)) return File.getContent(name);
		else return "File doesn't exist.";
		#else
			#if flash
			return "You can't access files while targeting Flash.";
			#elseif js
			return "You can't access files while targeting JS.";
			#end
			return "";
		#end
	}
	
	/**
	 * Write data to a file in the save directory.
	 * @param	name	The name (and path) of the file. 
	 * @param	data	The string data to write to the file. 
	 * @param	?size	How many bytes to write.
	 * @return	If the operation was successful. 
	 */
	public function write(name:String, data:String, ?size:Int = -1):Bool {
		#if (!flash && !js)
		File.saveContent(name, data);
		return true;
		#else
		return false;
		#end
	}
	
	/**
	 * Recursively creates a directory. Not really. (yet!) When called with "a/b" it creates both "a" and "a/b", if they don't exist already. 
	 * @param	name	The directory to create. 
	 * @return	True if the directory was created, false if not. 
	 */
	public function createDirectory(name:String):Bool {
		#if (!flash && !js)
		FileSystem.createDirectory(name);
		return FileSystem.exists(name);
		#else
		return false;
		#end
	}
	
	/**
	 * Check whether something is a directory. 
	 * @param	filename	The path to a potential directory. 
	 * @return	True if there is a directory with the specified name. False otherwise. 
	 */
	public function isDirectory(filename:String):Bool {
		#if (!flash && !js)
		return FileSystem.isDirectory(filename);
		#else
		return false;
		#end
	}
	
	/**
	 * Gets the last modification time of a file. 
	 * @param	filename	The path and name to a file. 
	 * @return	The last modification time in seconds since the unix epoch or nil on failure. 
	 */
	public function getLastModified(filename:String):Date {
		#if (!flash && !js)
		return FileSystem.stat(filename).mtime;
		#else
		return null;
		#end
	}
}