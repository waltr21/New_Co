extends "res://Models/Asteroid/AsteroidBasic/Asteroid_Basic.gd"

var stamp = OS.get_ticks_msec()

func _ready():
	self.level = 1
	self.baseSize = 15
	self.damage = 10
	self.acc = 0
	astColor = "#eb7e50"
	var shape = CircleShape2D.new()
	shape.set_radius(baseSize * level)
	self.collisionShape.shape = shape

func _process(delta):
	checkDead()
	pass

func checkDead():
	if(OS.get_ticks_msec() - stamp > 3000):
		dead = true

func processEnter(obj):
	if("Bullet" in obj.filename):
		#Kill Bullet
		obj.queue_free()
	elif("Ship" in obj.filename):
		pushPlayer(obj)