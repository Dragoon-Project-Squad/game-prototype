extends Node2D

const Player = preload("res://Scenes/Player/ModulePlayer.tscn")
const Exit = preload("res://Scenes/Scene Objects/Exit.tscn")
const Enemy = preload("res://Scenes/Enemy/EnemyDragoon.tscn")
var borders = Rect2(1, 1, 50, 50)

var tilesize = 64.0

@onready var tileMap = $TileMap

func _ready():
	randomize()
	generate_level()
	
func generate_level():
	var walker = DGOldWalker.new(Vector2(25, 25), borders, 6, 9) # start pos, borders, min room size, max room size
	var map = walker.walk(500) #number of steps
	walker.place_room(map.front())
	
	var player = Player.instantiate()
	add_child(player)
	player.get_child(0).position = (map.front() * tilesize) + Vector2(tilesize/2, tilesize/2)	#added half-tile offset to prevent spawning in walls
	
	var exit = Exit.instantiate()
	add_child(exit)
	exit.position = walker.get_furthest_room().position*tilesize	#no idea why the exit doesn't need an offset to align properly, might be something to do with godot's Area2D object
	exit.connect("leaving_level", Callable(self, "finish_level"))
	
	var randenemypos = [-1]
	var MIN = 10
	var MAX = 20
	for n in randi() % (MAX - MIN) + MIN:
		var enemy = Enemy.instantiate()
		add_child(enemy)
		var enemypos = -1
		while randenemypos.has(enemypos) || map[enemypos] == walker.get_furthest_room().position:
			enemypos = randi() % (map.size() - 10) + 10
		enemy.position = (map[enemypos]*tilesize) + Vector2(tilesize/2, tilesize/2)		#added half-tile offset to prevent spawning in walls
		randenemypos.append(enemypos)
	
	
	walker.queue_free()
	for location in map:
		tileMap.set_cellv(location, -1)
	tileMap.update_bitmask_region(borders.position, borders.end)
	
	player.get_node("PlayerUI/Minimap").getMapObjects()

func finish_level():
	print("level finished, changing to select scene")
	get_tree().change_scene_to_file("res://Scenes/Menus/LevelSelect.tscn")
