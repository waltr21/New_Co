extends "res://Models/Asteroid/AsteroidBasic/Asteroid_Basic.gd"

var stamp = OS.get_ticks_msec()
var color = "#6ff8fc"


func _ready():
	self.level = 1
	self.baseSize = 60
	self.damage = 3
	var shape = CircleShape2D.new()
	shape.set_radius(baseSize * level)
	self.collisionShape.shape = shape

func strike():
	if(OS.get_ticks_msec() - stamp > 1000):
		return

func show():
	draw_circle(Vector2(0,0), baseSize * level, color)
	draw_circle(Vector2(0,0), (baseSize * level) - 2, "#000")
	

class Bolt:
	var points = []
	
	func _init(shipPoint):
		points.push_back(shipPoint)
		