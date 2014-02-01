package love2d.utils;
#if nape
import nape.geom.Vec2;
import nape.space.Space;

/**
 * A world is an object that contains all bodies and joints. 
 */

class World extends Object
{
	@:allow(love2d.utils) private var _space:Space;
	private var _beginContact:Fixture->Fixture->Contact;
	private var _endContact:Fixture->Fixture->Contact;
	private var _preSolve:Fixture->Fixture->Contact;
	private var _postSolve:Fixture->Fixture->Contact;
	
	public function new(?xg:Float = 0, ?yg:Float = 0, ?sleep:Bool = true) 
	{
		super();
		_space = new Space(Vec2.weak(xg, yg));
	}
	
	/**
	 * Set the gravity of the world. 
	 * @param	x	The x component of gravity. 
	 * @param	y	The y component of gravity. 
	 */
	inline public function setGravity(x:Float, y:Float) {
		_space.gravity = Vec2.weak(x, y);
	}
	
	/**
	 * Get the gravity of the world. 
	 * @return	An point.
	 */
	inline public function getGravity():Vec2 {
		return _space.gravity;
	}
	
	/**
	 * Update the state of the world. 
	 * @param	dt	The time (in seconds) to advance the physics simulation. 
	 */
	inline public function update(dt:Float) {
		_space.step(dt);
	}
	
	/**
	 * Sets functions for the collision callbacks during the world update. 
	 * @param	beginContact	Gets called when two fixtures begin to overlap. 
	 * @param	endContact	Gets called when two fixtures cease to overlap. This will also be called outside of a world update, when colliding objects are destroyed. 
	 * @param	preSolve	Gets called before a collision gets resolved. 
	 * @param	postSolve	Gets called after the collision has been resolved. 
	 */
	public function setCallbacks(beginContact:Fixture->Fixture->Contact, endContact:Fixture->Fixture->Contact, preSolve:Fixture->Fixture->Contact, postSolve:Fixture->Fixture->Contact) {
		if (beginContact != null) _beginContact = beginContact;
		if (endContact != null) _endContact = endContact;
		if (preSolve != null) _preSolve = preSolve;
		if (postSolve != null) _postSolve = postSolve;
	}
	
	/**
	 * Returns functions for the callbacks during the world update. 
	 * @return	The callbacks list.
	 */
	public function getCallbacks():CallbackList {
		return {beginContact: _beginContact, endContact: _endContact, preSolve: _preSolve, postSolve: _postSolve};
	}
}

typedef CallbackList = {
	beginContact:Fixture->Fixture->Contact,
	endContact:Fixture->Fixture->Contact,
	preSolve:Fixture->Fixture->Contact,
	postSolve:Fixture->Fixture->Contact
}
#else
class World {}
#end