extends "res://Models/Asteroid/AsteroidBasic/Asteroid_Basic.gd"


func _ready():
	self.level = 1
	self.baseSize = 80
	self.damage = 0
	self.health = 50
	self.astColor = Color("#00ff51")
	var shape = CircleShape2D.new()
	shape.set_radius(baseSize * level)
	self.collisionShape.shape = shape

func processEnter(obj):
	if(!dead):
		if("Bullet" in obj.filename):
			#Kill Bullet
			shooter = obj.shooter
			obj.hit()
			self.health -= obj.damage
			if (self.health <= 0):
				self.addShards()
				self.dead = true
		elif("Ship" in obj.filename):
			obj.lerpPos = Vector2(rand_range(100, Globals.MAP_WIDTH - 100), rand_range(100, Globals.MAP_HEIGHT - 100))
			obj.lerpFrom = obj.position

func show():
	draw_circle(Vector2(0,0), animateSize, Color(astColor.r, astColor.g, astColor.b, 0.8))
	draw_circle(Vector2(0,0), animateSize - 2, "#000")