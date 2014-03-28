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
	
	public function add(quad:Quad = null, x:Float, y:Float, r:Float = 0, sx:Float = 1, sy:Float = 1, ox:Float = 0, oy:Float = 0, kx:Float = 0, ky:Float = 0):Int {
		if (_buffer.count > _size - 1) return -1;
		
		if (quad == null) _bufferRect.setTo(0, 0, _bitmapData.width, _bitmapData.height);
		else {
			var v:Viewport = quad.getViewport();
			_bufferRect.setTo(v.x, v.y, v.width, v.height);
		}
		
		return _buffer.add(x, y, r, sx, sy, ox, oy, kx, ky, _bufferRect);
	}
	
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
	
	inline public function clear() {
		_buffer.clear();
	}
	
	inline public function setColor(r:Float = 255, g:Float = 255, b:Float = 255, a:Float = 255) {
		_buffer.setColor(r / 255, g / 255, b / 255, a / 255);
	}
	
	inline public function getColor():Color {
		return _buffer.getColor();
	}
	
	inline public function setBufferSize(size:Int) {
		var d:Int = _size - size;
		if (d > 0) {
			for (i in 0...d) _buffer.remove(_buffer.count);
		}
		_size = size;
	}
	
	inline public function getBufferSize():Int {
		return _size;
	}
	
	public function setImage(image:Image) {
		// to-do: not supported yet
		if (image == null) {
			Love.newError("Image doesn't exist.");
			return;
		}
		_image = image;
		_bitmapData = image._bitmapData;
	}
	
	inline public function getImage():Image {
		return _image;
	}
	
	inline public function getCount():Int {
		return _buffer.count;
	}
	
	public function bind() {
		// to-do
	}
	
	public function unbind() {
		// to-do
	}
	
	override public function draw(?x:Float, ?y:Float, ?r:Float, ?sx:Float, ?sy:Float, ?ox:Float, ?oy:Float, ?kx:Float, ?ky:Float, ?quad:Quad = null) {
		//_buffer.draw();
	}
}