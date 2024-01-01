extends Node2D
class_name GenericLevelScript

@onready var exit_door = $Objects/ExitDoor

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if exit_door:
		exit_door.leaving_level.connect(finish_level)
	else:
		print("Door data not found! Can't connect signal.")

func finish_level():
	print("level finished, changing to select scene")
	#TODO: Tell Level Select we finished the level
	get_tree().change_scene_to_file("res://Scenes/Menus/LevelSelect.tscn")

