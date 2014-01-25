package love2d.utils;

/**
 * 	Provides an interface to output sound to the user's speakers.
 */

class LoveAudio
{
	@:allow(love2d.utils) private var _sources:Array<Source>;
	private var _volume:Float = 1;
	
	public function new()
	{
		_sources = [];
	}
	
	/**
	 * Sets the master volume. 
	 * @param	volume	1.0f is max and 0.0f is off. 
	 */
	inline public function setVolume(volume:Float) {
		_volume = volume;
	}
	
	/**
	 * Returns the master volume. 
	 * @return	The current master volume 
	 */
	inline public function getVolume():Float {
		return _volume;
	}
	
	/**
	 * Gets the current number of simultaneously playing sources. 
	 * @return	The current number of simultaneously playing sources. 
	 */
	public function getSourceCount():Int {
		var r:Int = 0;
		for (v in _sources) {
			if (v.isPlaying()) r++;
		}
		return r;
	}
	
	/**
	 * Plays the specified Source. 
	 * @param	?source		The Source to play. 
	 */
	public function play(?source:Source = null) {
		if (source != null) source.play();
	}
	
	/**
	 * Pauses all audio. 
	 * @param	?source		The source on which to pause the playback 
	 */
	public function pause(?source:Source = null) {
		if (source != null) source.pause();
		else for (v in _sources) v.pause();
	}
	
	/**
	 * Stops all playing audio. 
	 * @param	?source		The source on which to stop the playback 
	 */
	public function stop(?source:Source = null) {
		if (source != null) source.stop();
		else for (v in _sources) v.stop();
	}
	
	/**
	 * Resumes all audio. 
	 * @param	?source		The source on which to resume the playback. 
	 */
	public function resume(?source:Source = null) {
		if (source != null) source.resume();
		else for (v in _sources) v.resume();
	}
	
	// constructors
	
	/**
	 * Creates a new Source from a filepath, File, Decoder or SoundData.
	 * @param	data	Data.
	 * @param	?sourceType	Streaming or static source. 
	 * @return	A new Source that can play the specified audio. 
	 */
	public function newSource(data:Dynamic, ?sourceType:String):Source {
		return new Source(data, sourceType);
	}
}