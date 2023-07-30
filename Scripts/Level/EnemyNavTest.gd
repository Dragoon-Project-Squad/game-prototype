extends Node2D

export (NodePath) onready var player = get_node(player)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.get_node("PlayerUI/Minimap").getMapObjects()

func finish_level():
	print("level finished, changing to select scene")
	get_tree().change_scene("res://Scenes/Menus/LevelSelect.tscn")