extends Area2D

var baseSize = 25
var level = 3
var acc = 200 * (1/(level*1.0))
var velocity = Vector2(0,0)
var velocityGoal = Vector2(0,0)
var dead = false
var basePush = 40
var damage = 10
var baseHealth = 10
var health = baseHealth * level
var animateSize = 1
var astColor = "FFF"
var spawnedChild = false
var shards = []
var shooter = null
var aPoints = 10
onready var collisionShape = get_node("AsteroidCollision")
var randArcPoints = []
var targetStamp = 0
var targetRateMs = 1000 
var spawnedAt = 0
var ID = 0
var collideCount = 0

func _ready():
	var shape = CircleShape2D.new()
	shape.set_radius(baseSize * level)
	self.collisionShape.shape = shape
	setVelocity(rand_range(0, 2*PI))
	self.spawnedAt = OS.get_ticks_msec()
	self.ID = randi()
	setRandArcPoints()
	
func setRandArcPoints(): 
	var nb_points = 12
	for i in range(nb_points + 1):
		randArcPoints.append(rand_range(-4, 4 * level))

func targetPlayer():
	if (OS.get_ticks_msec() - targetStamp < targetRateMs || collideCount > 0):
		return
	targetStamp = OS.get_ticks_msec()
	var minDist = Globals.distance(self.position, Globals.players[0].position)
	var target = Globals.players[0]
	for player in Globals.players:
		var dist = Globals.distance(self.position, player.position)
		if (dist < minDist):
			minDist = dist
			target = player
	
	randomize()
	var dX = self.position.x - (target.position.x + rand_range(-20, 20))
	var dY = self.position.y - (target.position.y + rand_range(-20, 20))
	
	var ang = atan2(dY, dX)
	setVelocity(ang)
	respawn()

func setVelocity(r):
	randomize()
	velocityGoal = -Vector2(cos(r), sin(r))
	acc = 250 * (1/(level*1.0))
	acc = rand_range(0.8, 0.99) * acc
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	travel(delta)
	#bound()
	die()
	growAndShrink(delta)
	targetPlayer()

func setLevel(l):
	self.level = l
	acc = 200 * (1/(self.level*1.0))
	self.health = self.level * baseHealth
	
func travel(d):
	self.position += velocity * d * acc
	velocity.x += (velocityGoal.x - velocity.x) * 1.0 * d
	velocity.y += (velocityGoal.y - velocity.y) * 1.0 * d

func bound():
	var contact = self.position
	var out = false
	
	if(self.position.x - (self.baseSize * level) <= 0):
		contact.x *= 2
		out = true
	if(self.position.y - (self.baseSize * level) <= 0):
		contact.y *= 2
		out = true
	if(self.position.y + (self.baseSize * level) > Globals.MAP_HEIGHT):
		contact.y *= -2
		out = true
	if(self.position.x + (self.baseSize * level) > Globals.MAP_WIDTH):
		contact.x *= -2
		out = true
	
	if (out):
		var tempRotation = contact.angle_to_point(self.position)
		var tempVelocity = Vector2(cos(tempRotation), sin(tempRotation)) 
		self.push(tempVelocity)

func push(v):
	self.velocity += v
	
	if(self.velocity.x > 1):
		self.velocity.x = 1
	if(self.velocity.x < -1):
		self.velocity.x = -1
	if(self.velocity.y > 1):
		self.velocity.y = 1
	if(self.velocity.y < -1):
		self.velocity.y = -1

func die():
	if (dead == true):
		if(shooter != null):
			#shooter.get_node("ShipCamera").startShake(2.0)
			shooter.aPoints += self.aPoints
		if(level > 1 and !spawnedChild):
			for i in range(2):
				var pos = Vector2(self.position.x, self.position.y)
				pos += Vector2(rand_range(-getSize(), getSize()), rand_range(-getSize(), getSize()))
				Globals.Main_Scene.createAsteroid(pos, level - 1)
				spawnedChild = true
		self.addShards()
		Globals.Main_Scene.removeAsteroid(self)
func getSize():
	return baseSize * level

func respawn():
	var timeElapsed = OS.get_ticks_msec() - self.spawnedAt
	if (timeElapsed < 20000):
		return
	if (Globals.distance(self.position, Globals.players[0].position) > 1200):
		self.spawnedAt = OS.get_ticks_msec()
		Globals.Main_Scene.moveAsteroid(self)


func show():
#	draw_circle(Vector2(0,0), animateSize, astColor)
#	draw_circle(Vector2(0,0), animateSize - 2, "#000")
	draw_circle_arc(Vector2(0,0), animateSize, 0, 2*PI, astColor)
	
func draw_circle_arc(center, radius, angle_from, angle_to, color):
	angle_from = (angle_from / (2*PI)) * 360.0
	angle_to = (angle_to / (2*PI)) * 360.0
	var nb_points = 12
	var points_arc = PoolVector2Array()
	
	for i in range(nb_points + 1):
		var angle_point = deg2rad(angle_from + i * (angle_to-angle_from) / nb_points - 90)
		var tempRad = radius
		if (i != 0 and i != nb_points):
			tempRad -= randArcPoints[i]
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * tempRad)
	
	for index_point in range(nb_points):
		draw_line(points_arc[index_point], points_arc[index_point + 1], color, 3)

func _draw():
	show()

func growAndShrink(d):
	if(!dead):
		if(animateSize < (baseSize * level)):
			var rate = 40 * level
			animateSize += rate * d
			update()

func pushPlayer(obj=null):
	if(obj != null):
		var tempRotation = obj.position.angle_to_point(self.position)
		var tempVelocity = Vector2(cos(tempRotation), sin(tempRotation)) * (basePush * damage)
		obj.push(tempVelocity, self)
		obj.get_node("ShipCamera").startShake(3.0)
		obj.cam.startShake(3.0)

func addShards():
	var angle = 0
	randomize()
	var numShards = int(rand_range(4,8))
	for i in range(numShards):
		if(Globals.Main_Scene.allShards.size() > 0):
			var tempShard = Globals.Main_Scene.allShards.pop_front()
			tempShard.position = self.position
			tempShard.radius = self.baseSize * level
			tempShard.angleFrom = angle
			angle += 2*PI / (numShards*1.0)
			tempShard.angleTo = angle
			tempShard.setColor(astColor)
			tempShard.visible = true
			tempShard.stamp = OS.get_ticks_msec()

#Collision detection
func _on_Ast_area_entered(obj):
	if(!dead):
		if("Bullet" in obj.filename):
			#Kill Bullet
			shooter = obj.shooter
			obj.hit()
			self.health -= obj.damage
			
			# Slow down asteroid on hit? 
			#self.acc *= 0.6
			if (self.health <= 0):
				self.dead = true
		elif("Ship" in obj.filename):
			pushPlayer(obj)
		elif("Asteroid" in obj.filename):
			self.collideCount += 1
			var tempRotation = obj.position.angle_to_point(self.position)
			var tempVelocity = Vector2(cos(tempRotation), sin(tempRotation))
			self.velocityGoal = -tempVelocity


func _on_Ast_area_exited(obj):
	if(!dead):
		if("Asteroid" in obj.filename):
			self.collideCount -= 1