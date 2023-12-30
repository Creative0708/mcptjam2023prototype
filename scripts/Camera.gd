extends Camera3D

class_name Camera

@export_flags_3d_physics var enemy_mask: int

static var camera: Camera

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

func _world_to_viewport_space(pos: Vector3) -> Vector2:
	return camera.unproject_position(pos)

func _world_to_screen_space(pos: Vector3) -> Vector2:
	# i have no idea how any of this works but i found this out through trial and error
	# and therefore this is sacred knowledge and should not be touched
	
	var viewport_size = get_viewport().get_visible_rect().size
	var window_size = Vector2(get_window().size)
	var content_scale_size = Vector2(get_tree().root.content_scale_size)
	
	var ratio = viewport_size / content_scale_size
	var raw_position = get_viewport().get_screen_transform() * camera.unproject_position(pos)
	
	if ratio.x >= ratio.y:
		return raw_position / ratio.y
	else:
		return raw_position * window_size / viewport_size / ratio.x
	

static func world_mouse_pos():
	return camera._world_mouse_pos()

static func world_to_viewport_space(pos: Vector3) -> Vector2:
	return camera._world_to_viewport_space(pos)

static func world_to_screen_space(pos: Vector3) -> Vector2:
	return camera._world_to_screen_space(pos)

# Should be called in _physics_process()
func get_mouse_enemy_target():
	var space_state = get_world_3d().direct_space_state
	var raw_mouse_pos = get_viewport().get_mouse_position()
	var origin = Camera.camera.project_ray_origin(raw_mouse_pos)
	var normal = Camera.camera.project_ray_normal(raw_mouse_pos)
	
	var query = PhysicsRayQueryParameters3D.create(origin, origin + normal * 200.0, enemy_mask)
	
	var result = space_state.intersect_ray(query)
	if result.is_empty():
		return null
	return result.collider
