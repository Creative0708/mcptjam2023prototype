extends Node3D

@export var mass = 1.0
@export var gravity = 100.0
@export var damping = 3

var previous_position
var angular_velocity = 0
var rot = 0

func _ready():
	previous_position = global_position

func _process(delta):
	var velocity: Vector3 = (global_position - previous_position) / delta
	
	angular_velocity -= velocity.rotated(Vector3.FORWARD, global_rotation.z).x * mass
	
	angular_velocity -= sin(rot) * gravity * delta
	angular_velocity *= 1 - (damping * delta)
	
	rot += angular_velocity * delta
	global_rotation.z = cos(global_rotation.y) * rot
	
	previous_position = global_position
	scale = Vector3(1, 1, 1)
