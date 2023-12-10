extends Node2D
class_name GenericLevelScript

<<<<<<< Updated upstream
@export var exitDoor : Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	exitDoor.connect("leaving_level", Callable(self, "finish_level"))
=======
@export (NodePath) onready var exit = get_node("Objects/Exit")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	exit.connect("leaving_level", Callable(self, "finish_level"))
>>>>>>> Stashed changes

func finish_level():
	print("level finished, changing to select scene")
	get_tree().change_scene_to_file("res://Scenes/Menus/LevelSelect.tscn")
