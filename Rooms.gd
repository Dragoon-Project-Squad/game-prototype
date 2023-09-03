extends Node2D

const SPAWN_ROOMS: Array = [preload("res://Scenes/Levels/Rooms/Dungeon_SpawnRoom01.tscn")]
const INTERMEDIATE_ROOMS: Array = [preload("res://Scenes/Levels/Rooms/Dungeon_Room01.tscn")
#,preload("res://Scenes/Levels/Rooms/Dungeon_Room02.tscn"),preload("res://Scenes/Levels/Rooms/Dungeon_Room03.tscn")
]
const SPECIAL_ROOMS: Array = [preload("res://Scenes/Levels/Rooms/Dungeon_Room01.tscn")]
const END_ROOMS: Array = [preload("res://Scenes/Levels/Rooms/Dungeon_EndRoom01.tscn")]

const TILE_SIZE: int = 64
#const FLOOR_TILE_INDEX: int = 37
#const RIGHT_WALL_TILE_INDEX: int = 0
#const LEFT_WALL_TILE_INDEX: int = 0
const FLOOR_TILE_INDEX: int = 34
const RIGHT_WALL_TILE_INDEX: int = 0
const LEFT_WALL_TILE_INDEX: int = 0


export(int) var num_levels: int = 3

onready var player: Node2D = get_node("Objects/ModulePlayer")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

#Shoutouts to https://github.com/MateuSai, their work helped a lot here

# Called when the node enters the scene tree for the first time.
func _ready():
	_spawn_rooms()
	pass # Replace with function body.
	
func _spawn_rooms() -> void:
	var previous_room: Node2D
	var special_room_spawned: bool = false
	
	for i in num_levels:
		var room: Node2D
		
		#If this is the first room in the level
		if i == 0:
			#Generate a spawn room instance
			room = SPAWN_ROOMS[randi() % SPAWN_ROOMS.size()].instance()
			player.position = room.get_node("SpawnPos").position
		else:
			#If this is the last room in the level
			if i == num_levels - 1:
				#Generate an end room
				room = END_ROOMS[randi() % END_ROOMS.size()].instance()
			else:
				#Potentially add a special room, but only 1
				if (randi() % 3 == 0 and not special_room_spawned) or (i == num_levels - 2 and not special_room_spawned):
					room = SPECIAL_ROOMS[randi() % SPECIAL_ROOMS.size()].instance()
					special_room_spawned = true
				else:
				#Normal room
					room = INTERMEDIATE_ROOMS[randi() % INTERMEDIATE_ROOMS.size()].instance()
			#Identify previous room's tilemap, door, and 	
			var previous_room_tilemap: TileMap = previous_room.get_node("TileMap")
			var previous_room_door: Node2D = previous_room.get_node("Door")
			#We divide by 4 due to using 16x16 cells with 64x64 transformations. If we can unjank the tiles we can unjank this.
			var exit_tile_pos: Vector2 = previous_room_tilemap.world_to_map(previous_room_door.position) / 4
			var corridor_height: int = randi() % 5 + 5
			#Dynamically slap down corridor tiles above the door of the last room
			for y in corridor_height:
				#We add 1 because otherwise the 'corridor' would intersect the edge of the room.
				previous_room_tilemap.set_cellv(exit_tile_pos + Vector2(4, -y-1), LEFT_WALL_TILE_INDEX)
				previous_room_tilemap.set_cellv(exit_tile_pos + Vector2(3, -y-1), FLOOR_TILE_INDEX)
				previous_room_tilemap.set_cellv(exit_tile_pos + Vector2(2, -y-1), FLOOR_TILE_INDEX)
				previous_room_tilemap.set_cellv(exit_tile_pos + Vector2(1, -y-1), FLOOR_TILE_INDEX)
				previous_room_tilemap.set_cellv(exit_tile_pos + Vector2(0, -y-1), RIGHT_WALL_TILE_INDEX)
			#refresh the map afterwards	
			previous_room_tilemap.update_dirty_quadrants()
			var room_tilemap: TileMap = room.get_node("TileMap")
			#get_used_rect is great because it looks at what space HAS been used already
			var lengthofroom = Vector2.UP * room_tilemap.get_used_rect().size.y * TILE_SIZE
			var lengthofcorridor = Vector2.UP * (corridor_height) * TILE_SIZE
			#Due to some odd tile math involving cells and transformations we DO NOT multiply this by TILE SIZE.
			var roomwidthtoetrance = Vector2.LEFT * room.get_node("RoomEntrance").position.x
			#Coords For New Room = Old Room's Door + Width From Wall To Entrance for X and Cooridor + New Room Length for Y
			room.position = previous_room_door.global_position + lengthofroom + lengthofcorridor + roomwidthtoetrance
		#Finally, add the room instance as a child node
		add_child(room)
		previous_room = room

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
