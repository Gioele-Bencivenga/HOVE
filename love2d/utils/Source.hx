package love2d.utils;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundTransform;
import love2d.Handler.Range;
import love2d.Love;
import openfl.Assets;

/**
 * A Source represents audio you can play back.
 */

class Source extends Object
{
	private var _sound:Sound;
	private var _channel:SoundChannel;
	private var _type:String;
	private var _volumeMin:Float = 0;
	private var _volumeMax:Float = 1;
	private var _position:Float = 0;
	private var _paused:Bool = false;
	private var _playing:Bool = false;
	private var _stopped:Bool = false;
	private var _looping:Bool = false;
	
	public function new(data:Dynamic, ?sourceType:String = "stream") 
	{
		super();
		// to-do: File, Decoder, SoundData
		if (Std.is(data, String)) {
			_sound = Assets.getSound(data);
		}
		_type = sourceType;
		Love.audio._sources.push(this);
		setVolume(Love.audio.getVolume());
	}
	
	/**
	 * Starts playing the Source. 
	 */
	public function play() {
		_channel = _sound.play(0, (_looping)?10000:0);
		setVolume(getVolume());
		_playing = true;
		_paused = false;
		_stopped = false;
	}
	
	/**
	 * Stops a Source. 
	 */
	public function stop() {
		_channel.stop();
		_stopped = true;
		_playing = false;
		_paused = false;
	}
	
	/**
	 * Pauses the Source. 
	 */
	public function pause() {
		_position = _channel.position;
		_channel.stop();
		_paused = true;
		_playing = false;
		_stopped = false;
	}
	
	/**
	 * Resumes a paused Source. 
	 */
	public function resume() {
		if (_paused) {
			_channel = _sound.play(_position, (_looping)?10000:0);
			setVolume(getVolume());
			_playing = true;
			_paused = false;
			_stopped = false;
		}
	}
	
	/**
	 * Sets whether the Source should loop. 
	 * @param	looping		True if the source should loop, false otherwise. 
	 */
	inline public function setLooping(looping:Bool) {
		_looping = true;
	}
	
	/**
	 * Sets the currently playing position of the Source. 
	 * @param	offset	The position to seek to. 
	 * @param	?unit	The unit of the position value. 
	 */
	inline public function seek(offset:Float, ?unit:String = "seconds") {
		if (unit == "seconds") _position = offset;
	}
	
	/**
	 * Gets the currently playing position of the Source. 
	 * @param	unit	The type of unit for the return value. 
	 * @return	The currently playing position of the Source. 
	 */
	inline public function tell(unit:String = "seconds"):Int {
		if (unit == "seconds") return Std.int(_position / 1000);
		return 0;
	}
	
	/**
	 * Returns whether the Source is playing. 
	 * @return	True if the Source is playing, false otherwise. 
	 */
	inline public function isPlaying():Bool {
		return _playing;
	}
	
	/**
	 * Returns whether the Source is paused. 
	 * @return	True if the Source is paused, false otherwise. 
	 */
	inline public function isPaused():Bool {
		return _paused;
	}
	
	/**
	 * Returns whether the Source is stopped. 
	 * @return	True if the Source is stopped, false otherwise. 
	 */
	inline public function isStopped():Bool {
		return _stopped;
	}
	
	/**
	 * Returns whether the Source will loop. 
	 * @return	True if the Source will loop, false otherwise. 
	 */
	inline public function isLooping():Bool {
		return _looping;
	}
	
	/**
	 * Returns whether the Source is static. 
	 * @return	True if the Source is static, false otherwise. 
	 */
	inline public function isStatic():Bool {
		return _type == "static";
	}
	
	/**
	 * Sets the volume limits of the source. The limits have to be numbers from 0 to 1. 
	 * @param	min		The minimum volume. 
	 * @param	max		The maximum volume. 
	 */
	public function setVolumeLimits(min:Float = 0, max:Float = 0) {
		min = (min < 0)?0:min;
		min = (min > 1)?1:min;
		max = (max < 0)?0:max;
		max = (max > 1)?1:max;
		max = (max < min)?min:max;
		_volumeMin = min; _volumeMax = max;
	}
	
	/**
	 * Returns the volume limits of the source. 
	 * @return	The minimum volume, the maximum volume.
	 */
	inline public function getVolumeLimits():Range {
		return {min: _volumeMin, max: _volumeMax};
	}
	
	/**
	 * Sets the current volume of the Source. 
	 * @param	?volume		The volume for a Source, where 1.0 is normal volume. Volume cannot be raised above 1.0. 
	 */
	public function setVolume(?volume:Float = null) {
		if (volume == null) volume = Love.audio.getVolume();
		volume = (volume < _volumeMin)?_volumeMin:volume;
		volume = (volume > _volumeMax)?_volumeMax:volume;
		_channel.soundTransform.volume = volume;
	}
	
	/**
	 * Gets the current volume of the Source. 
	 * @return	The volume of the Source, where 1.0 is normal volume. 
	 */
	inline public function getVolume():Float {
		return _channel.soundTransform.volume;
	}
}