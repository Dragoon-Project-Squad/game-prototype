extends Node
class_name Walker

const DIRECTIONS = [Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN]

var position = Vector2.ZERO
var direction = Vector2.RIGHT
var borders = Rect2()
var step_hist = []
var steps_since_turn = 0
var rooms = []

var min_room_size
var max_room_size

func _init(starting_position, new_borders, min_room, max_room):
	assert(new_borders.has_point(starting_position))
	position = starting_position
	step_hist.append(position)
	borders = new_borders
	min_room_size = min_room
	max_room_size = max_room

func walk(steps):
	for step in steps:
		if randf() <= 0.5 and steps_since_turn >= 10: #logic for changing walker direction, change to make rooms more or less common
			change_direction()
			
		if step():
			step_hist.append(position)
		else:
			change_direction()
	return step_hist
	
func step():
	var target_position = position + direction
	if borders.has_point(target_position):
		steps_since_turn += 1
		position = target_position
		return true
	else:
		return false
	
func change_direction():
	place_room(position)
	steps_since_turn = 0
	var directions = DIRECTIONS.duplicate()
	directions.erase(direction)
	directions.shuffle()
	direction = directions.pop_front()
	while not borders.has_point(position + direction):
		direction = directions.pop_front()

func create_room(position, size):
	return {position = position, size = size}

func place_room(position):
	randomize()
	var size = Vector2(rand_range(min_room_size, max_room_size), rand_range(min_room_size, max_room_size))
	var top_left = (position - size/2).ceil()
	rooms.append(create_room(position, size))
	for y in size.y:
		for x in size.x:
			var new_step = top_left + Vector2(x, y)
			if borders.has_point(new_step):
				step_hist.append(new_step)

func get_furthest_room():
	var furthest_room = rooms.pop_front()
	var start_pos = step_hist.front()
	for room in rooms:
		if start_pos.distance_to(room.position) > start_pos.distance_to(furthest_room.position):
			furthest_room = room
	return furthest_room

func get_mapdata():
	return step_hist
