extends Node

var MAP_WIDTH = 5000
var MAP_HEIGHT = 5000
var CAM_WIDTH = 1024
var CAM_HEIGHT = 600
var Main_Scene = null
var modMenu = null
var players = []

func distance(v1, v2):
    return v1.distance_to(v2)

func rotateVectorAroundPoint(vector: Vector2, point: Vector2, angle: float) -> Vector2:
	var cosAngle = cos(angle)
	var sinAngle = sin(angle)
	var translatedVector = vector - point
	var rotatedVector = Vector2( translatedVector.x * cosAngle - translatedVector.y * sinAngle,translatedVector.x * sinAngle + translatedVector.y * cosAngle)
	return rotatedVector + point