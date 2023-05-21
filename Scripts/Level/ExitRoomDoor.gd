extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal exit_door_opened
var isOpen = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("Interact"):
		if (isOpen):
			emit_signal("exit_door_opened")
			queue_free()
		#else:
			#This is the part where we play the funny door stuck sound
	
