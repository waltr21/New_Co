extends Area2D

var velocity = Vector2(0,0)
var acc = 800
var size = 2
var startingVelocity = Vector2(0,0)
var damage = 10
var shooter = null
onready var collisionShape = get_node("BulletCollision")
# Called when the node enters the scene tree for the first time.
func _ready():
	collisionShape.get_shape().set_radius(size)
	pass 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.position += ((velocity + startingVelocity) * delta * acc)
	bound()

func bound():
	if(self.position.x < 0 or self.position.x > Globals.MAP_WIDTH):
		self.queue_free()
	if(self.position.y < 0 or self.position.y > Globals.MAP_HEIGHT):
		self.queue_free()	
func _draw():
	draw_circle(Vector2(0,0), size, "#FFF")
