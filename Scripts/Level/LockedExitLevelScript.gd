extends Node2D

export (NodePath) onready var exit = get_node("Objects/KeyLockedExit")

signal key_randomPos

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	emit_signal("key_randomPos")
	exit.connect("leaving_level", self, "finish_level")

func finish_level():
	print("level finished, changing to select scene")
	get_tree().change_scene("res://Scenes/Menus/LevelSelect.tscn")
