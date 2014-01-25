package love2d.utils;
import love2d.Handler.Color;
import love2d.Handler.Point;
import love2d.Love;
import love2d.utils.ParticleSystem.AreaSpread;
import love2d.utils.ParticleSystem.Emitter;
import love2d.utils.ParticleSystem.Particle;
import love2d.utils.ParticleSystem.Range;
import love2d.utils.ParticleSystem.SpeedRange;

class ParticleSystem extends Drawable
{
	private var _image:Image;
	private var _list:Array<Particle>;
	private var _size:Int;
	private var _emitter:Emitter;
	private var _originX:Float;
	private var _originY:Float;
	private var _counter:Float;
	private var _minLife:Float;
	private var _maxLife:Float;
	private var _minSpeed:Float;
	private var _maxSpeed:Float;
	private var _xmin:Float;
	private var _ymin:Float;
	private var _xmax:Float;
	private var _ymax:Float;
	private var _insertMode:String;
	private var _distribution:String;
	private var _dx:Float = 0;
	private var _dy:Float = 0;
	private var _rng:RandomGenerator;
	
	public function new(image:Image, buffer:Int) 
	{
		super();
		
		_image = image;
		_size = buffer;
		_originX = _image.getWidth() >> 1;
		_originY = _image.getHeight() >> 1;
		_counter = _minLife = _maxLife = _minSpeed = _maxSpeed = _xmin = _ymin = _xmax = _ymax = 0;
		_insertMode = "top";
		_distribution = "none";
		
		_list = [];
		_emitter = new Emitter();
		_rng = new RandomGenerator();
	}
	
