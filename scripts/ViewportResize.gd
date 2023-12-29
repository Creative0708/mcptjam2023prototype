extends SubViewportContainer

@onready var sub_viewport = $SubViewport

func resize():
	var window_size = Vector2(get_window().size)
	var viewport_size = get_viewport_rect().size
	size = window_size
	scale = viewport_size / window_size * Vector2(1, sqrt(2))

func _ready():
	get_tree().root.size_changed.connect(resize)
	resize()
