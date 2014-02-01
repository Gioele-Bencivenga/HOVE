package love2d.utils;
import love2d.Love;

/**
 * Data representing the contents of a file. 
 */

class FileData extends Data
{
	@:allow(love2d.utils) private var _contents:String;
	@:allow(love2d.utils) private var _filename:String;
	
	public function new(contents:String, name:String, ?decoder:String = "file") 
	{
		super();
		
		if (contents == null) {
			contents = "";
			Love.newError("Content of file isn't exist.");
		}
		
		_contents = contents;
		_filename = name;
	}
	
	/**
	 * Gets the filename of the FileData. 
	 * @return	The name of the file the FileData represents. 
	 */
	public function getFilename():String {
		var a:Array<String> = _filename.split(".");
		return _filename.substring(0, _filename.length - a[a.length - 1].length - 1);
	}
	
	/**
	 * Gets the extension of the FileData. 
	 * @return	The extension of the file the FileData represents. 
	 */
	public function getExtension():String {
		var a:Array<String> = _filename.split(".");
		return a[a.length - 1];
	}
	
	override public function getString():String {
		return _contents;
	}
}