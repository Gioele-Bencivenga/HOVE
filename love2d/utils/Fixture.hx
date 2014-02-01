package love2d.utils;
#if nape

/**
 * Fixtures attach shapes to bodies. 
 */

class Fixture extends Object
{
	private var _body:Body;
	private var _shape:Shape<Dynamic>;
	private var _userData:Dynamic;
	
	public function new(body:Body, shape:Shape<Dynamic>, ?density:Float = 1) 
	{
		super();
		
		_body = body;
		_shape = shape;
		_userData = "";
		
		body._body.shapes.add(shape._shape);
		if (body._type == "static") body._body.space = body._world._space;
		else {
			if (Reflect.hasField(shape, "_angle")) body._body.rotation = Reflect.getProperty(shape, "_angle");
		}
		body._fixtureList.push(this);
	}
	
	/**
	 * Returns the body to which the fixture is attached. 
	 * @return	The parent body. 
	 */
	public function getBody():Body {
		return _body;
	}
	
	/**
	 * Returns the shape of the fixture.
	 * @return	The fixture's shape. 
	 */
	public function getShape():Shape<Dynamic> {
		return _shape;
	}
	
	/**
	 * Associates a Haxe value with the fixture. 
	 * @param	value	The Haxe value to associate with the fixture. 
	 */
	public function setUserData(value:Dynamic) {
		_userData = value;
	}
	
	/**
	 * Returns the Haxe value associated with this fixture. 
	 * @return	The Haxe value associated with the fixture. 
	 */
	public function getUserData():Dynamic {
		return _userData;
	}
}
#else
class Fixture {}
#end