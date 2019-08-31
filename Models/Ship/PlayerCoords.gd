extends Node2D

var line1End = Vector2(30, -70)
var line2End = Vector2(100, -70)
var scale1 = 0
var scale2 = 0
var scaleRate = 1
var show = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#Stabilize the rotation
	if(show):
		self.rotation = get_parent().rotation * -1
		scaleUp(delta)
		boundScale()
	if(scale1 > 0 and show):
		update()

func scaleUp(d):
	scale1 += scaleRate * d
	if(scale1 >= 1.0):
		scale2 += scaleRate * d

func boundScale():
	if(scale1 > 1):
		scale1 = 1.0
	if(scale2 > 1):
		scale2 = 1.0
	


func _draw():
	var temp = Vector2(line1End.x + line2End.x * scale2, line2End.y)
	draw_line(Vector2(10,-20) * scale1, line1End * scale1, "#FFF", 1.0)
	draw_line(line1End, temp, "#FFF", 1.0)