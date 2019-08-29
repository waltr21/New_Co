extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var cam = get_parent()
onready var label = get_child(0)
# Called when the node enters the scene tree for the first time.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_rotation = 0
	label.text = str(Engine.get_frames_per_second())
	#global_position = Vector2(cam.position.x, cam.position. y )
