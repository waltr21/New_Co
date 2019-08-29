extends Area2D

var baseSize = 25
var level = 3
var acc = 200 * (1/(level*1.0))
var velocity = Vector2(0,0)
var dead = false
var basePush = 40
var damage = 10
var animateSize = 1
var astColor = "FFF"
var spawnedChild = false
var shards = []
onready var collisionShape = get_node("AsteroidCollision")

func _ready():
	var shape = CircleShape2D.new()
	shape.set_radius(baseSize * level)
	self.collisionShape.shape = shape
	setVelocity(rand_range(0, 2*PI))

func setVelocity(r):
	randomize()
	self.rotation = r
	velocity = Vector2(cos(self.rotation), sin(self.rotation))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	travel(delta)
	bound()
	die()
	growAndShrink(delta)
	update()

func setLevel(l):
	self.level = l
	acc = 200 * (1/(self.level*1.0))
	
func travel(d):
	self.position += velocity * d * acc

func bound():
	var contact = self.position
	var out = false
	
	if(self.position.x - (self.baseSize * level) <= 0):
		contact.x *= 2
		out = true
	if(self.position.y - (self.baseSize * level) <= 0):
		contact.y *= 2
		out = true
	if(self.position.y + (self.baseSize * level) > Globals.MAP_HEIGHT):
		contact.y *= -2
		out = true
	if(self.position.x + (self.baseSize * level) > Globals.MAP_WIDTH):
		contact.x *= -2
		out = true
	
	if (out):
		var tempRotation = contact.angle_to_point(self.position)
		var tempVelocity = Vector2(cos(tempRotation), sin(tempRotation)) 
		self.push(tempVelocity)

func push(v):
	self.velocity += v
	
	if(self.velocity.x > 1):
		self.velocity.x = 1
	if(self.velocity.x < -1):
		self.velocity.x = -1
	if(self.velocity.y > 1):
		self.velocity.y = 1
	if(self.velocity.y < -1):
		self.velocity.y = -1

func die():
	if (dead == true):
		if(level > 1 and !spawnedChild):
			var newAst1 = load("res://Models/Asteroid/AsteroidBasic/Asteroid_Basic.tscn").instance()
			var newAst2 = load("res://Models/Asteroid/AsteroidBasic/Asteroid_Basic.tscn").instance()
			newAst1.position = Vector2(self.position.x, self.position.y)
			newAst2.position = Vector2(self.position.x, self.position.y)
			newAst1.setLevel(level - 1)
			newAst2.setLevel(level - 1)
			Globals.Main_Scene.add_child(newAst1)
			Globals.Main_Scene.add_child(newAst2)
			spawnedChild = true

func show():
	draw_circle(Vector2(0,0), animateSize, astColor)
	draw_circle(Vector2(0,0), animateSize - 2, "#000")

func _draw():
	show()

func growAndShrink(d):
	if(!dead):
		if(animateSize < (baseSize * level)):
			var rate = 40 * level
			animateSize += rate * d
	else:
		self.queue_free()

func pushPlayer(obj=null):
	if(obj != null):
		var tempRotation = obj.position.angle_to_point(self.position)
		var tempVelocity = Vector2(cos(tempRotation), sin(tempRotation)) * (basePush * damage)
		obj.push(tempVelocity, self)
		obj.get_node("ShipCamera").startShake(3.0)

func addShards():
	var angle = 0
	randomize()
	var numShards = int(rand_range(4,10))
	for i in range(numShards):
		var tempShard = load("res://Models/Asteroid/AsteroidBasic/AsteroidShard.tscn").instance()
		tempShard.position = self.position
		tempShard.radius = self.baseSize * level
		tempShard.angleFrom = angle
		angle += 2*PI / (numShards*1.0)
		tempShard.angleTo = angle
		tempShard.setColor(astColor)
		Globals.Main_Scene.add_child(tempShard)

func processEnter(obj):
	if(!dead):
		if("Bullet" in obj.filename):
			#Kill Bullet
			obj.queue_free()
			self.addShards()
			self.dead = true
		elif("Ship" in obj.filename):
			pushPlayer(obj)

#Collision detection
func _on_Ast_area_entered(obj):
	processEnter(obj)
