extends Sprite2D
@onready var player = $"../Player"
var sprite


# Called when the node enters the scene tree for the first time.
func _ready():
	sprite = Sprite2D.new()
	sprite.position.x = 5
	sprite.position.y = 5


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	sprite.position.x = move_toward(sprite.position.x, player.position.x, 500)
	sprite.position.y = move_toward(sprite.position.y, player.position.y, 500)
