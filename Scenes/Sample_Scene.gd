extends Node2D

var allShards = []
var globalDelta = 0
onready var ship = load("res://Models/Ship/Ship.tscn").instance()
var stamp = 0
var waveTimeMs = 60 * 1000.0
var curWave = 0

var spawnStamp = 0
var allAsteroids = []
var MAX_ASTEROIDS = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	#VisualServer.set_default_clear_color(Color(0,0,0))
	Globals.Main_Scene = self
	Globals.players.push_front(ship)
	Globals.Main_Scene.add_child(ship)
	ship.position = Vector2(Globals.MAP_WIDTH / 2, Globals.MAP_HEIGHT / 2)
	initShards()
	stamp = OS.get_ticks_msec()

func initShards():
	for i in range(100):
		var tempShard = load("res://Models/Asteroid/AsteroidBasic/AsteroidShard.tscn").instance()
		allShards.push_front(tempShard)
		tempShard.visible = false
		Globals.Main_Scene.add_child(tempShard)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	globalDelta = delta
	makeWave()
	pass

func makeWave():
	var timeElapsed = OS.get_ticks_msec() - stamp
	var wave = ceil(timeElapsed / waveTimeMs)
	if (OS.get_ticks_msec() - spawnStamp > waveTimeMs / (10 * wave)):
		if (allAsteroids.size() >= MAX_ASTEROIDS):
			return
		createAsteroid()
		spawnStamp = OS.get_ticks_msec()

func createAsteroid(pos=null, level=3): 
	var ast = load("res://Models/Asteroid/AsteroidBasic/Asteroid_Basic.tscn").instance()
	randomize()
	if (pos != null): 
		ast.position = pos
	else:
		moveAsteroid(ast)

	ast.setLevel(level)
	self.add_child(ast)
	self.allAsteroids.append(ast)

func removeAsteroid(ast):
	for i in range(allAsteroids.size()):
		var tempAst = allAsteroids[i]
		if (ast.ID == tempAst.ID):
			allAsteroids.remove(i)
			break
	ast.queue_free()

func moveAsteroid(ast):
	var offset = Globals.players[0].position
	offset.x += rand_range(800,1200)
	ast.position = Globals.rotateVectorAroundPoint(offset, Globals.players[0].position, rand_range(0,2*PI))

func _draw():
	#Draw borders
	draw_line(Vector2(0,0), Vector2(Globals.MAP_WIDTH, 0), "#91fbff", 4.0)
	draw_line(Vector2(Globals.MAP_WIDTH,0), Vector2(Globals.MAP_WIDTH, Globals.MAP_HEIGHT), "#91fbff", 4.0)
	draw_line(Vector2(Globals.MAP_WIDTH,Globals.MAP_HEIGHT), Vector2(0, Globals.MAP_HEIGHT), "#91fbff", 4.0)
	draw_line(Vector2(0,Globals.MAP_HEIGHT), Vector2(0, 0), "#91fbff", 4.0)
	#Draw star background
	