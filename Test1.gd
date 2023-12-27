extends Sprite2D

@onready var player = $"../Player"

const MOVEMENT_SPEED = 300

func _ready():
	position = Vector2(5, 5)

func _process(delta):
	var target_offset: Vector2 = player.position - position
	var speed_this_frame = MOVEMENT_SPEED * delta
	var movement = target_offset
	# if the enemy is farther away than it can move, restrain its movement
	if movement.length() > speed_this_frame:
		movement *= speed_this_frame / target_offset.length()
	
	position += movement
