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

var bullet_deflect_probability = 0.0

var hp = max_hp

@onready var game = $"../../.."

@onready var sprite: Sprite3D = $Sprite

@onready var camera = $"../Camera"

@onready var footsteps = $Footsteps

@onready var health_indicator = $"../../../CanvasLayer/Player Tracker/Health"

const FOOTSTEP_TIME = 0.2

@export var FOOTSTEP_CLIPS: Array[AudioStream]

@export var SANTA_TEXTURES: Array[Texture2D]

var last_direction = Vector2.RIGHT
var dash_timer = 0
var invincibility_timer = 0

var footstep_status = 0
var sprite_status = 0
var current_sprite = 0

@onready var gun_pivot = $GunPivot
var original_sprite_scale_x

func _ready():
	instance = self
	original_sprite_scale_x = sprite.scale.x
	update_health()

func _physics_process(delta):
	
	var direction = Vector2.ZERO if game.paused else Input.get_vector("left", "right", "up", "down").normalized()
	if direction:
		last_direction = direction
		footstep_status += delta
		sprite_status += delta
		if footstep_status > FOOTSTEP_TIME:
			footstep_status -= FOOTSTEP_TIME
			footsteps.stream = FOOTSTEP_CLIPS[randi() % len(FOOTSTEP_CLIPS)]
			footsteps.pitch_scale = 1 + (randf() * 2 - 1) * 0.2
			footsteps.play()
		if sprite_status > FOOTSTEP_TIME / 2:
			sprite_status -= FOOTSTEP_TIME / 2
			current_sprite = (current_sprite + 1) % len(SANTA_TEXTURES)
	else:
		footstep_status = 0
		sprite_status = 0

	sprite.texture = SANTA_TEXTURES[current_sprite]
	
	var relative_mouse_pos_screen = gun_pivot.viewport_mouse_pos - Camera.world_to_viewport_space(position)
	var gun_angle = -relative_mouse_pos_screen.angle()
	var target_rotation
	if abs(gun_angle) > PI / 2:
		target_rotation = PI - gun_angle
		sprite.scale.x = -original_sprite_scale_x
	else:
		target_rotation = gun_angle
		sprite.scale.x = original_sprite_scale_x
	
	var target_velocity = Vector3(direction.x, 0, direction.y) * movement_speed
	
	velocity = lerp(velocity, target_velocity, clamp(delta * VELOCITY_LERP_FAC * (1 - dash_timer / DASH_TIME), 0, 1))

	if not game.paused and Input.is_action_just_pressed("dash") and not dash_timer > 0:
		dash_timer = DASH_TIME
		velocity = Vector3(last_direction.x, 0, last_direction.y).normalized() * DASH_SPEED
	
	if dash_timer > 0:
		dash_timer = max(dash_timer - delta, 0)
		sprite.material_override.set_shader_parameter("mix_fac", dash_timer / DASH_TIME * DASH_TINT_FAC)
	
	var alpha = 1
	if invincibility_timer > 0:
		invincibility_timer -= delta
		if fmod(invincibility_timer, 0.5) < 0.25:
			alpha = 0
	sprite.material_override.set_shader_parameter("alpha", alpha)
	
	move_and_slide()

func try_damage(bullet: Bullet):
	if dash_timer > 0:
		return
	#if randf() < bullet_deflect_probability:
		#bullet.velocity *= -1
		#return
	
	if invincibility_timer > 0:
		return
	hp -= 1
	$Hurt.play()
	if hp == 0:
		game.change_scene("death")
	
	invincibility_timer = INVINCIBILITY_TIME
	
	update_health()

func update_health():
	health_indicator.update(hp, max_hp)
