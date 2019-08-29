extends "res://Models/Asteroid/AsteroidBasic/Asteroid_Basic.gd"

var stamp = OS.get_ticks_msec()
var mother = null

func _ready():
	self.level = 1
	self.baseSize = 10
	self.acc = 300
	self.damage = 3
	self.astColor = "#fff81f"
	var shape = CircleShape2D.new()
	shape.set_radius(baseSize * level)
	self.collisionShape.shape = shape

func travel(d):
	if(OS.get_ticks_msec() - stamp > 500):
		stamp = OS.get_ticks_msec()
		self.rotation = Globals.players[0].position.angle_to_point(self.position)
		self.rotation += rand_range(-PI/8, PI/8)
		velocity = Vector2(cos(self.rotation), sin(self.rotation))
	self.position += velocity * d * acc

func die():
	if (dead == true):
		dead = false
		if (mother != null):
			self.mother.freeChild(self)
		queue_free()
