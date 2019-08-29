extends Node2D

var borderColor = Color(141/255.0, 153/255.0, 152/255.0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _draw():
	draw_line(Vector2(0,0), Vector2(Globals.CAM_WIDTH, 0), borderColor, 5.0)
	draw_line(Vector2(Globals.CAM_WIDTH,0), Vector2(Globals.CAM_WIDTH, Globals.CAM_HEIGHT), borderColor, 5.0)
	draw_line(Vector2(Globals.CAM_WIDTH,Globals.CAM_HEIGHT), Vector2(0, Globals.CAM_HEIGHT), borderColor, 5.0)
	draw_line(Vector2(0,Globals.CAM_HEIGHT), Vector2(0, 0), borderColor, 5.0)