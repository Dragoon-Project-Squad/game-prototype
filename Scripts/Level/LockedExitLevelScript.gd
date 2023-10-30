extends Node2D

@export (NodePath) onready var exit = get_node("Objects/KeyLockedExit")
@export (NodePath) onready var exitDoor = get_node("Objects/ExitDoor")
signal key_randomPos

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	emit_signal("key_randomPos")
	exit.connect("leaving_level", Callable(self, "finish_level"))
	exitDoor.connect("leaving_level", Callable(self, "finish_level"))
	
func finish_level():
	print("level finished, changing to select scene")
	get_tree().change_scene_to_file("res://Scenes/Menus/LevelSelect.tscn")
