package love2d.utils;
import love2d.Love;
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
	#if android
	public function new() {}
	#else
	private var _userDirectory:String;
	private var _workingDirectory:String;
	private var _appDataDirectory:String;
	private var _initialDirectory:String;
	private var _saveDirectory:String;
	private var _identity:String;
	
	public function new() 
	{
		init();
	}
	
	/**
	 * Initializes love.filesystem, will be called internally, so should not be used explicitly. 
	 */
	public function init() {
		#if (cpp || neko)
		_initialDirectory = StringTools.replace(Sys.environment().get("APPDATA"), "\\", "/");
		_appDataDirectory = _initialDirectory;
		_initialDirectory += "/HOVE/";
		if (!FileSystem.exists(_initialDirectory)) FileSystem.createDirectory(_initialDirectory);
		_saveDirectory = _initialDirectory + _identity;
		
		_userDirectory = StringTools.replace(Sys.environment().get("USERPROFILE") + "/", "\\", "/");
		_workingDirectory = StringTools.replace(Sys.getCwd() + "/", "\\", "/");

		setIdentity("hove");
		#end
	}
	
	/**
	 * Gets the full path to the designated save directory.
	 * @return	The absolute path to the save directory. 
	 */
	public function getSaveDirectory():String {
		#if (cpp || neko)
		return _saveDirectory;
		#end
		return "unknown";
	}
	
	/**
	 * Returns the application data directory
	 * @return	The path of the application data directory 
	 */
	public function getAppdataDirectory():String {
		#if (cpp || neko)
		return _appDataDirectory;
		#end
		return "unknown";
	}
	
	/**
	 * Returns the path of the user's directory 
	 * @return	The path of the user's directory 
	 */
	public function getUserDirectory():String {
		#if (cpp || neko)
		return _userDirectory;
		#end
		return "unknown";
	}
	
	/**
	 * Gets the current working directory. 
	 * @return	The current working directory. 
	 */
	public function getWorkingDirectory():String {
		#if (cpp || neko)
		return _workingDirectory;
		#end
		return "unknown";
	}
	
	/**
	 * Sets the write directory for your game.
	 * @param	name	The new identity that will be used as write directory 
	 */
	public function setIdentity(name:String) {
		#if (cpp || neko)
		if (name != null) {
			_identity = name;
			if (!FileSystem.exists(_initialDirectory + _identity)) FileSystem.createDirectory(_initialDirectory + _identity);
			_saveDirectory = _initialDirectory + _identity;
		}
		#end
	}
	
	/**
	 * Gets the write directory name for your game.
	 * @return	The identity that is used as write directory. 
	 */
	public function getIdentity():String {
		#if (cpp || neko)
		return _identity;
		#end
		return "unknown";
	}
	
	/**
	 * Check whether a file or directory exists. 
	 * @param	filename	The path to a potential file or directory. 
	 * @return	True if there is a file or directory with the specified name. False otherwise. 
	 */
	public function exists(filename:String):Bool {
		#if (cpp || neko)
		return FileSystem.exists(_saveDirectory + "/" + filename);
		#end
		return false;
	}
	
	/**
	 * Check whether something is a directory. 
	 * @param	filename	The path to a potential directory. 
	 * @return	True if there is a directory with the specified name. False otherwise. 
	 */
	public function isDirectory(filename:String):Bool {
		#if (cpp || neko)
		if (!FileSystem.exists(_saveDirectory + "/" + filename)) {
			Love.newError("Directory doesn't exist");
			return false;
		}
		return FileSystem.isDirectory(_saveDirectory + "/" + filename);
		#end
		return false;
	}
	
	/**
	 * Check whether something is a file. 
	 * @param	filename	The path to a potential file. 
	 * @return	True if there is a file with the specified name. False otherwise. 
	 */
	public function isFile(filename:String):Bool {
		#if (cpp || neko)
		if (!FileSystem.exists(_saveDirectory + "/" + filename)) {
			Love.newError("File doesn't exist");
			return false;
		}
		return !FileSystem.isDirectory(_saveDirectory + "/" + filename);
		#end
		return false;
	}
	
	/**
	 * Recursively creates a directory. 
	 * @param	name	The directory to create.
	 * @return	True if the directory was created, false if not. 
	 */
	public function createDirectory(name:String):Bool {
		#if (cpp || neko)
		FileSystem.createDirectory(_saveDirectory + "/" + name);
		return FileSystem.exists(_saveDirectory + "/" + name);
		#end
		return false;
	}
	
	/**
	 * Returns a table with the names of files and subdirectories in the specified path.
	 * @param	?dir	The directory. 
	 * @return	A table with the names of all files and subdirectories as strings. 
	 */
	public function getDirectoryItems(?dir:String = ""):Array<String> {
		#if (cpp || neko)
		return FileSystem.readDirectory(_saveDirectory + "/" + dir);
		#end
		return null;
	}
	
	/**
	 * Read the contents of a file 
	 * @param	name	The name (and path) of the file 
	 * @param	?size	How many bytes to read 
	 * @return	The file contents 
	 */
	public function read(name:String, ?size:Int = -1):String {
		#if (cpp || neko)
		if (FileSystem.exists(_saveDirectory + "/" + name)) return File.getContent(_saveDirectory + "/" + name);
		else {
			Love.newError("File is not exists.");
			return "unknown";
		}
		#end
		return "unknown";
	}
	
	/**
	 * Write data to a file in the save directory.
	 * @param	name	The name (and path) of the file.
	 * @param	data	The string data to write to the file. 
	 * @param	?size	How many bytes to write. 
	 * @return	If the operation was successful. 
	 */
	public function write(name:String, data:String, ?size:Int = -1):Bool {
		#if (cpp || neko)
		File.saveContent(_saveDirectory + "/" + name, data);
		return true;
		#end
		return false;
	}
	
	/**
	 * Gets the size in bytes of a file. 
	 * @param	filename	The path and name to a file. 
	 * @return	The size in bytes of the file, or 0 on failure. 
	 */
	public function getSize(filename:String):Int {
		#if (cpp || neko)
		if (!FileSystem.exists(_saveDirectory + "/" + filename)) {
			Love.newError("File doesn't exist");
			return 0;
		}
		return FileSystem.stat(_saveDirectory + "/" + filename).size;
		#end
		return 0;
	}
	
	/**
	 * Gets the last modification time of a file. 
	 * @param	filename	The path and name to a file. 
	 * @return	The last modification time in seconds since the unix epoch or "" on failure. 
	 */
	public function getLastModified(filename:String):String {
		#if (cpp || neko)
		if (!FileSystem.exists(_saveDirectory + "/" + filename)) {
			Love.newError("File doesn't exist");
			return "";
		}
		var d:Date = FileSystem.stat(_saveDirectory + "/" + filename).mtime;
		return (d.getMonth() + 1) + "/" + d.getDate() + "/" + d.getFullYear() + " " + d.getHours() + ":" + d.getMinutes() + ":" + d.getSeconds();
		#end
		return "";
	}
	
	/**
	 * Removes a file or empty directory. 
	 * @param	filename	The file or directory to remove. 
	 * @return	True if the file/directory was removed, false otherwise. 
	 */
	public function remove(filename:String):Bool {
		#if (cpp || neko)
		if (!FileSystem.exists(_saveDirectory + "/" + filename)) {
			Love.newError("File or directory doesn't exist");
			return false;
		}
		if (FileSystem.isDirectory(_saveDirectory + "/" + filename)) FileSystem.deleteDirectory(_saveDirectory + "/" + filename);
		else FileSystem.deleteFile(_saveDirectory + "/" + filename);
		#end
		return false;
	}
	
	/**
	 * Gets whether the game is in fused mode or not. 
	 * @return	True if the game is in fused mode, false otherwise. 
	 */
	public function isFused():Bool {
		#if (cpp || neko)
		return _identity == "";
		#end
		return false;
	}
	
	// constructors
	
	/**
	 * Creates a new FileData object. 
	 * @param	contents	The contents of the file. 
	 * @param	name	The name of the file. 
	 * @param	?decoder	The method to use when decoding the contents. 
	 * @return	Your new FileData. 
	 */
	public function newFileData(contents:String, name:String, ?decoder:String = "file"):FileData {
		#if (cpp || neko)
		return new FileData(contents, name, decoder);
		#end
		return null;
	}
	
	/**
	 * Creates a new File object.
	 * @param	filename	The filename of the file. 
	 * @param	?mode	The mode to open the file in. 
	 * @return	The new File object. 
	 */
	public function newFile(filename:String, ?mode:String = null):love2d.utils.File {
		#if (cpp || neko)
		return new love2d.utils.File(filename, mode);
		#end
		return null;
	}
	#end
}