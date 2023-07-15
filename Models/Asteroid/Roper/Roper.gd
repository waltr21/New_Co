extends "res://Models/Asteroid/AsteroidBasic/Asteroid_Basic.gd"

var stamp = OS.get_ticks_msec()
var ropeDistance = 600
var ropes = []
var pullStrength = 600

func _ready():
	self.level = 1
	self.baseSize = 80
	self.damage = 15
	self.health = 30
	self.aPoints = 50
	self.astColor = "#ffb300"
	var shape = CircleShape2D.new()
	shape.set_radius(baseSize * level)
	self.collisionShape.shape = shape

func strike():
	if(OS.get_ticks_msec() - stamp > 1000):
		return
	
func _process(delta):
	searchPlayers()
	removePlayers()
	pull(delta)

func removePlayers():
	for player in ropes:
		if(player.position.distance_to(self.position) >= ropeDistance):
			ropes.erase(player)

func pull(d):
	for player in ropes:
		var tempRotation = self.position.angle_to_point(player.position)
		var tempVelocity = Vector2(cos(tempRotation), sin(tempRotation)) * pullStrength * d
		player.push(tempVelocity)

func searchPlayers():
	for i in Globals.players:
		if(i.position.distance_to(self.position) < ropeDistance and !(i in ropes)):
			ropes.push_front(i)

func show():
	for player in ropes:
		var diff = Vector2(player.position.x - self.position.x, player.position.y - self.position.y)
		draw_line(Vector2(0,0), get_transform().affine_inverse() * player.position, "#c29c42", 3)
	draw_circle(Vector2(0,0), animateSize, astColor)
	draw_circle(Vector2(0,0), animateSize - 2, "#000")
	