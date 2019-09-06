extends Label

var velocity = Vector2(0,-1)
var acc = 100
var shrinkRate = Vector2(1,1)

func _process(delta):
	kill()
	self.rect_position += velocity * acc * delta
	self.rect_scale -= shrinkRate * delta

func kill():
	if self.rect_scale.x <= 0:
		self.queue_free()