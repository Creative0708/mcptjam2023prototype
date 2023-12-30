extends Sprite2D

@onready var game = $".."

func _process(delta):
	visible = not game.paused
	if visible:
		position = get_viewport().get_mouse_position()
		
		if Input.is_action_just_pressed("ui_cancel"):
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		elif Input.is_action_just_pressed("click"):
			Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
