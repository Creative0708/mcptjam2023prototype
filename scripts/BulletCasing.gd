extends RigidBody3D

const BULLET_LIFETIME = 4
const BULLET_FADE_TIME = 1

var active = false

var time_left

var sprite

func activate():
	active = true
	sprite = $Sprite
	
	time_left = BULLET_LIFETIME
	
	var mult = 1 - randf() * 0.1
	sprite.modulate = Color(1, 1 - randf() * 0.3, 1 - randf() * 0.6) * mult

func _process(delta):
	if not active:
		return
	
	time_left -= delta
	
	if time_left > BULLET_FADE_TIME:
		return
	
	if not time_left > 0:
		queue_free()
		return
	
	sprite.modulate = Color(sprite.modulate, time_left / BULLET_FADE_TIME)
