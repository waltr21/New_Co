extends Label

var largeScale = 1.05
var smallScale = 1.0
var curScale = 1.0
var growRate = 0.5
var grow = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setText(t):
	if t != self.text:
		self.text = t
		grow = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if grow:
		curScale += growRate * delta
	elif !grow and curScale > smallScale:
		curScale -= growRate * delta
	
	if curScale >= largeScale:
		grow = false
	
	if curScale - self.rect_scale.x != 0:
		self.rect_scale = Vector2(curScale, curScale)