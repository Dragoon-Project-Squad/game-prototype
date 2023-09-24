extends Node2D
class_name GenericLevelScript

export (NodePath) onready var exitDoor = $ExitDoor

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	exitDoor.connect("leaving_level", self, "finish_level")

func finish_level():
	print("level finished, changing to select scene")
	get_tree().change_scene("res://Scenes/Menus/LevelSelect.tscn")
