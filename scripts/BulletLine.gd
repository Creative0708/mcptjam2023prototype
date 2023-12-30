extends Node3D

@onready var line_renderer = $LineRenderer

@export var LINE_LIFETIME = 0.3
@onready var original_color: Color = line_renderer.material_override.albedo_color

var points = null
var lifetime

func set_points(p):
	if line_renderer == null:
		points = p
	else:
		line_renderer.points = points

func _ready():
	lifetime = LINE_LIFETIME
	if points:
		line_renderer.points = points
	
	line_renderer.material_override = line_renderer.material_override.duplicate()
	line_renderer.mesh = line_renderer.mesh.duplicate()

func _process(delta):
	if not visible:
		return
	
	lifetime -= delta
	if lifetime > 0:
		var new_color = Color(original_color, clamp(original_color.a * lifetime / LINE_LIFETIME, 0, 1))
		line_renderer.material_override.albedo_color = new_color
	else:
		queue_free()
