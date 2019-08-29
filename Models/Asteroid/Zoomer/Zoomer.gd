extends "res://Models/Asteroid/AsteroidBasic/Asteroid_Basic.gd"

var stamp = OS.get_ticks_msec()

func _ready():
	self.level = 1
	self.baseSize = 40
	self.damage = 20
	self.acc = 700
	astColor = "#eb7e50"
	var shape = CircleShape2D.new()
	shape.set_radius(baseSize * level)
	self.collisionShape.shape = shape

func _process(delta):
	if( OS.get_ticks_msec() - stamp > 500):
		stamp = OS.get_ticks_msec()
		spawnParticle()

func spawnParticle():
	var newParticle = load("res://Models/Asteroid/Zoomer/ZoomerParticle.tscn").instance()
	newParticle.position = Vector2(self.position.x, self.position.y)
	Globals.Main_Scene.add_child(newParticle)