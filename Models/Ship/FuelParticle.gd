extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var color = null
var velocity = Vector2(0,0)
var size = 2
var acc = 100
var maxTime = 700.0
var origin = Vector2(0,0)
var stamp = 0
var randG = rand_range(0, 225)
var randR = rand_range(0, 225)
var randB = rand_range(0, 225)

func _ready():
	stamp = OS.get_ticks_msec()
	color = Color(1, randG/255.0, 0, 1)

func _process(delta):
	color = Color(1, randG/255.0, 0, 1 - (OS.get_ticks_msec() - stamp)/(maxTime*1.6))
	position += velocity * acc * delta
	bound()
	update()
	
func bound():
	if(OS.get_ticks_msec() - stamp > maxTime):
		self.queue_free()

func setVelocity(rot, acc):
	rot += rand_range(-2.0, 2.0)
	velocity = Vector2(cos(rot + PI), sin(rot + PI))

func _draw():
	draw_circle(Vector2(0,0), size, color)
