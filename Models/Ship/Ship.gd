extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var velocity = Vector2()
var curRotation = 0
var isAccelerating = false
var rotateSpeed = 5
var acc = 700.0
var stamp = OS.get_ticks_msec()
var shotStamp = OS.get_ticks_msec()
var fuelStamp = OS.get_ticks_msec()
var fireRate = 200
var fuelRate = 10
var MAX_HEALTH = 100.0
var health = 100
var lerpPos = Vector2(0,0)
var allFuel = []

onready var Main_Scene = get_parent()
onready var heatBar = get_node("ShipOverlay/ShipHeatBar")
onready var healthBar = get_node("ShipOverlay/ShipHealthBar")
onready var camera = get_node("ShipCamera")

# Called when the node enters the scene tree for the first time.
func _ready():
	heatBar.setGrowCool(1,1)
	initFuelPool()

func initFuelPool():
	for i in range(100):
		var particle = load("res://Models/Ship/FuelParticle.tscn").instance()
		particle.visible = false
		particle.parentShip = self
		allFuel.push_front(particle)
		Globals.Main_Scene.add_child(particle)

func lerpToPos(d):
	if(lerpPos.x + lerpPos.y != 0):
		if(visible):
			visible = false
			isAccelerating = false
			curRotation = 0
			camera.zoomOut = true
		if(self.position.distance_to(lerpPos) > 100):
			self.position.x += (lerpPos.x - self.position.x) * 2.0 * d
			self.position.y += (lerpPos.y - self.position.y) * 2.0 * d
		else:
			lerpPos = Vector2(0,0)
			camera.zoomOut = false
			visible = true

func get_input(d):
	#Turn right
	if Input.is_action_pressed("player_right"):
		curRotation = rotateSpeed
	#Stop turn right
	if Input.is_action_just_released("player_right"):
		curRotation = 0

	#Turn left
	if Input.is_action_pressed("player_left"):
		curRotation = -rotateSpeed
	#Stop Turn left
	if Input.is_action_just_released("player_left"):
		curRotation = 0 
		
	#Player firing
	if Input.is_action_pressed("player_fire"):
		shoot()

	#Remove later.....
	if Input.is_action_pressed("temp_ast"):
		if(OS.get_ticks_msec() - shotStamp > fireRate):
			shotStamp = OS.get_ticks_msec()
			var ast = load("res://Models/Asteroid/AsteroidDuplicate/Asteroid_Duplicate_Hive.tscn").instance()
			ast.velocity = (Vector2(cos(rotation), sin(rotation)))
			ast.position = Vector2(self.position.x + 240, self.position.y + 240) 
			
			Main_Scene.add_child(ast)

	#Player acceleration
	if Input.is_action_pressed("player_up"):
		#Move the player
		isAccelerating = true
	if Input.is_action_just_released("player_up"):
		isAccelerating = false 

func addFuelParticle():
	if(OS.get_ticks_msec() - fuelStamp > fuelRate):
		fuelStamp = OS.get_ticks_msec()
		if(allFuel.size() > 0):
			var particle = allFuel.pop_front()
			particle.position = self.position
			particle.origin = self.position
			particle.setVelocity(self.rotation, acc)
			particle.visible = true
			particle.stamp = OS.get_ticks_msec()

func shoot():
	if(OS.get_ticks_msec() - shotStamp > fireRate and !heatBar.overHeat):
		shotStamp = OS.get_ticks_msec()
		var bullet = load("res://Models/Bullet/Bullet_Basic.tscn").instance()
		bullet.velocity = (Vector2(cos(rotation), sin(rotation)))
		bullet.position = self.position
		Main_Scene.add_child(bullet)
		heatBar.grow()

func push(v, ast=null):
	velocity += v
	if(ast != null):
		health -= ast.damage
		healthBar.setScale(health / MAX_HEALTH)

#TODO
func bound():
	var contact = self.position
	var out = false
	if(self.position.x < 0):
		contact.x *= -2
		out = true
	if(self.position.y < 0):
		contact.y *= -2
		out = true
	if(self.position.y > Globals.MAP_HEIGHT):
		contact.y *= -2
		out = true
	if(self.position.x > Globals.MAP_WIDTH):
		contact.x *= -2
		out = true
	
	if (out):
		var tempRotation = contact.angle_to_point(self.position)
		var tempVelocity = Vector2(cos(tempRotation), sin(tempRotation)) * 50
		self.push(tempVelocity)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(isAccelerating):
		velocity += (Vector2(cos(rotation), sin(rotation)) * acc) * delta
		addFuelParticle()
	rotation += curRotation * delta
	position.x += velocity.x * delta
	position.y += velocity.y * delta
	
	velocity.x -= (velocity.x * 0.80) * delta
	velocity.y -= (velocity.y * 0.80) * delta
	
	lerpToPos(delta)
	
	if(visible):
		get_input(delta)
	update()
	bound()