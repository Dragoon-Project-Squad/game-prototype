extends Node2D

const Player = preload("res://Player/ModulePlayer.tscn")
const Exit = preload("res://RandomStageTest/Exit.tscn")
const Enemy = preload("res://RandomStageTest/DummyEnemy.tscn")
var borders = Rect2(1, 1, 50, 50)

var tilesize = 64.0

onready var tileMap = $TileMap

func _ready():
	randomize()
	generate_level()
	
func generate_level():
	var walker = Walker.new(Vector2(25, 25), borders, 6, 9) # start pos, borders, min room size, max room size
	var map = walker.walk(500) #number of steps
	walker.place_room(map.front())
	
	var player = Player.instance()
	add_child(player)
	player.get_child(0).position = (map.front() * tilesize) + Vector2(tilesize/2, tilesize/2)	#added half-tile offset to prevent spawning in walls
	print("Player Start Position")
	print(player.get_child(0).position / tilesize)
	
	var exit = Exit.instance()
	add_child(exit)
	exit.position = walker.get_furthest_room().position*tilesize	#no idea why the exit doesn't need an offset to align properly, might be something to do with godot's Area2D object
	exit.connect("leaving_level", self, "reload_level")
	print("Exit Position")
	print(exit.position / tilesize)
	
	var randenemypos = [-1]
	print("Enemy Positions")
	var MIN = 10
	var MAX = 20
	for n in randi() % (MAX - MIN) + MIN:
		var enemy = Enemy.instance()
		add_child(enemy)
		var enemypos = -1
		while randenemypos.has(enemypos):
			enemypos = randi() % (map.size() - 10) + 10
		enemy.position = (map[enemypos]*tilesize) + Vector2(tilesize/2, tilesize/2)		#added half-tile offset to prevent spawning in walls
		print(enemy.position / tilesize)
		randenemypos.append(enemypos)
	
	
	walker.queue_free()
	for location in map:
		tileMap.set_cellv(location, -1)
	tileMap.update_bitmask_region(borders.position, borders.end)
	
	player.get_node("PlayerUI/Minimap").getMapObjects()

func reload_level():
	get_tree().reload_current_scene()
