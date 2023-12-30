extends CharacterBody3D

class_name Enemy

var ENEMY_SPEED = 0.5
var JUMP_TIME = 3.0

const GRAVITY = 1.0
const JUMP_SPEED = 3.0

var time_left_to_jump = 0

func _ready():
	time_left_to_jump = JUMP_TIME


func _process(delta):
	# Move towards the player
	velocity = (Player.instance.position - position).normalized() * ENEMY_SPEED
	
	# If a certain amount of time passes, jump
	time_left_to_jump -= delta
	if not time_left_to_jump > 0:
		time_left_to_jump += JUMP_TIME
		velocity.y = JUMP_SPEED
	
	# Gravity
	if position.y <= 0:
		position.y = 0
		velocity.y = 0
	else:
		velocity.y += GRAVITY * delta
