extends Marker2D

@onready var player = $"../SubViewportContainer/SubViewport/Player"

const TRACKING_LERP_FAC = 30

func _process(delta):
	var target_pos = Camera.world_to_screen_space(player.position)
	position = lerp(position, target_pos, TRACKING_LERP_FAC * delta)
