extends Node3D

@onready var player = $"../Player"
@onready var game = $"../../.."

const CAMERA_LERP_FAC = 10
const MOUSE_LOOK_DISTANCE = 1.5

var pos2d
var target_position

func _ready():
	pos2d = Vector2(player.position.x, player.position.z)
	target_position = Vector2(player.position.x, player.position.z)

func _process(delta):
	if not game.paused:
		var viewport = get_viewport()
		var mouse_pos = ((viewport.get_mouse_position() / viewport.get_visible_rect().size - Vector2(0.5, 0.5)) * 2).clamp(Vector2(-1, -1), Vector2(1, 1))
		
		target_position = Vector2(player.position.x, player.position.z) + mouse_pos * MOUSE_LOOK_DISTANCE
	
	pos2d = lerp(pos2d, target_position, delta * CAMERA_LERP_FAC)
	
	position = Vector3(pos2d.x, 0.0, pos2d.y)
