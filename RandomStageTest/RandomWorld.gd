extends Node2D

const Player = preload("res://Player/ModulePlayer.tscn")
const Exit = preload("res://RandomStageTest/Exit.tscn")
const Enemy = preload("res://RandomStageTest/DummyEnemy.tscn")
var borders = Rect2(1, 1, 50, 50)

var tilesize = 64

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
	player.get_child(0).position = map.front()*tilesize
	
	var exit = Exit.instance()
	add_child(exit)
	exit.position = walker.get_furthest_room().position*tilesize
	exit.connect("leaving_level", self, "reload_level")
	
	var randenemypos = [-1]
	for n in rand_range(10,20):
		var enemy = Enemy.instance()
		add_child(enemy)
		var enemypos = -1
		while randenemypos.has(enemypos):
			enemypos = rand_range(10, map.size())
		enemy.position = map[enemypos]*tilesize
		randenemypos.append(enemypos)
	
	
	walker.queue_free()
	for location in map:
		tileMap.set_cellv(location, -1)
	tileMap.update_bitmask_region(borders.position, borders.end)
	
	player.get_node("PlayerUI/Minimap").getMapObjects()

func reload_level():
	get_tree().reload_current_scene()
