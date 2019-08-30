extends Node2D

var color = Color("#FFF")
var center = Vector2(0,0)
var radius = 200
var angleFrom = 0
var angleTo = PI
var velocity = Vector2(0,0)
var acc = 0
var rotateSpeed = 0
var stamp = OS.get_ticks_msec()
var ttl = 1000.0
var visibility = 1

func _ready():
	velocity = Vector2(rand_range(-1, 1),rand_range(-1, 1))
	acc = rand_range(300, 400)
	stamp = OS.get_ticks_msec()
	if(rand_range(0,1) > 0.5):
		rotateSpeed = rand_range(-3, -3)
	else:
		rotateSpeed = rand_range(3,3)

func _process(delta):
	if(visible):
		self.position += velocity * delta * acc
		self.rotation += rotateSpeed * delta
		die()
		update()

func setColor(c):
	color = Color(c)

func die():
	var tempTime = OS.get_ticks_msec() - stamp
	visibility = 1 - (tempTime / ttl)
	if(tempTime > ttl):
		self.visible = false
		Globals.Main_Scene.allShards.push_back(self)

func _draw():
	if(visible):
		draw_circle_arc(center, radius, angleFrom, angleTo, Color(color.r, color.g, color.b, visibility))

func draw_circle_arc(center, radius, angle_from, angle_to, color):
	angle_from = (angle_from / (2*PI)) * 360.0
	angle_to = (angle_to / (2*PI)) * 360.0
	var nb_points = 3
	var points_arc = PoolVector2Array()
	
	for i in range(nb_points + 1):
	    var angle_point = deg2rad(angle_from + i * (angle_to-angle_from) / nb_points - 90)
	    points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
	
	for index_point in range(nb_points):
	    draw_line(points_arc[index_point], points_arc[index_point + 1], color)