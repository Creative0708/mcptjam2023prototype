extends Node3D

@onready var player = $".."

@onready var gun = $Gun
@onready var gun_sprite = $Gun/Sprite
@onready var muzzle_flash = $"Gun/Sprite/Muzzle Flash"

const MAX_GUN_DISTANCE = 1.1
const MIN_GUN_DISTANCE = 0.5

const GUN_LERP_FACTOR = 15

const RECOIL = 0.9
const RECOIL_ROTATION = 0.5
const COOLDOWN_TIME = 0.1

const FIRE_SOUND = preload("res://sfx/pistol2.wav")

var MUZZLE_FLASH_SPRITES = []

func _init():
	for i in 5:
		MUZZLE_FLASH_SPRITES.push_back(load(str("res://textures/muzzle_flashes_2/pixil-frame-", i, ".png")))

func _ready():
	randomize()

var gun_cooldown = 0

func _process(delta):
	var mouse_pos = Camera.world_mouse_pos()
	if mouse_pos == null:
		return
		
	var relative_mouse_pos: Vector3 = mouse_pos - player.position
	relative_mouse_pos.y = 0
	if relative_mouse_pos.length() >= MAX_GUN_DISTANCE:
		relative_mouse_pos *= MAX_GUN_DISTANCE / relative_mouse_pos.length()
	elif relative_mouse_pos.length() <= MIN_GUN_DISTANCE:
		relative_mouse_pos *= MIN_GUN_DISTANCE / relative_mouse_pos.length()
	
	var target_gun_pos = relative_mouse_pos * MAX_GUN_DISTANCE
	target_gun_pos.y = gun.position.y
	
	gun.position = lerp(gun.position, target_gun_pos, delta * GUN_LERP_FACTOR)
	
	var relative_mouse_pos_screen = get_viewport().get_mouse_position() - Camera.world_to_screen_space(player.position)
	var gun_angle = -relative_mouse_pos_screen.angle()
	var target_rotation
	if abs(gun_angle) > PI / 2:
		target_rotation = PI - gun_angle
		gun_sprite.rotation.y = PI
	else:
		target_rotation = gun_angle
		gun_sprite.rotation.y = 0
	
	if gun_cooldown > 0:
		gun_cooldown -= delta
	
	if Input.is_action_just_pressed("fire") and not gun_cooldown > 0:
		# Fire sound
		var audio = AudioStreamPlayer.new()
		audio.volume_db = -10
		audio.stream = FIRE_SOUND
		add_child(audio)
		audio.play()
		var delete_audio = func delete_audio():
			audio.queue_free()
		audio.finished.connect(delete_audio)
		
		gun.position *= RECOIL
		gun_cooldown = COOLDOWN_TIME
		
		target_rotation += -RECOIL_ROTATION if abs(gun_angle) > PI / 2 else RECOIL_ROTATION
		
		# Muzzle flash
		muzzle_flash.texture = MUZZLE_FLASH_SPRITES[randi() % MUZZLE_FLASH_SPRITES.size()]
		muzzle_flash.visible = true
		var hide_muzzle_flash = func hide_muzzle_flash():
			muzzle_flash.visible = false
		get_tree().create_timer(0.05).timeout.connect(hide_muzzle_flash)

	gun_sprite.rotation.z = lerp_angle(gun_sprite.rotation.z, target_rotation, delta * GUN_LERP_FACTOR)
	
