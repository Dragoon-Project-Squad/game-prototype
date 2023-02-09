extends Node2D

const Player = preload("res://Player/ModulePlayer.tscn")
const Exit = preload("res://RandomStageTest/Exit.tscn")
var borders = Rect2(1, 1, 50, 50)

var tilesize = 64

onready var tileMap = $TileMap

func _ready():
	randomize()
	generate_level()
	
func generate_level():
	var walker = Walker.new(Vector2(25, 25), borders, 3, 9) # start pos, borders, min room size, max room size
	var map = walker.walk(500) #number of steps
	
	var player = Player.instance()
	add_child(player)
	player.get_child(0).position = map.front()*tilesize
	
	var exit = Exit.instance()
	add_child(exit)
	exit.position = walker.get_furthest_room().position*tilesize
	exit.connect("leaving_level", self, "reload_level")
	
	walker.queue_free()
	for location in map:
		tileMap.set_cellv(location, -1)
	tileMap.update_bitmask_region(borders.position, borders.end)

func reload_level():
	get_tree().reload_current_scene()
