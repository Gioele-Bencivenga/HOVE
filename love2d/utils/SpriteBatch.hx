package love2d.utils;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.geom.ColorTransform;
import flash.geom.Rectangle;
import flash.Lib;
import haxe.ds.ObjectMap;
import love2d.Love;
import love2d.Handler.FloatColor;
import love2d.utils.SpriteBatch.RenderItem;
import love2d.utils.SpriteBatch.TilesheetExt;
import openfl.display.Tilesheet;

/**
 * Using a single image, draw any number of identical copies of the image using a single call to love.graphics.draw().
 * This can be used, for example, to draw repeating copies of a single background image with high performance. 
 */

class SpriteBatch extends Drawable
{
	// TODO: need something to do with object disposing
	// There is no way to do it right now
	
	private var _image:Image;
	private var _size:Int;
	private var _usageHint:String;
	private var _color:FloatColor;
	
	private var _tilesheet:TilesheetExt;
	private var _imageQuad:Quad;
	
	private static var RenderItemPool:Array<RenderItem> = [];
	
	private var _renderItems:Array<RenderItem>;
	
	private var _currentRenderItem:RenderItem;
	
	private var _numQuads:Int = 0;
	
	public function new(image:Image, ?size:Int = 1000, ?usageHint:String = "dynamic") 
	{
		super();
		setImage(image);
		_size = size;
		_usageHint = usageHint;
		
		_color = { r: 1, g: 1, b: 1, a: 1 };
		
		_imageQuad = new Quad(0, 0, image.getWidth(), image.getHeight());
		
		_renderItems = [];
	}
	
	/**
	 * Sets the color that will be used for the next add and set operations.
	 * @param	r	The amount of red. 
	 * @param	g	The amount of green. 
	 * @param	b	The amount of blue. 
	 * @param	?a	The amount of alpha. 
	 */
	inline public function setColor(r:Float, g:Float, b:Float, ?a:Float = 255) {
		_color = {r: r / 255, g: g / 255, b: b / 255, a: a / 255};
	}
	
	/**
	 * Gets the color that will be used for the next add and set operations. 
	 * @return The table that contains color.
	 */
	inline public function getColor():FloatColor {
		return {r: Math.round(_color.r * 255), g: Math.round(_color.g * 255), b: Math.round(_color.b * 255), a: Math.round(_color.a * 255)};
	}
	
	/**
	 * Removes all sprites from the buffer. 
	 */
	inline public function clear() {
		_numQuads = 0;
		
		var l:Int = _renderItems.length;
		var item:RenderItem;
		
		for (i in 0...l)
		{
			item = _renderItems.pop();
			item.clear();
			RenderItemPool.push(item);
		}
	}
	
	inline private static function getRenderItem():RenderItem
	{
		return (RenderItemPool.length > 0) ? RenderItemPool.pop() : new RenderItem();
	}
	
	inline private function isColored():Bool
	{
		return (_color.r != 1 || _color.g != 1 || _color.b != 1);
	}
	
	inline private function isAlpha():Bool
	{
		return (_color.a != 1);
	}
	
