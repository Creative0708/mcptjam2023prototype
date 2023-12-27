extends Camera2D

@onready var player = $"../Player"

const CAMERA_LERP_FAC = 10
const MOUSE_LOOK_DISTANCE = 120

func _ready():
	position = player.position

func _process(delta):
	var viewport = get_viewport()
	var mouse_pos = ((viewport.get_mouse_position() / viewport.get_visible_rect().size - Vector2(0.5, 0.5)) * 2).clamp(Vector2(-1, -1), Vector2(1, 1))
	
	var target_position = player.position + mouse_pos * MOUSE_LOOK_DISTANCE
	
	position = lerp(position, target_position, delta * CAMERA_LERP_FAC)
