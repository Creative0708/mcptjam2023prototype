extends Button

@onready var game_intro = $"../../.."

@export_multiline var tooltip: String

func _ready():
	mouse_entered.connect(menter)
	mouse_exited.connect(mexit)

func menter():
	game_intro.set_tooltip(tooltip)

func mexit():
	game_intro.set_tooltip("")
