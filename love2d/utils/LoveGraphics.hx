package love2d.utils;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.BlendMode;
import flash.display.Graphics;
import flash.display.JointStyle;
import flash.display.Sprite;
import flash.geom.ColorTransform;
import flash.geom.Matrix;
import flash.geom.Rectangle;
import flash.Lib;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import love2d.Handler;
import love2d.Handler.Color;
import love2d.Love;
import openfl.Assets;
import openfl.display.Tilesheet;

/**
 * Drawing of shapes and images, management of screen geometry.
 */

class LoveGraphics
{
	private var _sprite:Sprite;
	private var _bm:Bitmap;
	@:allow(love2d) private var _mat:Matrix;
	private var _blendMode:BlendMode;
	private var _colorTransform:ColorTransform;
	private var _font:Font;
	private var _bufferRect:Rectangle;
	private var _textField:TextField;
	private var _textFormat:TextFormat;
	private var _pointSize:Float = 1;
	private var _lineWidth:Float = 1;
	private var _jointStyle:JointStyle;
	@:allow(love2d.utils.SpriteBatch) private var gr:Graphics;
	
	// params
	private var _angle:Float;
	private var _scaleX:Float;
	private var _scaleY:Float;
	private var _kx:Float;
	private var _ky:Float;
	private var _dx:Float;
	private var _dy:Float;
	
	public function new() 
	{
		_sprite = new Sprite();
		gr = _sprite.graphics;
		_bm = new Bitmap();
		_mat = new Matrix();
		_jointStyle = JointStyle.ROUND;
		_bufferRect = new Rectangle();
		_colorTransform = new ColorTransform();
		_textFormat = new TextFormat();
		
		_textField = new TextField();
		_textField.text = "";
		_textField.defaultTextFormat = _textFormat;
		_textField.embedFonts = true;
		_textField.selectable = false;
		_textField.visible = true;
		_textField.autoSize = TextFieldAutoSize.LEFT;
		
		_sprite.addChild(_bm);
		Lib.current.stage.addChild(_sprite);
	}
	
	inline public function origin() {
		_angle = 0;
		_scaleX = 1; _scaleY = 1;
		_kx = 0; _ky = 0;
		_dx = 0; _dy = 0;
	}
	
	inline public function translate(dx:Float, dy:Float) {
		_dx = dx; _dy = dy;
	}
	
	inline public function rotate(angle:Float) {
		_angle = angle;
	}
	
	inline public function scale(sx:Float, sy:Float) {
		_scaleX = sx; _scaleY = sy;
	}
	
	inline public function shear(kx:Float, ky:Float) {
		_kx = kx; _ky = ky;
	}
	
	public function push() {
	}
	
	public function pop() {
	}
	
	inline public function clear() {
		gr.clear();
		var c = Love.handler.canvas;
		c.fillRect(c.rect, 0xFF000000 | Love.handler.intBgColor);
	}
	
	public function reset() {
		setColor();
		setBackgroundColor(0, 0, 0, 255);
		setBlendMode("alpha");
		_pointSize = _lineWidth = 1;
	}
	
	inline public function setColor(?red:Int = 255, ?green:Int = 255, ?blue:Int = 255, ?alpha:Int = 255) {
		red = if (red < 0) 0 else if (red > 255) 255 else red;
		green = if (green < 0) 0 else if (green > 255) 255 else green;
		blue = if (blue < 0) 0 else if (blue > 255) 255 else blue;
		alpha = if (alpha < 0) 0 else if (alpha > 255) 255 else alpha;
		Love.handler.color = {r: red, g: green, b: blue, a: alpha};
		_colorTransform.redMultiplier = red / 255;
		_colorTransform.greenMultiplier = green / 255;
		_colorTransform.blueMultiplier = blue / 255;
		_colorTransform.alphaMultiplier = alpha / 255;
	}
	
	inline public function getColor():Color {
		return Love.handler.color;
	}
	
	inline public function setBackgroundColor(?red:Int = 255, ?green:Int = 255, ?blue:Int = 255, ?alpha:Int = 255) {
		red = if (red < 0) 0 else if (red > 255) 255 else red;
		green = if (green < 0) 0 else if (green > 255) 255 else green;
		blue = if (blue < 0) 0 else if (blue > 255) 255 else blue;
		alpha = if (alpha < 0) 0 else if (alpha > 255) 255 else alpha;
		Love.handler.bgColor = {r: red, g: green, b: blue, a: alpha};
	}
	
	inline public function getBackgroundColor():Color {
		return Love.handler.bgColor;
	}
	
	inline public function setLineWidth(width:Float) {
		_lineWidth = width;
	}
	
	inline public function getLineWidth():Float {
		return _lineWidth;
	}
	
	public function setLineJoin(join:String) {
		switch(join) {
			case "none": _jointStyle = JointStyle.ROUND;
			case "miter": _jointStyle = JointStyle.MITER;
			case "bevel": _jointStyle = JointStyle.BEVEL;
			default: return;
		}
	}
	
