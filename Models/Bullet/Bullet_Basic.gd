extends Area2D

var velocity = Vector2(0,0)
var acc = 1000
var size = 4
var startingVelocity = Vector2(0,0)
var damage = 10
var shooter = null
onready var collisionShape = get_node("BulletCollision")
var colors = [
    "#FF0000",  # Red
    "#FFA500",  # Orange
    "#FFFF00",  # Yellow
    "#00FF00",  # Lime
    "#00FFFF",  # Cyan
    "#0000FF",  # Blue
    "#8A2BE2",  # BlueViolet
    "#FF00FF",  # Magenta
    "#FF1493",  # DeepPink
    "#FFD700",  # Gold
    "#32CD32",  # LimeGreen
    "#FF4500",  # OrangeRed
    "#00FF7F",  # SpringGreen
    "#FF69B4",  # HotPink
    "#00BFFF"   # DeepSkyBlue
]
var color = ""
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	collisionShape.get_shape().set_radius(size)
#	color = colors[rng.randi_range(0,colors.size() - 1)]
	color = colors[0]
	pass 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.position += ((velocity + startingVelocity) * delta * acc)
	bound()

func hit():
	self.queue_free()
	var dText = load("res://Models/Bullet/DamageText.tscn").instance()
	dText.rect_position = self.position
	dText.text = str(self.damage / 1)
	Globals.Main_Scene.add_child(dText)

func bound():
	if(self.position.x < 0 or self.position.x > Globals.MAP_WIDTH):
		self.queue_free()
	if(self.position.y < 0 or self.position.y > Globals.MAP_HEIGHT):
		self.queue_free()

func _draw():
	draw_line(velocity * -30, Vector2(0,0), color, 3)
	#draw_circle(Vector2(0,0), size, "#FFF")
