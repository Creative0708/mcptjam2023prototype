extends CharacterBody3D

class_name Player

static var instance: Player

var movement_speed = 8.0
var max_hp: int = 12

const VELOCITY_LERP_FAC = 30

const DASH_TIME = 0.5
const DASH_SPEED = 20
const DASH_TINT_FAC = 0.7

const INVINCIBILITY_TIME = 3.0

var hp = max_hp

@onready var game = $"../../.."

@onready var sprite = $Sprite

@onready var camera = $"../Camera"

@onready var footsteps = $Footsteps

const FOOTSTEP_TIME = 0.2
@export var FOOTSTEP_CLIPS: Array[AudioStream]

var last_direction = Vector2.RIGHT
var dash_timer = 0
var invincibility_timer = 0

var footstep_status = 0

func _ready():
	instance = self

func _physics_process(delta):
	if game.paused:
		return
	
	var direction = Input.get_vector("left", "right", "up", "down").normalized()
	if direction:
		last_direction = direction
		footstep_status += delta
		if footstep_status > FOOTSTEP_TIME:
			footstep_status -= FOOTSTEP_TIME
			footsteps.stream = FOOTSTEP_CLIPS[randi() % len(FOOTSTEP_CLIPS)]
			footsteps.pitch_scale = 1 + (randf() * 2 - 1) * 0.2
			footsteps.play()
	else:
		footstep_status = 0
	
	var target_velocity = Vector3(direction.x, 0, direction.y) * movement_speed
	
	velocity = lerp(velocity, target_velocity, clamp(delta * VELOCITY_LERP_FAC * (1 - dash_timer / DASH_TIME), 0, 1))

	if Input.is_action_just_pressed("dash") and not dash_timer > 0:
		dash_timer = DASH_TIME
		velocity = Vector3(last_direction.x, 0, last_direction.y).normalized() * DASH_SPEED
	
	if dash_timer > 0:
		dash_timer = max(dash_timer - delta, 0)
		sprite.material_override.set_shader_parameter("mix_fac", dash_timer / DASH_TIME * DASH_TINT_FAC)
	
	invincibility_timer -= delta
	
	move_and_slide()

func try_damage():
	if invincibility_timer > 0:
		return
	hp -= 1
	invincibility_timer = INVINCIBILITY_TIME
