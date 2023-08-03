extends Node2D

export (NodePath) onready var sprite_node = get_node(sprite_node)
export (NodePath) onready var sprite_highlight_node = get_node(sprite_highlight_node)

#data to be saved between scenes
var path_number = -1;
var col = -1;
var saved_pos;
var content = "";
var next_node_pos = [];

#data for pathing logic
var nextNodes = [];
var prevNodes = [];
var blockedNodes = [];
var isStart = false;
var isEnd = false;
var can_cross_up = true;
var can_cross_down = true;
var isNext = false;

func _ready() -> void:
	pass

func setContent(con):
	var boss_icon = preload("res://Assets/UI/LevelIcons/boss-icon.png")
	var combat_icon = preload("res://Assets/UI/LevelIcons/combat-icon.png")
	var scavenge_icon = preload("res://Assets/UI/LevelIcons/scavenge-icon.png")
	var shop_icon = preload("res://Assets/UI/LevelIcons/shop-icon.png")
	
	if con == "boss":
		content = "boss"
		sprite_node.set_texture(boss_icon)
	if con == "combat":
		content = "combat"
		sprite_node.set_texture(combat_icon)
	if con == "scavenge":
		content = "scavenge"
		sprite_node.set_texture(scavenge_icon)
	if con == "shop":
		content = "shop"
		sprite_node.set_texture(shop_icon)

func setHighlightSprite(isPath):
	var circle_icon = preload("res://Assets/UI/LevelIcons/encircle-icon.png")
	var cross_icon = preload("res://Assets/UI/LevelIcons/cross-icon.png")
	
	if isPath:
		sprite_highlight_node.set_texture(circle_icon)
	else:
		sprite_highlight_node.set_texture(cross_icon)

func _on_ColorRect_mouse_entered() -> void:
	if get_node("/root/LevelSelect") && isNext:
		sprite_node.scale.x = 1.3
		sprite_node.scale.y = 1.3
		get_node("/root/LevelSelect").hoveredNode = self

func _on_ColorRect_mouse_exited() -> void:
	if get_node("/root/LevelSelect"):
		sprite_node.scale.x = 1
		sprite_node.scale.y = 1
		get_node("/root/LevelSelect").hoveredNode = null
