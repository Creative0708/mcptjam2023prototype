
class_name Upgrade

@export var icon: Texture2D
@export_multiline var description: String

var player: Player
var gun: Gun

func _init(p: Player, g: Gun):
	player = p
	gun = g

func apply_upgrade():
	push_error("apply_upgrade() should be overridden")
