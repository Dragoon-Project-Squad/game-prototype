extends Node2D

@export var exit : Node
@export var exit_door : Node
signal key_random_pos

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#key_random_pos.emit()
	if exit:
		exit.connect("leaving_level", Callable(self, "finish_level"))
	if exit_door:
		exit_door.connect("leaving_level", Callable(self, "finish_level"))
	
func finish_level():
	print("level finished, changing to select scene")
	get_tree().change_scene_to_file("res://Scenes/Menus/LevelSelect.tscn")
