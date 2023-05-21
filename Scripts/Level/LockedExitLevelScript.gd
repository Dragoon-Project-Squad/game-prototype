extends Node2D

export (NodePath) onready var exit = get_node("Objects/KeyLockedExit")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	exit.connect("leaving_level", self, "finish_level")

func finish_level():
	print("level finished, changing to select scene")
	get_tree().change_scene("res://Scenes/Menus/LevelSelect.tscn")
