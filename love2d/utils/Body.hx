package love2d.utils;
import love2d.Love;
#if nape
import nape.geom.Vec2;
#if (nape_hacks)
import nape.hacks.ForcedSleep;
#end
import nape.phys.BodyType;

/**
 * Bodies are objects with velocity and position. 
 */

class Body extends Object
{
	@:allow(love2d.utils) private var _body:nape.phys.Body;
	@:allow(love2d.utils) private var _type:String;
	@:allow(love2d.utils) private var _world:World;
	@:allow(love2d.utils) private var _fixtureList:Array<Fixture>;
	private var _isSleeping:Bool;
	private var _isSleepingAllowed:Bool;
	
	public function new(world:World, ?x:Float = 0, ?y:Float = 0, type:String = "static") 
	{
		super();
		
		_type = type;
		_world = world;
		_fixtureList = [];
		_isSleeping = false;
		_isSleepingAllowed = true;
		
		_body = new nape.phys.Body(getNapeType(type), Vec2.weak(x, y));
		if (type != "static") _body.space = world._space;
		_body.allowRotation = true;
	}
	
	/**
	 * Apply force to a Body. 
	 * @param	fx	The x component of force to apply to the center of mass. 
	 * @param	fy	The y component of force to apply to the center of mass. 
	 */
	inline public function applyForce(fx:Float, fy:Float) {
		_body.force = Vec2.weak(fx, fy);
	}
	
	/**
	 * Sets a new body type. 
	 * @param	type	The new type. 
	 */
	inline public function setType(type:String) {
		_body.type = getNapeType(type);
	}
	
	/**
	 * Returns the type of the body. 
	 * @return	The body type. 
	 */
	inline public function getType():String {
		return _type;
	}
	
	/**
	 * Set the x position of the body. 
	 * @param	x	The x position. 
	 */
	inline public function setX(x:Float) {
		_body.position.x = x;
	}
	
	/**
	 * Set the y position of the body. 
	 * @param	y	The y position. 
	 */
	inline public function setY(y:Float) {
		_body.position.y = y;
	}
	
	/**
	 * Set the position of the body. 
	 * @param	x	The x position. 
	 * @param	y	The y position. 
	 */
	inline public function setPosition(x:Float, y:Float) {
		_body.position.setxy(x, y);
	}
	
	/**
	 * Get the x position of the body in world coordinates. 
	 * @return	The x position in world coordinates. 
	 */
	inline public function getX():Float {
		return _body.position.x;
	}
	
	/**
	 * Get the y position of the body in world coordinates. 
	 * @return	The y position in world coordinates. 
	 */
	inline public function getY():Float {
		return _body.position.y;
	}
	
	/**
	 * Get the position of the body. 
	 * @return The position of the body.
	 */
	inline public function getPosition():Vec2 {
		return _body.position;
	}
	
	/**
	 * Sets a new body mass. 
	 * @param	mass	The mass, in kilograms. 
	 */
	inline public function setMass(mass:Float) {
		_body.mass = mass;
	}
	
	/**
	 * Get the mass of the body. 
	 * @return	The mass of the body (in kilograms). 
	 */
	inline public function getMass():Float {
		return _body.mass;
	}
	
	/**
	 * Set the angle of the body. 
	 * @param	angle	The angle in radians. 
	 */
	inline public function setAngle(angle:Float) {
		_body.rotation = angle;
	}
	
	/**
	 * Get the angle of the body. 
	 * @return	The angle in radians. 
	 */
	inline public function getAngle():Float {
		return _body.rotation;
	}
	
	/**
	 * Set the inertia of a body. 
	 * @param	inertia		The new moment of inertia, in kilograms per meter squared. 
	 */
	inline public function setInertia(inertia:Float) {
		_body.inertia = inertia;
	}
	
	/**
	 * Gets the rotational inertia of the body. 
	 * @return	The rotational inertial of the body. 
	 */
	inline public function getInertia():Float {
		return _body.inertia;
	}
	
