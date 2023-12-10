extends Node2D

<<<<<<< Updated upstream
@export var exit : Node
@export var exitDoor : Node
=======
@export (NodePath) onready var exit = get_node("Objects/KeyLockedExit")

>>>>>>> Stashed changes
signal key_randomPos

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	emit_signal("key_randomPos")
	exit.connect("leaving_level", Callable(self, "finish_level"))
<<<<<<< Updated upstream
	exitDoor.connect("leaving_level", Callable(self, "finish_level"))
	
=======

>>>>>>> Stashed changes
func finish_level():
	print("level finished, changing to select scene")
	get_tree().change_scene_to_file("res://Scenes/Menus/LevelSelect.tscn")
