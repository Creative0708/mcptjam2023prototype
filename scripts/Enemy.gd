extends CharacterBody3D

class_name Enemy

var ENEMY_SPEED = 0.8
var ENEMY_MAX_HEALTH = 10.0
var ENEMY_JUMP_TIME = 3.0
var ENEMY_SHOOT_TIME = 1.5

const GRAVITY = 1.0
const JUMP_SPEED = 3.0

const ENEMY_DEATH_TIME = 0.3

var time_left_to_jump
var time_left_to_shoot

var hp

var is_dying
var death_timer

@onready var sprite = $AnimatedSprite3D

func _ready():
	time_left_to_jump = ENEMY_JUMP_TIME
	time_left_to_shoot = ENEMY_SHOOT_TIME
	hp = ENEMY_MAX_HEALTH
	sprite.play()

func _process(delta):
	if is_dying:
		sprite.modulate = Color(1, 1, 1, death_timer / ENEMY_DEATH_TIME)
		death_timer -= delta
		if death_timer <= 0:
			queue_free()
		return
	
	# Move towards the player
	velocity = (Player.instance.position - position).normalized() * ENEMY_SPEED
	
	# If a certain amount of time passes, jump
	time_left_to_jump -= delta
	if not time_left_to_jump > 0:
		time_left_to_jump += ENEMY_JUMP_TIME
		velocity.y = JUMP_SPEED
	# Same for shooting
	time_left_to_shoot -= delta
	if not time_left_to_shoot > 0:
		time_left_to_shoot += ENEMY_SHOOT_TIME
		shoot_at_player()
	
	# Gravity
	if position.y <= 0:
		position.y = 0
		velocity.y = 0
	else:
		velocity.y += GRAVITY * delta
	
	move_and_slide()
	
const BULLET = preload("res://scenes/component/bullet.tscn")

func shoot_at_player():
	var bullet: Bullet = BULLET.instantiate()
	bullet.set_type(0)
	bullet.position = position
	bullet.move_towards(Player.instance.position)
	get_tree().root.add_child(bullet)

func damage(dmg):
	if is_dying:
		return
	
	hp -= dmg
	if hp <= 0:
		is_dying = true
		death_timer = ENEMY_DEATH_TIME
		sprite.stop()
