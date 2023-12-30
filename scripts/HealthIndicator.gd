extends ReferenceRect

var RELOAD_BAR_SIZE

var hp_label

func update(hp: int, max_hp: int):
	if hp_label == null:
		hp_label = $"Health Label"
	
	hp_label.text = "[right]%d/%d HP[/right]" % [hp, max_hp]
