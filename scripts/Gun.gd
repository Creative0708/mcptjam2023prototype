extends Node3D

class_name Gun

@export var sprite: Sprite3D
@export var muzzle_flash: Sprite3D
@export var muzzle_light: Node3D

@onready var pivot = $Pivot

@export var MAX_GUN_DISTANCE = 1.1
@export var MIN_GUN_DISTANCE = 0.5

@export var GUN_LERP_FACTOR = 15

@export var RECOIL = 0.9
@export var RECOIL_ROTATION = 0.2
@export var COOLDOWN_TIME = 0.07

@export var MAGAZINE_CAPACITY = 12
@export var RELOAD_TIME = 1.0

@export var MUZZLE_FLASH_SPRITES: Array[Texture2D]  = []
@export var MUZZLE_FLASH_TIME = 0.05

@onready var fire_audio = $"Shoot"
@onready var reload_audio = $"Reload"
@onready var bullet_casing = $"Pivot/Sprite/Bullet Casing"

func fire_if_needed():
	if Input.is_action_just_pressed("fire"):
		fire()
		return true

func fire():
	# Muzzle flash
	muzzle_flash.texture = MUZZLE_FLASH_SPRITES[randi() % MUZZLE_FLASH_SPRITES.size()]
	muzzle_flash.visible = true
	var hide_muzzle_flash = func hide_muzzle_flash():
		muzzle_flash.visible = false
	get_tree().create_timer(MUZZLE_FLASH_TIME).timeout.connect(hide_muzzle_flash)
	
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

func reload():
	reload_audio.pitch_scale = rand() * 0.05 + 1
	reload_audio.play()

func rand():
	return randf() * 2 - 1

func _process(delta):
	muzzle_light.global_position = muzzle_flash.global_position + Vector3.BACK * 0.5
