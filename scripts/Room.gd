extends Node3D

class_name Room

enum Direction {
	LEFT = -1,
	RIGHT = 1,
	UP = -2,
	DOWN = 2
}

@export var top: StaticBody3D = null
@export var left: StaticBody3D = null
@export var down: StaticBody3D = null
@export var right: StaticBody3D = null

func get_side(dir: Direction) -> StaticBody3D:
	match dir:
		Direction.UP:
			return top
		Direction.LEFT:
			return left
		Direction.DOWN:
			return down
		Direction.RIGHT:
			return right
	return null
