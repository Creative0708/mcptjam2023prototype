extends Gun

func fire_if_needed():
	if Input.is_action_pressed("fire"):
		fire()
		return true
