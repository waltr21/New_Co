extends "res://Models/Asteroid/AsteroidBasic/Asteroid_Basic.gd"

var stamp = OS.get_ticks_msec()
var increaseRate = 20
var numChildren = 20

func _ready():
	self.level = 1
	self.baseSize = 10
	self.health = 100
	self.damage = 50
	self.acc = 100
	self.aPoints = 500
	astColor = "#ff0000"
	setShape()

func _process(delta):
	explode(delta)
	setShape()

func setShape():
	if(OS.get_ticks_msec() - stamp > 100):
		var shape = CircleShape2D.new()
		shape.set_radius(baseSize * level)
		self.collisionShape.shape = shape

func travel(d):
	if(OS.get_ticks_msec() - stamp > 500):
		stamp = OS.get_ticks_msec()
		self.rotation = Globals.players[0].position.angle_to_point(self.position)
		velocity = Vector2(cos(self.rotation), sin(self.rotation))
	self.position += velocity * d * acc

func explode(d):
	if(baseSize < 150):
		baseSize += increaseRate * d
	else:
		spawnChildren()
		self.queue_free()

func spawnChildren():
	var r = 0
	for i in range(numChildren):
		var ast = load("res://Models/Asteroid/AsteroidBasic/Asteroid_Basic.tscn").instance()
		ast.setLevel(1)
		ast.acc *= 1.5
		ast.position = self.position
		Globals.Main_Scene.add_child(ast)
		ast.setVelocity(r)
		r += (2*PI) / (numChildren*1.0)