	/*public function update(dt:Float) {
		if (_emitter.active) {
			var rate:Float = 1 / _emitter.emissionRate;
			_counter += dt;
			
			while (_counter > rate) {
				addParticle();
				_counter -= rate;
			}
			_emitter.life -= dt;
			if (_emitter.lifetime != -1 && _emitter.life < 0) stop();
		}
	}
	
	override public function draw(?x:Float, ?y:Float, ?r:Float, ?sx:Float, ?sy:Float, ?ox:Float, ?oy:Float) {
		for (p in _list) {
			p.image.draw(p.x, p.y, p.direction, 1, 1, p.originX, p.originY);
		}
	}
	
	public function start() {
		_emitter.active = true;
	}
	
	public function pause() {
		_emitter.active = false;
	}
	
	public function stop() {
		_emitter.active = false;
		_emitter.life = _emitter.lifetime;
		_counter = 0;
	}
	
	public function reset() {
		_list = [];
		_emitter.life = _emitter.lifetime;
		_counter = 0;
	}
	
	public function emit(num:Int) {
		if (!_emitter.active) return;
		
		num = Math.min(num, _size - _list.length);
		
		while (num--) addParticle();
	}
	
	public function setOffset(x:Float, y:Float) {
		for (p in _list) {
			p.originX = x;
			p.originY = y;
		}
		_originX = x; _originY = y;
	}
	
	inline public function getOffset():Point {
		return {x: _originX, y: _originY};
	}
	
	inline public function setBufferSize(size:Int) {
		_size = size;
	}
	
	inline public function getBufferSize():Int {
		return _size;
	}
	
	inline public function setImage(image:Image) {
		_image = image;
	}
	
	inline public function getImage():Image {
		return _image;
	}
	
	inline public function setPosition(x:Float, y:Float) {
		_emitter.x = x;
		_emitter.y = y;
	}
	
	inline public function getPosition():Point {
		return {x: _emitter.x, y: _emitter.y};
	}
	
	inline public function setEmitterLifetime(life:Float) {
		_emitter.lifetime = life;
		_emitter.life = life;
	}
	
	inline public function setDirection(direction:Float) {
		_emitter.direction = direction;
	}
	
	inline public function getDirection():Float {
		return _emitter.direction;
	}
	
	inline public function setEmissionRate(rate:Int) {
		if (rate < 0) flash.Lib.trace("Invalid emission rate.");
		_emitter.emissionRate = rate;
	}
	
	inline public function getEmissionRate():Int {
		return _emitter.emissionRate;
	}
	
	public function setParticleLifetime(min:Float, max:Float = null) {
		_minLife = min;
		if (max == null) max = min;
		_maxLife = max;
	}
	
	inline public function getParticleLifetime():Range {
		return {min: _minLife, max: _maxLife};
	}
	
	inline public function setSpread(spread:Float) {
		_emitter.spread = spread;
	}
	
	inline public function getSpread():Float {
		return _emitter.spread;
	}
	
	inline public function setSpeed(min:Float, max:Float) {
		_minSpeed = min;
		if (max == null) max = min;
		_maxSpeed = max;
	}
	
	inline public function getSpeed():Range {
		return {min: _minSpeed, max: _maxSpeed};
	}
	
	inline public function setLinearAcceleration(xmin:Float, ymin:Float, xmax:Float, ymax:Float) {
		_xmin = xmin; _ymin = ymin;
		_xmax = xmax; _ymax = ymax;
	}
	
	inline public function getLinearAcceleration():SpeedRange {
		return {xmin: _xmin, ymin: _ymin, xmax: _xmax, ymax: _ymax};
	}
	
	inline public function setInsertMode(mode:String) {
		_insertMode = mode;
	}
	
	inline public function getInsertMode():String {
		return _insertMode;
	}
	
	inline public function setAreaSpread(distribution:String, dx:Float, dy:Float) {
		_distribution = distribution;
		_dx = dx; _dy = dy;
	}
	
	inline public function getAreaSpread():AreaSpread {
		return {distribution: _distribution, dx: _dx, dy: _dy};
	}
	
	inline public function getCount():Int {
		return _list.length;
	}
	
	inline public function isActive():Bool {
		return _emitter.active;
	}
	
	inline public function isPaused():Bool {
		return !_emitter.active && _emitter.life < _emitter.lifetime;
	}
	
	inline public function isStopped():Bool {
		return !_emitter.active && _emitter.life >= _emitter.lifetime;
	}
	
	private function addParticle() {
		if (_list.length == _size) return;
		
		var p:Particle = new Particle(0, 0, _image);
		initParticle(p);
	}
	
	private function initParticle(p:Particle) {
		_list.push(p);
		
		var min:Float, max:Float;
		
		min = _minLife; max = _maxLife;
		
		if (min == max) p.life = min;
		else p.life = _rng.random(min, max);
		
		p.lifetime = p.life;
		p.x = _emitter.x; p.y = _emitter.y;
		
		switch(_distribution) {
			case "uniform": {
				p.x += _rng.random( -_dx, _dx);
				p.y += _rng.random( -_dy, _dy);
			}
			default: { };
		}
		
		min = _emitter.direction - _emitter.spread / 2;
		max = _emitter.direction + _emitter.spread / 2;
		p.direction = _rng.random(min, max);
		p.startX = _emitter.x;
		p.startY = _emitter.y;
		
		
	}*/
}

class Particle
{
	public var x:Float;
	public var y:Float;
	public var originX:Float;
	public var originY:Float;
	public var startX:Float;
	public var startY:Float;
	public var direction:Float;
	public var life:Float;
	public var lifetime:Float;
	public var color:Color;
	public var image:Image;
	
	public function new(_x:Float = 0, _y:Float = 0, _image:Image) {
		x = _x;
		y = _y;
		image = _image;
		originX = _image.getWidth() >> 1;
		originY = _image.getHeight() >> 1;
		_minLife = _maxLife = 0;
	}
}

class Emitter
{
	public var x:Float;
	public var y:Float;
	public var life:Float;
	public var lifetime:Float;
	public var direction:Float;
	public var emissionRate:Int;
	public var active:Bool;
	public var spread:Float;
	
	public function new() {
		x = y = life = direction = spread = 0;
		emissionRate = 1;
		lifetime = -1;
		active = true;
	}
}

typedef Range = {
	min:Float,
	max:Float
}

typedef SpeedRange = {
	xmin:Float,
	ymin:Float,
	xmax:Float,
	ymax:Float
}

typedef AreaSpread = {
	distribution:String,
	dx:Float,
	dy:Float
}