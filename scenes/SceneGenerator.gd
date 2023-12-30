extends Marker3D

@export var possible_rooms: Array[Room]

var remaining_possible_rooms = null
var generated_rooms = null

enum Direction {
	LEFT = -1,
	RIGHT = 1,
	UP = -2,
	DOWN = 2,
	NONE = 0
}

func get_room_that_has(side: Direction):
	var rooms_that_have
	if side != Direction.NONE:
		rooms_that_have = remaining_possible_rooms.filter(func(room): return room.get_side(side))
	else:
		rooms_that_have = remaining_possible_rooms
	if len(rooms_that_have) == 0:
		return null
	return rooms_that_have[randi() % len(rooms_that_have)]

func get_room_at(x: int, y: int):
	var filtered = generated_rooms.filter(func(room_data): return room_data[0] == x && room_data[1] == y)
	assert(len(filtered) <= 1)
	return null if len(filtered) == 0 else filtered[0]

func generate_rooms(main_path: int, offshoots: int):
	remaining_possible_rooms = possible_rooms.duplicate()
	remaining_possible_rooms.shuffle()
	
	generated_rooms = []
	
	var possible_placements = [[0, 0, Direction.NONE]]
	
	for i in main_path:
		if len(possible_placements) == 0:
			push_warning("no more possible placements, did something go wrong?")
			break
		var idx = randi() % possible_placements
		var placement = possible_placements[idx]
		possible_placements.remove_at(idx)
		
	
	remaining_possible_rooms = null
