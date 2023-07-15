extends Node2D

#Heat colors...
var heatR = 149
var heatG = 252
var heatB = 151

var oHeatR = 247
var oHeatG = 121
var oHeatB = 121

var barHeight = 75
var barWidth = 10
var c = Color(1,1,1)
var heatColor = Color(0,0,0)
var base_grow = 5.0
var base_cool = 50.0
var growRate = base_grow
var coolRate = base_cool
var heatBar = 0
var animateBar = 0
var animateRate = 200
var cooling = false
var overHeat = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	cool(delta)
	animate(delta)
	bound()
	setHeatColor()
	update()
	pass

func setHeatColor():
	if(!overHeat):
		heatColor = Color(heatR/255.0, heatG/255.0, heatB/255.0)
	else:
		heatColor = Color(oHeatR/255.0, oHeatG/255.0, oHeatB/255.0)

func setGrowCool(grow, cool):
	growRate = base_grow * grow
	coolRate = base_cool * cool

func animate(d):
	if(animateBar < heatBar):
		animateBar += animateRate * d
	if(animateBar > heatBar):
		animateBar -= animateRate * d
		cooling = true

func cool(d):
	if (heatBar == 0):
		cooling = false
	if(cooling):
		heatBar -= coolRate * d

func grow():
	heatBar += growRate

func bound():
	if (heatBar > barHeight * 2):
		heatBar = barHeight * 2
		overHeat = true
	
	if (heatBar <= 0):
		heatBar = 0
		overHeat = false

func _draw():
	draw_line(Vector2(-barWidth, barHeight),  Vector2(barWidth, barHeight), "#fff", 2.0)
	draw_line(Vector2(-barWidth, -barHeight),  Vector2(barWidth, -barHeight), "#fff", 2.0)
	draw_line(Vector2(0, -barHeight),  Vector2(0, barHeight), "#fff", 2.0)
	var rect = Rect2(-barWidth/2.0, barHeight-1, barWidth, -animateBar)
	draw_rect(rect, heatColor)