extends Node2D

var line1End = Vector2(40, -70)
var line2End = Vector2(100, -70)
var scale1 = 0
var scale2 = 0
var scaleRate = 3
var show = false
var grow = true
var stamp = OS.get_ticks_msec()
onready var label = get_node("Label")

# Called when the node enters the scene tree for the first time.
func _ready():
	label.rect_position = Vector2(line1End.x, line1End.y - 40)
	label.rect_scale = Vector2(0,0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#Stabilize the rotation
	if(show):
		label.text = str(int(get_parent().position.x) / 100) + " - " + str(int(get_parent().position.y) / 100)
		self.rotation = get_parent().rotation * -1
		if(grow):
			scaleUp(delta)
		else:
			scaleDown(delta)
		boundScale()
	if(scale1 > 0 and show):
		update()
		if (OS.get_ticks_msec() - stamp > 4000):
			setHide()
	

func scaleUp(d):
	scale1 += scaleRate * d
	if(scale1 >= 1.0):
		scale2 += scaleRate * d
		label.rect_scale = Vector2(scale2,1)
	
func scaleDown(d):
	scale2 -= scaleRate * d
	label.rect_scale = Vector2(scale2,1)
	if(scale2 <= 0):
		scale1 -= scaleRate * d
		grow = false

func setShow():
	stamp = OS.get_ticks_msec()
	show = true

func setHide():
	grow = false

func boundScale():
	if(scale1 > 1):
		scale1 = 1.0
	if(scale2 > 1):
		scale2 = 1.0
	if(scale1 < 0):
		scale1 = 0.0
		grow = true
		show = false
		label.rect_scale = Vector2(0,0)
	if(scale2 < 0):
		scale2 = 0.0

func _draw():
	if(show):
		var temp = Vector2(line1End.x + line2End.x * scale2, line2End.y)
		draw_line(Vector2(10,-20) * scale1, line1End * scale1, "#FFF", 1.0)
		draw_line(line1End, temp, "#FFF", 1.0)