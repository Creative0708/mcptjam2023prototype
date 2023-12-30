extends CanvasLayer

signal okay

func _on_ok_button_pressed():
	okay.emit()
