extends CharacterBody2D


const SPEED = 600.0
const VELOCITY_LERP_FAC = 30

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	motion_mode = MOTION_MODE_FLOATING

func _physics_process(delta):

	var direction = Input.get_vector("left", "right", "up", "down")
	
	var target_velocity = direction * SPEED
	
	velocity = lerp(velocity, target_velocity, clamp(delta * VELOCITY_LERP_FAC, 0, 1))

	move_and_slide()
