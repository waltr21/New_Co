extends "res://Models/Asteroid/AsteroidBasic/Asteroid_Basic.gd"

var colorRate = 0.1
var colorG = 0.0
var increase = false
var kill = false
var mother = null

func _ready():
	self.level = 2
	var shape = CircleShape2D.new()
	self.astColor = Color(1,1,1) * 0.1
	shape.set_radius(baseSize * level)
	self.collisionShape.shape = shape
	randomize()
	self.rotation = rand_range(0, 2*PI)
	velocity = Vector2(cos(self.rotation), sin(self.rotation))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	adjustColor(delta)
	kill()
	update()

func adjustColor(d):
	if(colorG < 0):
		increase = true 
	if(colorG > 1.2):
		increase = false
	
	if(increase):
		colorG += colorRate * d
	else:
		colorG -= colorRate * d

	astColor = Color(1,colorG,1)
	pass

func kill():
	if (kill):
		self.addShards()
		self.queue_free()


func die():
	if (dead == true):
		dead = false
		Globals.Main_Scene.add_child(duplicateSelf())
		Globals.Main_Scene.add_child(duplicateSelf())
		self.mother.freeChild(self)
		queue_free()

func duplicateSelf():
	var newAst1 = load("res://Models/Asteroid/AsteroidDuplicate/Asteroid_Duplicate.tscn").instance()
	newAst1.position = Vector2(self.position.x, self.position.y)
	newAst1.setLevel(level)
	newAst1.mother = self.mother
	mother.addChild(newAst1)
	return newAst1
