extends CanvasLayer


var buttons = []

func _ready():
	Globals.modMenu = self
	var buttonCode = 0
	for child in get_children():
		buttons.push_front(child)
		child.connect("pressed", self, "_spawn_pressed", [buttonCode])
		buttonCode += 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _spawn_pressed(buttonCode):
	var ast = null
	if buttonCode == 0:
		ast = load("res://Models/Asteroid/AsteroidBasic/Asteroid_Basic.tscn").instance()
	if buttonCode == 1:
		ast = load("res://Models/Asteroid/Roper/Roper.tscn").instance()
	if buttonCode == 2:
		ast = load("res://Models/Asteroid/Telestroid/Telestroid.tscn").instance()
	if buttonCode == 3:
		ast = load("res://Models/Asteroid/Bombin/Bombin.tscn").instance()
	if buttonCode == 4:
		ast = load("res://Models/Asteroid/Bee/Bee_Hive.tscn").instance()
	if buttonCode == 5:
		ast = load("res://Models/Asteroid/AsteroidDuplicate/Asteroid_Duplicate_Hive.tscn").instance()
	if buttonCode == 6:
		ast = load("res://Models/Asteroid/Zoomer/Zoomer.tscn").instance()
		
	ast.position = Vector2(Globals.players[0].position.x + 240, Globals.players[0].position.y + 240) 
	Globals.Main_Scene.add_child(ast)