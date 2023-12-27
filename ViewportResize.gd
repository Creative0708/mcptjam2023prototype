extends SubViewportContainer

@onready var sub_viewport = $SubViewport

func resize():
	var viewport_size = get_viewport_rect().size
	size = viewport_size
	sub_viewport.size = viewport_size
	position.y = -(sqrt(2) - 1) / 2 * viewport_size.y

func _ready():
	get_tree().root.size_changed.connect(resize)
	resize()
