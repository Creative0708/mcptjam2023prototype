extends Node3D

@onready var player = $".."

@onready var gun = $Gun

const MAX_GUN_DISTANCE = 1.2
const MIN_GUN_DISTANCE = 0.7

const GUN_LERP_FACTOR = 15

const RECOIL = 0.85

const FIRE_SOUND = preload("res://sfx/pistol2.wav")

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
	
	gun.position = lerp(gun.position, relative_mouse_pos * MAX_GUN_DISTANCE, delta * GUN_LERP_FACTOR)
	
	var relative_mouse_pos_screen = get_viewport().get_mouse_position() - Camera.world_to_screen_space(player.position)
	var gun_angle = -relative_mouse_pos_screen.angle()
	if abs(gun_angle) > PI / 2:
		gun.rotation.z = gun_angle + PI
		gun.flip_h = true
	else:
		gun.rotation.z = gun_angle
		gun.flip_h = false
	
	if Input.is_action_just_pressed("fire"):
		var audio = AudioStreamPlayer.new()
		audio.volume_db = -10
		audio.stream = FIRE_SOUND
		add_child(audio)
		audio.play()
		var delete_audio = func delete_audio():
			audio.queue_free()
		audio.finished.connect(delete_audio)
		
		gun.position *= RECOIL
