extends Node3D

@onready var player = $".."

@export var gun: Gun

@export var ammo_control: Control

signal ammo_update(int)

var ammo_left

func _ready():
	randomize()
	if gun:
		init_gun_stuffs()

var gun_cooldown = 0
var reload_timer = 0
var gun_spin_angle = 0.0

var pivot_rotation = 0.0
var recoil_rotation = 0.0

var mouse_pos = null
var viewport_mouse_pos = Vector2.ZERO

@onready var game = $"../../../.."

func set_gun(gun_scene: PackedScene):
	gun = gun_scene.instantiate()
	add_child(gun)
	init_gun_stuffs()

func init_gun_stuffs():
	ammo_left = gun.MAGAZINE_CAPACITY
	ammo_control.update(ammo_left, gun.MAGAZINE_CAPACITY, 0)

func _process(delta):
	if not game.paused:
		mouse_pos = Camera.world_mouse_pos()
		viewport_mouse_pos = get_viewport().get_mouse_position()
	if mouse_pos == null:
		return
	
	var relative_mouse_pos: Vector3 = mouse_pos - player.position
	relative_mouse_pos.y = 0
	if relative_mouse_pos.length() >= gun.MAX_GUN_DISTANCE:
		relative_mouse_pos *= gun.MAX_GUN_DISTANCE / relative_mouse_pos.length()
	elif relative_mouse_pos.length() <= gun.MIN_GUN_DISTANCE:
		relative_mouse_pos *= gun.MIN_GUN_DISTANCE / relative_mouse_pos.length()
	
	var target_gun_pos = relative_mouse_pos * gun.MAX_GUN_DISTANCE
	target_gun_pos.y = gun.position.y
	
	var relative_mouse_pos_screen = viewport_mouse_pos - Camera.world_to_viewport_space(player.position)
	var gun_angle = -relative_mouse_pos_screen.angle()
	var target_rotation
	if abs(gun_angle) > PI / 2:
		target_rotation = PI - gun_angle
		gun.pivot.rotation.y = PI
	else:
		target_rotation = gun_angle
		gun.pivot.rotation.y = 0
	
	if gun_cooldown > 0:
		gun_cooldown -= delta
	
	if reload_timer > 0:
		reload_timer -= delta
		if not reload_timer > 0:
			reload_timer = 0
			ammo_left = gun.MAGAZINE_CAPACITY
		ammo_control.update(ammo_left, gun.MAGAZINE_CAPACITY, 1 - (reload_timer / gun.RELOAD_TIME) if reload_timer > 0 else 0)
	
	if not reload_timer > 0 && ammo_left < gun.MAGAZINE_CAPACITY && Input.is_action_just_pressed("reload"):
		reload()
	
	if not game.paused and not gun_cooldown > 0 && ammo_left > 0 && not reload_timer > 0 && gun.fire_if_needed():
		gun.sprite.position = gun.position.normalized() * (gun.RECOIL if abs(gun_angle) > PI / 2 else -gun.RECOIL)
		gun_cooldown = gun.COOLDOWN_TIME
		
		recoil_rotation += gun.RECOIL_ROTATION
		
		ammo_left -= 1
		ammo_control.update(ammo_left, gun.MAGAZINE_CAPACITY, 0)
		if ammo_left == 0:
			reload()

	gun_spin_angle = move_toward(lerp(gun_spin_angle, 0.0, delta * 5.0), 0, delta * 0.3)
	pivot_rotation = lerp_angle(pivot_rotation, target_rotation, delta * gun.GUN_LERP_FACTOR)
	recoil_rotation = lerp_angle(recoil_rotation, 0.0, delta * gun.GUN_LERP_FACTOR)
	
	gun.position = lerp(gun.position, target_gun_pos, delta * gun.GUN_LERP_FACTOR)
	
	gun.sprite.position = lerp(gun.sprite.position, Vector3.ZERO, delta * gun.GUN_LERP_FACTOR)
	gun.sprite.rotation.z = recoil_rotation + gun_spin_angle
	gun.pivot.rotation.z = pivot_rotation
	

func reload():
	reload_timer = gun.RELOAD_TIME
	gun.reload()
	await get_tree().create_timer(gun.MUZZLE_FLASH_TIME).timeout
	gun_spin_angle = -TAU
