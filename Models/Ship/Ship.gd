extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var velocity = Vector2()
var curRotation = 0
var isAccelerating = false
var rotateSpeed = 5
var acc = 700.0
var shotStamp = OS.get_ticks_msec()
var fuelStamp = OS.get_ticks_msec()
var fireRate = 300 # Represent the delay in MS between each shot
var fuelRate = 10
var MAX_HEALTH = 100.0
var health = 100
var lerpPos = Vector2(0,0)
var lerpFrom = Vector2(0,0)
var allFuel = []
var aPoints = 0
var cam = null

onready var Main_Scene = get_parent()
onready var heatBar = get_node("ShipOverlay/ShipHeatBar")
onready var healthBar = get_node("ShipOverlay/ShipHealthBar")
onready var pointLabel = get_node("ShipOverlay/PointLabel")
onready var camera = get_node("ShipCamera")
onready var coords = get_node("Coords")

# Called when the node enters the scene tree for the first time.
func _ready():
	heatBar.setGrowCool(1,1)
	cam = get_node("ShipCamera")
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
		var maxDist = lerpFrom.distance_to(lerpPos)
		if(self.position.distance_to(lerpPos) / maxDist > 0.05):
			self.position.x += (lerpPos.x - self.position.x) * 1.0 * d
			self.position.y += (lerpPos.y - self.position.y) * 1.0 * d
		else:
			lerpPos = Vector2(0,0)
			camera.zoomOut = false
			visible = true
			

func getStickVector(index):
	# Index 0 -> left | Index 1 -> right 
	# https://docs.godotengine.org/en/stable/classes/class_%40globalscope.html#enum-globalscope-joyaxis
	var xAxis = 0
	var yAxis = 0
	
	if (index == 0):
		xAxis = 0
		yAxis = 1
	if (index == 1):
		xAxis = 2
		yAxis = 3
	
	var stickX = Input.get_joy_axis(0, xAxis)
	var stickY = Input.get_joy_axis(0, yAxis)
	return Vector2(stickX, stickY)
	

func get_input():
	var lStick = getStickVector(0)
	if (abs(lStick.x) > 0.5 || abs(lStick.y) > 0.5):
		self.curRotation = atan2(lStick.y, lStick.x)
		isAccelerating = true
	else:
		isAccelerating = false
		# Check for other stick 
		var rStick = getStickVector(1)
		if (abs(rStick.x) > 0.5 || abs(rStick.y) > 0.5):
			self.curRotation = atan2(rStick.y, rStick.x)
		
	
	
#	#Turn right
#	if Input.is_action_pressed("player_right"):
#		curRotation = rotateSpeed
#	#Stop turn right
#	if Input.is_action_just_released("player_right"):
#		curRotation = 0
#
#	#Turn left
#	if Input.is_action_pressed("player_left"):
#		curRotation = -rotateSpeed
#	#Stop Turn left
#	if Input.is_action_just_released("player_left"):
#		curRotation = 0 
#
#	#Player firing
	if Input.is_action_pressed("player_fire"):
		shoot()
	
	#Player firing
	if Input.is_action_pressed("Coords"):
		coords.setShow()

	#Remove later.....
	if Input.is_action_pressed("temp_ast"):
		Globals.modMenu.layer = -1

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
			particle.setVelocity(self.rotation)
			particle.visible = true
			particle.stamp = OS.get_ticks_msec()

func shoot():
	if(OS.get_ticks_msec() - shotStamp > fireRate and !heatBar.overHeat):
		shotStamp = OS.get_ticks_msec()
		var bullet = load("res://Models/Bullet/Bullet_Basic.tscn").instance()
		bullet.velocity = (Vector2(cos(rotation), sin(rotation)))
		bullet.position = self.position + (bullet.velocity * 30)
		
		# Make sure the bullet is sent out relative to our current velocity
		bullet.acc += self.velocity.length()
		bullet.shooter = self
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

func setAPoints():
	pointLabel.setText(str(self.aPoints))

# https://stackoverflow.com/questions/63970781/js-how-to-lerp-rotation-in-radians
func rotationLerp (A, B, w):
    var CS = (1-w) * cos(A) + w*cos(B);
    var SN = (1-w) * sin(A) + w * sin(B);
    return atan2(SN,CS);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(isAccelerating):
		velocity += (Vector2(cos(rotation), sin(rotation)) * acc) * delta
		addFuelParticle()

	rotation = rotationLerp(rotation, curRotation, 20 * delta)
	
	position.x += velocity.x * delta
	position.y += velocity.y * delta
	
	velocity.x -= (velocity.x * 0.80) * delta
	velocity.y -= (velocity.y * 0.80) * delta
	
	lerpToPos(delta)
	
	if(visible):
		get_input()
		shoot()
	update()
	bound()
	setAPoints()