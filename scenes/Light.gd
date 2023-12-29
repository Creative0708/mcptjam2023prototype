extends Node3D

@onready var sprite = $Sprite
@onready var sprite_scale = sprite.scale

var time_passed = 0

func _process(delta):
	time_passed += delta
	sprite.scale = sprite_scale if fmod(time_passed, 2.0) < 1.0 else sprite_scale * 0.8
