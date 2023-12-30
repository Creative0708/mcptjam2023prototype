extends Node3D

class_name Gun

@export var sprite: Sprite3D
@export var muzzle_flash: Sprite3D
@export var muzzle_light: Node3D

@onready var pivot = $Pivot

@export_category("Parameters")

@export var MAX_GUN_DISTANCE = 1.1
@export var MIN_GUN_DISTANCE = 0.5

@export var GUN_LERP_FACTOR = 15

@export var RECOIL = 0.9
@export var RECOIL_ROTATION = 0.2
@export var COOLDOWN_TIME = 0.07

@export var MUZZLE_FLASH_SPRITES: Array[Texture2D]  = []
@export var MUZZLE_FLASH_TIME = 0.05

@export_category("Actual relevant stuff")
@export var MAGAZINE_CAPACITY = 12
@export var RELOAD_TIME = 1.0

@export var NUM_BULLETS_PER_SHOT = 1
@export var BULLET_DAMAGE = 1.0
@export var BULLET_SPREAD_DISTANCE = 0.05

@export var BULLET_MAX_DISTANCE = 10.0
@export var BULLET_PENETRATION: int = 1

@onready var fire_audio = $"Shoot"
@onready var reload_audio = $"Reload"
@onready var bullet_casing = $"Pivot/Sprite/Bullet Casing"

@onready var bullet_line = $"../Bullet Line"
@onready var player: Node3D = $"../.."

@export_flags_3d_physics var enemy_mask: int
@export_flags_3d_physics var wall_mask: int

func fire_if_needed():
	if Input.is_action_just_pressed("fire"):
		fire()
		return true

func fire():
	# Muzzle flash
	muzzle_flash.texture = MUZZLE_FLASH_SPRITES[randi() % MUZZLE_FLASH_SPRITES.size()]
	muzzle_flash.visible = true
	
	fire_audio.pitch_scale = rand() * 0.05 + 1
	fire_audio.play()
	
	var object: RigidBody3D = bullet_casing.duplicate(DUPLICATE_USE_INSTANTIATION | DUPLICATE_SCRIPTS)
	object.freeze = false
	object.visible = true
	object.activate()
	get_tree().root.add_child(object)
	object.global_position = bullet_casing.global_position
	object.global_rotation = bullet_casing.global_rotation
	object.linear_velocity = Vector3(rand(), randf() * 0.5 + 2, rand())
	object.angular_velocity = Vector3(0, 0, rand() * TAU)
	
	for i in NUM_BULLETS_PER_SHOT:
		shoot_bullet()
	
	await get_tree().create_timer(MUZZLE_FLASH_TIME).timeout
	muzzle_flash.visible = false

func reload():
	reload_audio.pitch_scale = rand() * 0.05 + 1
	reload_audio.play()
	
@onready var sub_viewport = player.get_node("..")

func shoot_bullet():
	var target = Camera.camera.get_mouse_enemy_target()
	var target_pos = Camera.world_mouse_pos() if target == null else target.position
	var vec: Vector3 = (target_pos - player.position).normalized()
	var randomized = Vector3(rand(), rand(), rand()).normalized() * BULLET_SPREAD_DISTANCE
	var target_vec = (vec + randomized).normalized()
	
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(player.position, player.position + target_vec * BULLET_MAX_DISTANCE, enemy_mask | wall_mask, [])
	
	var num_hits = 0
	var collided = []
	var last_hit = player.position + target_vec * BULLET_MAX_DISTANCE
	while true:
		var result = space_state.intersect_ray(query)
		if result.is_empty():
			break
		num_hits += 1
		if num_hits > BULLET_PENETRATION:
			break
		query.exclude.append(result.collider)
		collided.append(result.collider)
		last_hit = result.position
	
	var muzzle_position = muzzle_flash.global_position
	muzzle_position.z -= muzzle_position.y
	muzzle_position.y = 0
	
	for collider in collided:
		if collider is Enemy:
			collider.damage(BULLET_DAMAGE)
	
	if (last_hit - player.position).length_squared() < (muzzle_position - player.position).length_squared():
		return
	
	var line = bullet_line.duplicate(DUPLICATE_SCRIPTS)
	
	line.position = Vector3.ZERO
	line.visible = true
	line.set_points([muzzle_position, last_hit])
	sub_viewport.add_child(line)

func rand():
	return randf() * 2 - 1

func _process(delta):
	muzzle_light.global_position = muzzle_flash.global_position + Vector3.BACK * 0.5
