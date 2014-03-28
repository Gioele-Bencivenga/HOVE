package love2d.utils;
import dust.Color;
import dust.Tilebuffer;
import flash.display.BitmapData;
import flash.geom.Rectangle;
import love2d.Handler.Viewport;
import love2d.Love;

class SpriteBatch extends Drawable
{
	private var _image:Image;
	private var _bitmapData:BitmapData;
	private var _size:Int;
	private var _usagehint:String;
	@:allow(love2d) private var _buffer:Tilebuffer;
	private var _bufferRect:Rectangle;
	
	public function new(image:Image, size:Int = 1000, usagehint:String = "dynamic") {
		if (image == null) {
			Love.newError("Image doesn't exist.");
			return null;
		}
		super();
		_image = image;
		_bitmapData = image._bitmapData;
		_usagehint = usagehint;
		_size = size;
		_bufferRect = new Rectangle();
		
		_buffer = new Tilebuffer(_bitmapData);
		_buffer.targetBitmapData = Love.handler.canvas;
		Love.graphics._dust.add(_buffer);
	}
	
	/**
	 * Adds a sprite to the batch. 
	 * @param	quad	The Quad to add. 
	 * @param	x	The position to draw the object (x-axis). 
	 * @param	y	The position to draw the object (y-axis). 
	 * @param	r	Orientation (radians). 
	 * @param	sx	Scale factor (x-axis). 
	 * @param	sy	Scale factor (y-axis). 
	 * @param	ox	Origin offset (x-axis). 
	 * @param	oy	Origin offset (y-axis). 
	 * @param	kx	Shear factor (x-axis). 
	 * @param	ky	Shear factor (y-axis). 
	 * @return	An identifier for the added sprite. 
	 */
	public function add(quad:Quad = null, x:Float, y:Float, r:Float = 0, sx:Float = 1, sy:Float = 1, ox:Float = 0, oy:Float = 0, kx:Float = 0, ky:Float = 0):Int {
		if (_buffer.count > _size - 1) return -1;
		
		if (quad == null) _bufferRect.setTo(0, 0, _bitmapData.width, _bitmapData.height);
		else {
			var v:Viewport = quad.getViewport();
			_bufferRect.setTo(v.x, v.y, v.width, v.height);
		}
		
		return _buffer.add(x, y, r, sx, sy, ox, oy, kx, ky, _bufferRect);
	}
	
	/**
	 * 
	 * @param	id
	 * @param	quad
	 * @param	x
	 * @param	y
	 * @param	r
	 * @param	sx
	 * @param	sy
	 * @param	ox
	 * @param	oy
	 * @param	kx
	 * @param	ky
	 */
	public function set(id:Int, quad:Quad = null, x:Float, y:Float, r:Float = 0, sx:Float = 1, sy:Float = 1, ox:Float = 0, oy:Float = 0, kx:Float = 0, ky:Float = 0) {
		if (quad == null) _bufferRect.setTo(0, 0, _bitmapData.width, _bitmapData.height);
		else {
			var v:Viewport = quad.getViewport();
			_bufferRect.setTo(v.x, v.y, v.width, v.height);
		}
		
		var result = _buffer.set(id, x, y, r, sx, sy, ox, oy, kx, ky, _bufferRect);
		if (!result) {
			Love.newError("Provided id is out of range.");
			return;
		}
	}
	
	/**
	 * Removes all sprites from the buffer. 
	 */
	inline public function clear() {
		_buffer.clear();
	}
	
	/**
	 * Sets the color that will be used for the next add and set operations.
	 * @param	r	The amount of red. 
	 * @param	g	The amount of green. 
	 * @param	b	The amount of blue. 
	 * @param	a	The amount of alpha. 
	 */
	inline public function setColor(r:Float = 255, g:Float = 255, b:Float = 255, a:Float = 255) {
		_buffer.setColor(r / 255, g / 255, b / 255, a / 255);
	}
	
	/**
	 * Gets the color that will be used for the next add and set operations. 
	 * @return	The color components.
	 */
	inline public function getColor():Color {
		return _buffer.getColor();
	}
	
	/**
	 * Sets the maximum number of sprites the SpriteBatch can hold.
	 * @param	size	The new maximum number of sprites the batch can hold. 
	 */
	inline public function setBufferSize(size:Int) {
		_size = size;
	}
	
	/**
	 * Gets the maximum number of sprites the SpriteBatch can hold. 
	 * @return	The maximum number of sprites the batch can hold. 
	 */
	inline public function getBufferSize():Int {
		return _size;
	}
	
	/**
	 * Replaces the image used for the sprites. 
	 * @param	image	The new Image to use for the sprites. 
	 */
	public function setImage(image:Image) {
		// to-do: not supported yet
		if (image == null) {
			Love.newError("Image doesn't exist.");
			return;
		}
		_image = image;
		_bitmapData = image._bitmapData;
	}
	
	/**
	 * Returns the image used by the SpriteBatch. 
	 * @return	The image for the sprites. 
	 */
	inline public function getImage():Image {
		return _image;
	}
	
	/**
	 * Gets the number of sprites currently in the SpriteBatch. 
	 * @return	The number of sprites currently in the batch. 
	 */
	inline public function getCount():Int {
		return _buffer.count;
	}
	
	/**
	 * Binds the SpriteBatch to memory for more efficient updating. 
	 */
	public function bind() {
		// to-do
	}
	
	/**
	 * Unbinds the SpriteBatch. 
	 */
	public function unbind() {
		// to-do
	}
	
	override public function draw(?x:Float, ?y:Float, ?r:Float, ?sx:Float, ?sy:Float, ?ox:Float, ?oy:Float, ?kx:Float, ?ky:Float, ?quad:Quad = null) {
	}
}