extends Camera2D

var shakeLevel = 1.0
var shake = false
var stamp = OS.get_ticks_msec()
var baseZoom = 1.5
var farZoom = 3.0
var curZoom = baseZoom
var zoomOut = false

func _ready():
	zoom.x = baseZoom
	zoom.y = baseZoom

func _process(delta):
	if(zoomOut):
		zoomOut(delta)
	else:
		zoomIn(delta)
		
	if(shake):
		self.set_offset(Vector2(rand_range(-1.0, 1.0) * shakeLevel, rand_range(-1.0, 1.0) * shakeLevel))
		if(OS.get_ticks_msec() - stamp > 400):
			shake = false
			self.set_offset(Vector2(0,0))
	
func startShake(level):
	shake = true
	shakeLevel = level
	stamp = OS.get_ticks_msec()

func zoomOut(d):
	if(abs(curZoom - farZoom) > 0.1):
		curZoom += (farZoom - curZoom) * 2.0 * d
		zoom.x = curZoom
		zoom.y = curZoom

func zoomIn(d):
	if(abs(curZoom - baseZoom) > 0.1):
		curZoom += (baseZoom - curZoom) * 2.0 * d
		zoom.x = curZoom
		zoom.y = curZoom