	public function getLineJoin():String {
		switch(_jointStyle) {
			case JointStyle.ROUND: return "none";
			case JointStyle.MITER: return "miter";
			case JointStyle.BEVEL: return "bevel";
		}
	}
	
	inline public function setPointSize(size:Float) {
		_pointSize = size;
	}
	
	inline public function getPointSize():Float {
		return _pointSize;
	}
	
	public function setFont(font:Font) {
		_font = font;
		_textFormat.font = _font.getFlashFont().fontName;
		_textFormat.size = _font.getSize();
		_textField.defaultTextFormat = _textFormat;
		#if !flash
		_textField.setTextFormat(_textFormat, 0, _textField.text.length);
		#else
		_textField.setTextFormat(_textFormat);
		#end
	}
	
	inline public function getFont():Font {
		return _font;
	}
	
	inline public function setNewFont(data:Dynamic, ?size = 12):Font {
		var f:Font = newFont(data, size);
		setFont(f);
		return f;
	}
	
	public function setBlendMode(?mode:String = "alpha") {
		switch(mode) {
			case "additive": _blendMode = BlendMode.ADD;
			case "alpha": _blendMode = BlendMode.ALPHA;
			case "subtractive": _blendMode = BlendMode.SUBTRACT;
			case "multiplicative": _blendMode = BlendMode.MULTIPLY;
		}
	}
	
	public function getBlendMode():String {
		switch(_blendMode) {
			case BlendMode.ADD: return "additive";
			case BlendMode.ALPHA, BlendMode.NORMAL: return "alpha";
			case BlendMode.SUBTRACT: return "subtractive";
			case BlendMode.MULTIPLY: return "multiplicative";
			default: return "";
		}
		return "";
	}
	
	public function rectangle(mode:String, x:Float, y:Float, width:Float, height:Float) {
		gr.clear();
		
		if (mode == "line") {
			gr.lineStyle(_lineWidth, Love.handler.intColor, Love.handler.color.a / 255);
			gr.drawRect(x, y, width, height);
		}
		else
		{
			gr.beginFill(Love.handler.intColor, Love.handler.color.a / 255);
			gr.drawRect(x, y, width, height);
			gr.endFill();
		}
		Love.handler.canvas.draw(_sprite);
	}
	
	public function circle(mode:String, x:Float, y:Float, radius:Float, ?segments:Int) {
		gr.clear();
		
		if (mode == "line") {
			gr.lineStyle(_lineWidth, Love.handler.intColor, Love.handler.color.a / 255);
			gr.drawCircle(x, y, radius);
		}
		else
		{
			gr.beginFill(Love.handler.intColor, Love.handler.color.a / 255);
			gr.drawCircle(x, y, radius);
			gr.endFill();
		}
		Love.handler.canvas.draw(_sprite);
	}
	
	public function point(x:Float, y:Float) {
		rectangle("fill", x, y, getPointSize(), getPointSize());
	}
	
	public function line(x1:Dynamic, ?y1:Float = null, ?x2:Float = null, ?y2:Float = null) {
		if (Std.is(x1, Float)) {
			
		}
		else if (Std.is(x1, Array)) {
			if (x1.length == 0) {
				flash.Lib.trace("Array is empty.");
				return;
			}
			if (x1.length % 2 != 0) x1.pop();
		}
		gr.clear();
		gr.lineStyle(_lineWidth, Love.handler.intColor, Love.handler.color.a / 255);
		if (Std.is(x1, Float)) {
			gr.moveTo(x2, y2);
			gr.lineTo(x1, y1);
		}
		else if (Std.is(x1, Array)) {
			/*var i:Int, o:Array<Float> = cast x1;
			i = 2; while (i < o.length) {
				gr.moveTo(o[i - 2], o[i - 1]);
				gr.lineTo(o[i], o[i + 1]);
				i += 2;
			}*/
		}
		Love.handler.canvas.draw(_sprite);
	}
	
	public function arc(mode:String, x:Float, y:Float, radius:Float, angle1:Float, angle2:Float, ?segments:Float = 10) {
	}
	
	public function polygon(mode:String, vertices:Array<Handler.Point>) {
		gr.clear();
		if (mode == "fill") {
			gr.beginFill(Love.handler.intColor, Love.handler.color.a / 255);
		}
		else
		{
			gr.lineStyle(_lineWidth, Love.handler.intColor, Love.handler.color.a / 255);
		}
		gr.moveTo(vertices[0].x, vertices[0].y);
		for (i in 1...vertices.length) gr.lineTo(vertices[i].x, vertices[i].y);
		gr.lineTo(vertices[0].x, vertices[0].y);
		gr.endFill();
		Love.handler.canvas.draw(_sprite);
	}
	
	public function draw(drawable:love2d.utils.Drawable, ?x:Float = 0, ?y:Float = 0, ?r:Float = 0, ?sx:Float = 1, ?sy:Float = 1, ?ox:Float = 0, ?oy:Float = 0, ?quad:Quad = null) {
		drawable.draw(x, y, r, sx, sy, ox, oy, quad);
	}
	
