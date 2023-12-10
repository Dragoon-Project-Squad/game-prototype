extends Node2D

const SPAWN_ROOMS: Array = [preload("res://Scenes/Levels/Rooms/Dungeon_SpawnRoom01.tscn")]
const INTERMEDIATE_ROOMS: Array = [preload("res://Scenes/Levels/Rooms/Dungeon_Room01.tscn")
#,preload("res://Scenes/Levels/Rooms/Dungeon_Room02.tscn"),preload("res://Scenes/Levels/Rooms/Dungeon_Room03.tscn")
]
const SPECIAL_ROOMS: Array = [preload("res://Scenes/Levels/Rooms/Dungeon_Room01.tscn")]
const END_ROOMS: Array = [preload("res://Scenes/Levels/Rooms/Dungeon_SafeRoom.tscn")]

const TILE_SIZE: int = 16
const FLOOR_TILE_INDEX: int = 0
const RIGHT_WALL_TILE_INDEX: int = 5
const LEFT_WALL_TILE_INDEX: int = 6

@export var num_levels: int = 5

@onready var player: Node2D = get_node("Objects/ModulePlayer")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	_spawn_rooms()
	pass # Replace with function body.
	
func _spawn_rooms() -> void:
	var previous_room: Node2D
	var special_room_spawned: bool = false
	
	for i in num_levels:
		var room: Node2D
		
		if i == 0:
			room = SPAWN_ROOMS[randi() % SPAWN_ROOMS.size()].instantiate()
			player.position = room.get_node("SpawnPos").position
		else:
			if i == num_levels - 1:
				room = END_ROOMS[randi() % END_ROOMS.size()].instantiate()
			else:
				if (randi() % 3 == 0 and not special_room_spawned) or (i == num_levels - 2 and not special_room_spawned):
					room = SPECIAL_ROOMS[randi() % SPECIAL_ROOMS.size()].instantiate()
					special_room_spawned = true
				else:
					room = INTERMEDIATE_ROOMS[randi() % INTERMEDIATE_ROOMS.size()].instantiate()
				
			var previous_room_tilemap: TileMap = previous_room.get_node("TileMap")
			var previous_room_door: StaticBody2D = previous_room.get_node("Door")
			var exit_tile_pos: Vector2 = previous_room_tilemap.local_to_map(previous_room_door.position) + Vector2.UP * 2
			
			var corridor_height: int = randi() % 5 + 3
			for y in corridor_height:
				previous_room_tilemap.set_cellv(exit_tile_pos + Vector2(-2, -y), LEFT_WALL_TILE_INDEX)
				previous_room_tilemap.set_cellv(exit_tile_pos + Vector2(-1, -y), FLOOR_TILE_INDEX)
				previous_room_tilemap.set_cellv(exit_tile_pos + Vector2(0, -y), FLOOR_TILE_INDEX)
				previous_room_tilemap.set_cellv(exit_tile_pos + Vector2(1, -y), RIGHT_WALL_TILE_INDEX)
				
			var room_tilemap: TileMap = room.get_node("TileMap")
			room.position = previous_room_door.global_position + Vector2.UP * room_tilemap.get_used_rect().size.y * TILE_SIZE + Vector2.UP * (1 + corridor_height) * TILE_SIZE + Vector2.LEFT * room_tilemap.local_to_map(room.get_node("RoomEntrance").position).x * TILE_SIZE
			
		add_child(room)
		previous_room = room

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
