extends Camera3D

class_name Camera

static var camera: Camera3D

func _init():
	camera = self

var last_calculation_frame
var mouse_pos

func _world_mouse_pos():
	var calculation_frame = Engine.get_process_frames()
	if calculation_frame == last_calculation_frame:
		return mouse_pos
	last_calculation_frame = calculation_frame
	var plane = Plane(Vector3.UP, 0)
	var raw_mouse_pos = get_viewport().get_mouse_position()
	mouse_pos = plane.intersects_ray(project_ray_origin(raw_mouse_pos), project_ray_normal(raw_mouse_pos))
	return mouse_pos

static func world_mouse_pos():
	return camera._world_mouse_pos()

static func world_to_screen_space(pos: Vector3) -> Vector2:
	return camera.unproject_position(pos)