	public function bitmap(bd:BitmapData, x:Float = 0, y:Float = 0, ?scaleX:Float = 1, ?scaleY:Float = 1, ?angle:Float = 0, ?originX:Float = 0, ?originY:Float = 0, ?quad:Quad = null) {
		gr.clear();
		_mat.identity();
		_mat.translate( -originX, -originY);
		if (quad != null) {
			_mat.translate(-quad._x, -quad._y);
		} else if (angle != 0) _mat.rotate(angle);
		_mat.scale(scaleX, scaleY);
		_mat.translate(x, y);
		_colorTransform.redMultiplier = Love.handler.color.r / 255;
		_colorTransform.greenMultiplier = Love.handler.color.g / 255;
		_colorTransform.blueMultiplier = Love.handler.color.b / 255;
		_colorTransform.alphaMultiplier = Love.handler.color.a / 255;
		if (quad != null) {
			_bufferRect.x = x + ( - originX) * scaleX;
			_bufferRect.y = y + ( - originY) * scaleY;
			_bufferRect.width = quad._width * scaleX;
			_bufferRect.height = quad._height * scaleY;
			Love.handler.canvas.draw(bd, _mat, _colorTransform, _blendMode, _bufferRect, false);
		}
		else {
			_bufferRect.setEmpty();
			Love.handler.canvas.draw(bd, _mat, _colorTransform, _blendMode);
		}
	}
	
	public function print(text:String, x:Float = 0, y:Float = 0, ?r:Float = 0, ?sx:Float = 1, ?sy:Float = 1, ?ox:Float = 0, ?oy:Float = 0) {
		_textField.textColor = Love.handler.intColor;
		_textField.visible = true;
		_textField.text = text;
		_textField.x = _textField.y = 0;
		_mat.identity();
		_mat.translate(-ox * sx, -oy * sy);
		_mat.scale(sx, sy);
		if (r != 0) _mat.rotate(r);
		_mat.translate(x + ox * sx, y + oy * sy);
	//	_textField.x = x; _textField.y = y;
	//	_textField.rotation = r;
	//	_textField.scaleX = sx; _textField.scaleY = sy;
		Love.handler.canvas.draw(_textField, _mat);
	}
	
	public function printf(text:String, x:Float = 0, y:Float = 0, limit:Int, ?align:String = "left", ?r:Float = 0, ?sx:Float = 1, ?sy:Float = 1, ?ox:Float = 0, ?oy:Float = 0) {
		_textField.textColor = Love.handler.intColor;
		_textField.visible = true;
		_textField.width = limit;
		_textField.text = text;
		_textField.x = x; _textField.y = y;
		_textField.rotation = r;
		_textField.scaleX = sx; _textField.scaleY = sy;
		
		_textFormat.align = switch(align) {
			case "left": TextFormatAlign.LEFT;
			case "right": TextFormatAlign.RIGHT;
			case "center": TextFormatAlign.CENTER;
			case "justify": TextFormatAlign.JUSTIFY;
			default: TextFormatAlign.LEFT;
		}
	}
	
	// constructors
	
	/**
	 * Creates a new Image from a filepath, File or an ImageData. 
	 * @param	data Data.
	 * @return An Image object which can be drawn on screen. 
	 */
	public function newImage(data:Dynamic):Image {
		return new Image(data);
	}
	
	/**
	 * Creates a new Font. 
	 * @param	data Data.
	 * @param	?size = 12 The size of the font in pixels. 
	 * @return A Font object which can be used to draw text on screen. 
	 */
	public function newFont(data:Dynamic, ?size = 12):Font {
		return new Font(data, size);
	}
	
	/**
	 * Creates a new SpriteBatch object.
	 * @param	image The Image to use for the sprites.
	 * @param	?size The max number of sprites.
	 * @param	?usageHint The expected usage of the SpriteBatch.
	 * @return The new SpriteBatch. 
	 */
	public function newSpriteBatch(image:Image, ?size:Int = 1000, ?usageHint:String = "dynamic"):SpriteBatch {
		return new SpriteBatch(image, size, usageHint);
	}
	
	/**
	 * Creates a new Quad. 
	 * @param	x The top-left position along the x-axis. 
	 * @param	y The top-left position along the y-axis. 
	 * @param	width The width of the Quad. (Must be greater than 0.) 
	 * @param	height The height of the Quad. (Must be greater than 0.) 
	 * @param	sx The reference width, the width of the Image. (Must be greater than 0.) 
	 * @param	sy The reference height, the height of the Image. (Must be greater than 0.) 
	 * @return The new Quad. 
	 */
	public function newQuad(x:Float = 0, y:Float = 0, width:Int = 1, height:Int = 1, sx:Int, sy:Int):Quad {
		return new Quad(x, y, width, height, sx, sy);
	}
}