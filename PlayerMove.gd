extends CharacterBody3D


const SPEED = 8.0
const VELOCITY_LERP_FAC = 30

const DASH_TIME = 0.5
const DASH_SPEED = 20
const DASH_TINT_FAC = 0.7

@onready var sprite = $Sprite

@onready var camera = $"../Camera"

var last_direction = Vector2.RIGHT
var dash_timer = 0

func _physics_process(delta):

	var direction = Input.get_vector("left", "right", "up", "down").normalized()
	if direction:
		last_direction = direction
	
	var target_velocity = Vector3(direction.x, 0, direction.y) * SPEED
	
	velocity = lerp(velocity, target_velocity, clamp(delta * VELOCITY_LERP_FAC * (1 - dash_timer / DASH_TIME), 0, 1))

	if Input.is_action_just_pressed("dash") and not dash_timer > 0:
		dash_timer = DASH_TIME
		velocity = Vector3(last_direction.x, 0, last_direction.y).normalized() * DASH_SPEED
	
	if dash_timer > 0:
		dash_timer = max(dash_timer - delta, 0)
		sprite.material_override.set_shader_parameter("mix_fac", dash_timer / DASH_TIME * DASH_TINT_FAC)
	
	move_and_slide()
