extends ReferenceRect

var RELOAD_BAR_SIZE

var ammo_label
var ammo_indicator

func update(num_ammo: int, max_ammo: int, reload_progress: float):
	if ammo_label == null:
		ammo_label = $"Ammo Label"
		ammo_indicator = $"Ammo Indicator"
		RELOAD_BAR_SIZE = ammo_indicator.size.x
	
	ammo_label.text = "[right]%d/%d[/right]" % [num_ammo, max_ammo]
	ammo_indicator.size.x = reload_progress * RELOAD_BAR_SIZE
