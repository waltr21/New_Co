extends "res://Models/Asteroid/AsteroidBasic/Asteroid_Basic.gd"

var pulseRate = 10
var increase = false
var pulseSize = 1
var children = []
var stamp = OS.get_ticks_msec()
var spawnRate = 5000

func _ready():
	self.level = 1
	var shape = CircleShape2D.new()
	self.astColor = Color(1,0.2,1)
	self.health = 100
	shape.set_radius(baseSize * 4)
	self.collisionShape.shape = shape
	randomize()
	self.dead = false
	self.rotation = rand_range(0, 2*PI)
	self.damage = 20
	velocity = Vector2(0,0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	adjustPulse(delta)
	spawnChild()
	update()

func adjustPulse(d):
	if(pulseSize < 2):
		increase = true 
	if(pulseSize > 20):
		increase = false
	
	if(increase):
		pulseSize += pulseRate * d
	else:
		pulseSize -= pulseRate * d
	
func spawnChild():
	if(OS.get_ticks_msec() - stamp > spawnRate):
		stamp = OS.get_ticks_msec()
		var newAst1 = load("res://Models/Asteroid/AsteroidDuplicate/Asteroid_Duplicate.tscn").instance()
		newAst1.position = Vector2(self.position.x, self.position.y)
		newAst1.setLevel(level)
		children.push_front(newAst1)
		newAst1.mother = self
		Globals.Main_Scene.add_child(newAst1)

func addChild(ast):
	children.push_front(ast)

func die():
	#print(children.size())
	if (dead == true):
		dead = false
		for ast in children:
			if(ast != null):
				ast.kill = true
		queue_free()

func freeChild(selfAst):
	children.erase(selfAst)

func show():
	draw_circle(Vector2(0,0), baseSize * level, astColor)
	draw_circle(Vector2(0,0), (baseSize * level) - pulseSize, "#000")

