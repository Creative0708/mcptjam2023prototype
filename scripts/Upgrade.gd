extends Node



var player

func _init(p: Player):
	player = p

func apply_upgrade():
	push_error("apply_upgrade() should be overridden")

func get_icon():
	push_error("get_icon() should be overridden")
	return null