	/**
	 * Set the bullet status of a body. 
	 * @param	status	The bullet status of the body. 
	 */
	inline public function setBullet(status:Bool) {
		_body.isBullet = status;
	}
	
	/**
	 * Get the bullet status of a body. 
	 * @return	The bullet status of the body. 
	 */
	inline public function isBullet():Bool {
		return _body.isBullet;
	}
	
	/**
	 * Set whether a body has fixed rotation. 
	 * @param	isFixed		Whether the body should have fixed rotation. 
	 */
	inline public function setFixedRotation(isFixed:Bool) {
		_body.allowRotation = !isFixed;
	}
	
	/**
	 * Returns whether the body rotation is locked. 
	 * @return	True if the body's rotation is locked or false if not. 
	 */
	inline public function isFixedRotation():Bool {
		return !_body.allowRotation;
	}
	
	/**
	 * Sets whether the body is active in the world. 
	 * @param	active	If the body is active or not. 
	 */
	inline public function setActive(active:Bool) {
		_body.allowMovement = active;
	}
	
	/**
	 * Returns whether the body is actively used in the simulation. 
	 * @return	True if the body is active or false if not. 
	 */
	inline public function isActive():Bool {
		return _body.allowMovement;
	}
	
	/**
	 * Sets a new linear velocity for the Body. 
	 * @param	x	The x-component of the velocity vector. 
	 * @param	y	The y-component of the velocity vector. 
	 */
	inline public function setLinearVelocity(x:Float, y:Float) {
		_body.velocity.setxy(x, y);
	}
	
	/**
	 * Gets the linear velocity of the Body from its center of mass. 
	 * @return	The velocity vector.
	 */
	inline public function getLinearVelocity():Vec2 {
		return _body.velocity;
	}
	
	/**
	 * Sets the angular velocity of a Body. 
	 * @param	w	The new angular velocity, in radians per second 
	 */
	inline public function setAngularVelocity(w:Float) {
		_body.angularVel = w;
	}
	
	/**
	 * Get the angular velocity of the Body. 
	 * @return	The angular velocity in radians/second. 
	 */
	inline public function getAngularVelocity():Float {
		return _body.angularVel;
	}
	
	/**
	 * Returns a table with all fixtures. 
	 * @return	An array with all fixtures. 
	 */
	inline public function getFixtureList():Array<Fixture> {
		return _fixtureList;
	}
	
	/**
	 * Wakes the body up or puts it to sleep. 
	 * @param	awake	The body sleep status. 
	 */
	inline public function setAwake(awake:Bool) {
		#if (nape_hacks)
		if (_isSleepingAllowed) {
			ForcedSleep.sleepBody(_body);
			_isSleeping = true;
		}
		#else
		Love.newError("Library nape-hacks is not installed!");
		#end
	}
	
	/**
	 * Returns the sleep status of the body. 
	 * @return	True if the body is awake or false if not. 
	 */
	inline public function isAwake():Bool {
		return _isSleeping;
	}
	
	/**
	 * Sets the sleeping behaviour of the body. 
	 * @param	allowed		True if the body is allowed to sleep or false if not. 
	 */
	inline public function setSleepingAllowed(allowed:Bool) {
		_isSleepingAllowed = true;
	}
	
	/**
	 * Returns the sleeping behaviour of the body. 
	 * @return	True if the body is allowed to sleep or false if not. 
	 */
	inline public function isSleepingAllowed():Bool {
		return _isSleepingAllowed;
	}
	
	private function getNapeType(type:String):BodyType {
		return switch(type) {
			case "static": BodyType.STATIC;
			case "kinematic": BodyType.KINEMATIC;
			case "dynamic": BodyType.DYNAMIC;
			default: BodyType.DYNAMIC;
		}
	}
}
#else
class Body {}
#end