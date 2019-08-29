extends Node2D

var baseScale = 2
onready var health = get_node("Health")

func setScale(percent):
	if(percent < 0):
		percent = 0
	health.scale.x = 2 * percent

