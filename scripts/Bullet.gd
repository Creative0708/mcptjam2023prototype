extends Node3D

class_name Bullet

@export_flags_3d_physics var wall_flag: int
@export_flags_3d_physics var player_flag: int

var velocity: Vector3 = Vector3.ZERO

var type

var speed: float

var lifetime: float = 10.0

var is_dying = false
var death_timer

@onready var sprite = $Sprite

func set_type(t: int):
	assert(t == 0 || t == 1 || t == 2)
	type = t
	var sprite = $Sprite
	match t:
		0:
			sprite.texture = load("res://textures/enemy/enemy_bullet/bullet_small.png")
			speed = 1.5
		1:
			sprite.texture = load("res://textures/enemy/enemy_bullet/bullet_big.png")
			speed = 1.5
		2:
			sprite.texture = load("res://textures/enemy/enemy_bullet/bullet_sharp.png")
			speed = 3.0
	speed *= 2.0

func move_towards(pos: Vector3):
	velocity = (pos - position).normalized() * speed

func _process(delta):
	if is_dying:
		death_timer -= delta
		sprite.modulate = Color(1, 1, 1, death_timer / 0.3)
		
		if death_timer <= 0:
			queue_free()
		return
	position += velocity * delta
	lifetime -= delta
	if not lifetime > 0:
		die()

func _on_area_body_entered(body):
	#if body is StaticBody3D and (body.collision_layer & wall_flag):
		#die()
	if body is Player:
		body.try_damage(self)

func die():
	if is_dying:
		return
	is_dying = true
	death_timer = 0.3
