extends Node3D

@export var mass = 1.0
@export var gravity = 100.0
@export var damping = 3

var previous_position
var angular_velocity = 0

func _ready():
	previous_position = global_position

func _process(delta):
	var velocity: Vector3 = (global_position - previous_position) / delta
	
	angular_velocity -= velocity.rotated(Vector3.FORWARD, global_rotation.z).x * mass
	
	angular_velocity -= sin(global_rotation.z) * gravity * delta
	angular_velocity *= 1 - (damping * delta)
	
	global_rotation.z += angular_velocity * delta
	
	previous_position = global_position
	scale = Vector3(1, 1, 1)
