extends Node2D

var allShards = []
var stars = []
var globalDelta = 0
var numStars = 0
var starColor = Color("#b3fff1")
onready var ship = load("res://Models/Ship/Ship.tscn").instance()

# Called when the node enters the scene tree for the first time.
func _ready():
	#VisualServer.set_default_clear_color(Color(0,0,0))
	#populateBackground()
	Globals.Main_Scene = self
	Globals.players.push_front(ship)
	Globals.Main_Scene.add_child(ship)
	initShards()

func initShards():
	for i in range(100):
		var tempShard = load("res://Models/Asteroid/AsteroidBasic/AsteroidShard.tscn").instance()
		allShards.push_front(tempShard)
		tempShard.visible = false
		Globals.Main_Scene.add_child(tempShard)

func populateBackground():
	for i in range(3000):
		stars.push_front(Star.new(starColor))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#Draw every frame.
	globalDelta = delta
	#update()
	pass

func _draw():
	#Draw borders
	draw_line(Vector2(0,0), Vector2(Globals.MAP_WIDTH, 0), "#91fbff", 4.0)
	draw_line(Vector2(Globals.MAP_WIDTH,0), Vector2(Globals.MAP_WIDTH, Globals.MAP_HEIGHT), "#91fbff", 4.0)
	draw_line(Vector2(Globals.MAP_WIDTH,Globals.MAP_HEIGHT), Vector2(0, Globals.MAP_HEIGHT), "#91fbff", 4.0)
	draw_line(Vector2(0,Globals.MAP_HEIGHT), Vector2(0, 0), "#91fbff", 4.0)
	#Draw star background
	for i in range(stars.size()):
		#Only draw in range of the acitve camera.
		if (abs(stars[i].pos.x - ship.position.x) <= Globals.CAM_WIDTH && abs(stars[i].pos.y - ship.position.y) <= Globals.CAM_HEIGHT):
			stars[i].adjustSize(globalDelta)
			draw_circle(stars[i].pos, stars[i].size, stars[i].starColor)

#Object to hold star info.
class Star:
	var pos = Vector2(0,0)
	var starColor = Color(0,0,0)
	var size = 0
	var increase = true
	
	func _init(c):
		randomize()
		pos = Vector2(rand_range(0,Globals.MAP_WIDTH), rand_range(0,Globals.MAP_HEIGHT))
		starColor = c
		size = rand_range(0.8, 2.0)
	
	func adjustSize(delta):
		if(size >= 3.0):
			increase = false
		if(size <= 0.8):
			increase = true
		if(increase):
			size += 1 * delta
		else:
			size -= 1 * delta
			