extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal key_acquired

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", Callable(get_parent(), "body_entered"))
	connect("body_exited", Callable(get_parent(), "body_exited"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