	/**
	 * Adds a sprite to the batch. 
	 * @param	quad	The Quad to add. 
	 * @param	x	The position to draw the object (x-axis). 
	 * @param	y	The position to draw the object (y-axis). 
	 * @param	?r	Orientation (radians). 
	 * @param	?sx	Scale factor (x-axis). 
	 * @param	?sy	Scale factor (y-axis). 
	 * @param	?ox	Origin offset (x-axis). 
	 * @param	?oy	Origin offset (y-axis). 
	 * @param	?kx	Shear factor (x-axis). 
	 * @param	?ky	Shear factor (y-axis). 
	 */
	public function add(quad:Quad = null, x:Float = 0, y:Float = 0, r:Float = 0, sx:Float = 1, sy:Float = 1, ox:Float = 0, oy:Float = 0, kx:Float = 0, ky:Float = 0) {
		
		if (_numQuads >= _size) return;
		
		if (quad == null)	quad = _imageQuad;
		
		var colored:Bool = isColored();
		var alpha:Bool = isAlpha();
		
		if (_currentRenderItem == null || (_currentRenderItem.isAlpha != alpha || _currentRenderItem.isColored != colored || _currentRenderItem.tilesheet != _tilesheet))
		{
			_currentRenderItem = getRenderItem();
			_currentRenderItem.isColored = colored;
			_currentRenderItem.isAlpha = alpha;
			
			if (colored && alpha)
			{
				_currentRenderItem.numElementsPerQuad = RenderItem.NUM_ELEMENTS_RGB_ALPHA;
			}
			else if (colored && !alpha)
			{
				_currentRenderItem.numElementsPerQuad = RenderItem.NUM_ELEMENTS_RGB;
			}
			else if (!colored && alpha)
			{
				_currentRenderItem.numElementsPerQuad = RenderItem.NUM_ELEMENTS_ALPHA;
			}
			else
			{
				_currentRenderItem.numElementsPerQuad = RenderItem.NUM_ELEMENTS_NO_RGB_ALPHA;
			}
			
			_currentRenderItem.tilesheet = _tilesheet;
			_renderItems.push(_currentRenderItem);
		}
		
		var csx:Float = 1;
		var ssy:Float = 0;
		var ssx:Float = 0;
		var csy:Float = 1;
		
		var sin:Float = 0;
		var cos:Float = 1;
		
		var x1:Float = (ox - quad._halfWidth) * sx;
		var y1:Float = (oy - quad._halfHeight) * sy;
		
		var x2:Float = x1;
		var y2:Float = y1;
		
		if (r != 0)
		{
			sin = Math.sin(r);
			cos = Math.cos(r);
			
			csx = cos * sx;
			ssy = sin * sy;
			ssx = sin * sx;
			csy = cos * sy;
			
			x2 = x1 * cos + y1 * sin;
			y2 = -x1 * sin + y1 * cos;
		}
		
		// transformation matrix coefficients
		var a:Float = csx;
		var b:Float = ssx;
		var c:Float = ssy;
		var d:Float = csy;
		
		var list:Array<Float> = _currentRenderItem.renderList;
		
		var currIndex = list.length;
		
		list[currIndex++] = x - x2;
		list[currIndex++] = y - y2;
		
		list[currIndex++] = _tilesheet.addTileRectID(quad);
		
		list[currIndex++] = a;
		list[currIndex++] = -b;
		list[currIndex++] = c;
		list[currIndex++] = d;
		
		if (_currentRenderItem.isColored)
		{
			list[currIndex++] = _color.r;
			list[currIndex++] = _color.g;
			list[currIndex++] = _color.b;
		}
		
		if (_currentRenderItem.isAlpha)
			list[currIndex++] = _color.a;
		
		_currentRenderItem.numQuads++;
		_numQuads++;
	}
	
	/**
	 * Changes a sprite in the batch.
	 * @param	id	The identifier of the sprite that will be changed. 
	 * @param	x	The position to draw the object (x-axis). 
	 * @param	y	The position to draw the object (y-axis). 
	 * @param	?r	Orientation (radians). 
	 * @param	?sx	Scale factor (x-axis). 
	 * @param	?sy	Scale factor (y-axis). 
	 * @param	?ox	Origin offset (x-axis). 
	 * @param	?oy	Origin offset (y-axis). 
	 * @param	?kx	Shear factor (x-axis). 
	 * @param	?ky	Shear factor (y-axis). 
	 * @param	?quad	The Quad used on the image of the batch. 
	 */
	public function set(id:Int, x:Float, y:Float, ?r:Float = 0, ?sx:Float = 1, ?sy:Float = 1, ?ox:Float = 0, ?oy:Float = 0, ?kx:Float = 0, ?ky:Float = 0, ?quad:Quad = null) {
		
		if (id < _numQuads && id >= 0) {
			if (quad == null)	quad = _imageQuad;
		
			var csx:Float = 1;
			var ssy:Float = 0;
			var ssx:Float = 0;
			var csy:Float = 1;
			
			var x1:Float = (ox - quad._halfWidth) * sx;
			var y1:Float = (oy - quad._halfHeight) * sy;
			
			var sin:Float = Math.sin(r);
			var cos:Float = Math.cos(r);
			
			csx = cos * sx;
			ssy = sin * sy;
			ssx = sin * sx;
			csy = cos * sy;
			
			var x2:Float = x1 * cos + y1 * sin;
			var y2:Float = -x1 * sin + y1 * cos;
			
			// transformation matrix coefficients
			var a:Float = csx;
			var b:Float = ssx;
			var c:Float = ssy;
			var d:Float = csy;
			
			var colored:Bool = isColored();
			var alpha:Bool = isAlpha();
			
			var l:Int = _renderItems.length;
			var renderItem:RenderItem = null;
			var totalItems:Int = 0;
			var prevNumber:Int = 0;
			
			var renderItemID:Int = -1;
			
			for (i in 0...l)
			{
				renderItem = _renderItems[i];
				var numQuadsInItem:Int = renderItem.numQuads;
				prevNumber = totalItems;
				totalItems += numQuadsInItem;
				if (totalItems > id)
				{
					renderItemID = id - prevNumber;
					break;
				}
			}
			
			if (renderItemID == -1) return;
			
			var list:Array<Float> = renderItem.renderList;
			var currIndex = renderItemID * renderItem.numElementsPerQuad;
			
			list[currIndex++] = x - x2;
			list[currIndex++] = y - y2;
			
			list[currIndex++] = _tilesheet.addTileRectID(quad);
			
			list[currIndex++] = a;
			list[currIndex++] = -b;
			list[currIndex++] = c;
			list[currIndex++] = d;
			
			if (renderItem.isColored)
			{
				list[currIndex++] = _color.r;
				list[currIndex++] = _color.g;
				list[currIndex++] = _color.b;
			}
			
			if (renderItem.isAlpha)
				list[currIndex++] = _color.a;
			
			}
	}
	
