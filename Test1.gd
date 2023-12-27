extends Sprite2D

@onready var player = $"../Player"

const MOVEMENT_SPEED = 200

func _ready():
	position.x = 5
	position.y = 5


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x = move_toward(position.x, player.position.x, MOVEMENT_SPEED * delta)
	position.y = move_toward(position.y, player.position.y, MOVEMENT_SPEED * delta)
