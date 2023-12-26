extends Sprite2D
@onready var player = $"../Player"
var loop_num = 0
var framesL
var framesR
var sprite
# Called when the node enters the scene tree for the first time.
func _ready():
	framesL = [
		load("res://present-1/pixil-frame-0.png"),
		load("res://present-1/pixil-frame-1.png"),
		load("res://present-1/pixil-frame-2.png"),
		load("res://present-1/pixil-frame-3.png"),
	]
	
	framesR = [
		load("res://present-2/pixil-frame-0.png"),
		load("res://present-2/pixil-frame-1.png"),
		load("res://present-2/pixil-frame-2.png"),
		load("res://present-2/pixil-frame-3.png"),
	]
	sprite = Sprite2D.new()
	sprite.visible = true
	player.position.x = 10
	player.position.y = 10


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	sprite.texture = load("res://present-1/pixil-frame-0.png")
	
	#loop_num += 1
	#if loop_num > 12:
#		loop_num = 0
#	sprite.position = Vector2(move_toward(sprite.position.x, player.position.x, 500),move_toward(sprite.position.y, player.position.y, 500))
#	if player.position.x > sprite.position.x:
#		sprite.texture = framesR[floor(loop_num/4)]
#	else:
#		sprite.texture = framesL[floor(loop_num/4)]