	/**
	 * Sets the maximum number of sprites the SpriteBatch can hold.
	 * @param	size	The new maximum number of sprites the batch can hold. 
	 */
	inline public function setBufferSize(size:Int) {
		if (_numQuads < size) {
			var prevNum:Int = 0;
			var totalNum:Int = 0;
			var item:RenderItem;
			var itemSize:Int = 0;
			var l:Int = _renderItems.length;
			
			for (i in 0...l)
			{
				item = _renderItems[i];
				prevNum = totalNum;
				itemSize = item.numQuads;
				totalNum += itemSize;
				
				if (totalNum > size)
				{
					var start:Int = (size - prevNum) * item.numElementsPerQuad;
					item.renderList.splice(start, item.renderList.length - start);
					item.numQuads = size - prevNum;
					for (j in (i + 1)...l)
					{
						item = _renderItems.pop();
						item.clear();
						RenderItemPool.push(item);
					}
					
					break;
				}
			}
		}
		_size = size;
	}
	
	override public function draw(?x:Float, ?y:Float, ?r:Float, ?sx:Float, ?sy:Float, ?ox:Float, ?oy:Float, ?kx:Float, ?ky:Float, ?quad:Quad) {
		var flags:Int;
		var item:RenderItem;
		var l:Int = _renderItems.length;
		
		for (i in 0...l)
		{
			item = _renderItems[i];
			flags = Tilesheet.TILE_TRANS_2x2;
			if (item.isColored)
			{
				flags |= Tilesheet.TILE_RGB;
			}
			else if (item.isAlpha)
			{
				flags |= Tilesheet.TILE_ALPHA;
			}
			item.tilesheet.drawTiles(Love.graphics.gr, item.renderList, false, flags);
		}
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
	inline public function setImage(image:Image) {
		_image = image;
		_tilesheet = TilesheetCache.get(image);
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
		return _numQuads;
	}
	
	inline private function getTilesheet():TilesheetExt
	{
		if (_tilesheet == null) _tilesheet = TilesheetCache.get(_image);
		return _tilesheet;
	}
	
	inline private function numQuads():Int
	{
		var l:Int = _renderItems.length;
		var renderItem:RenderItem = null;
		var totalItems:Int = 0;
		
		for (i in 0...l)
		{
			renderItem = _renderItems[i];
			totalItems += renderItem.numQuads;
		}
		
		return totalItems;
	}
	
	/**
	 * Binds the SpriteBatch to memory for more efficient updating. 
	 */
	public function bind() {
	}
	
	/**
	 * Unbinds the SpriteBatch. 
	 */
	public function unbind() {
	}
}

class TilesheetCache
{
	public static var cache:ObjectMap<Image, TilesheetExt> = new ObjectMap<Image, TilesheetExt>();
	
	public static function get(image:Image):TilesheetExt
	{
		if (cache.exists(image))
		{
			return cache.get(image);
		}
		
		var tilesheet:TilesheetExt = new TilesheetExt(image._bitmapData);
		cache.set(image, tilesheet);
		return tilesheet;
	}
}

class TilesheetExt extends Tilesheet
{
	private var tileIDs:ObjectMap<Quad, Int>;
	
	private var _numTiles:Int = 0;
	
	public function new(image:BitmapData)
	{
		super(image);
		tileIDs = new ObjectMap<Quad, Int>();
	}
	
	public function destroy():Void
	{
		tileIDs = null;
	}
	
	public function addTileRectID(quad:Quad):Int
	{
		if (tileIDs.exists(quad))
			return tileIDs.get(quad);
		#if (!flash && !js)
		var id:Int = _numTiles;
		addTileRect(new Rectangle(quad._x, quad._y, quad._width, quad._height));
		#else
		var id:Int = addTileRect(new Rectangle(quad._x, quad._y, quad._width, quad._height));
		#end
		tileIDs.set(quad, id);
		_numTiles++;
		return id;
	}
}

class RenderItem
{
	public var tilesheet:TilesheetExt;
	public var isColored:Bool;
	public var isAlpha:Bool;
	public var renderList:Array<Float>;
	
	public var numQuads:Int = 0;
	
	public var numElementsPerQuad:Int = 0;
	
	public static var NUM_ELEMENTS_RGB_ALPHA:Int = 11;
	public static var NUM_ELEMENTS_RGB:Int = 10;
	public static var NUM_ELEMENTS_ALPHA:Int = 8;
	public static var NUM_ELEMENTS_NO_RGB_ALPHA:Int = 7;
	
	public function new()
	{
		renderList = [];
	}
	
	public function clear():Void
	{
		renderList.splice(0, renderList.length);
		numQuads = 0;
	}
}