extends Sprite3D

@onready var bullet = $Bullet

func phase1():
	pass

func sleep(seconds):
	await get_tree().create_timer(seconds).timeout
