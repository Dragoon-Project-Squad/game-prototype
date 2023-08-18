extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal entry_door_opened

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("Interact"):
		emit_signal("entry_door_opened")
		#TODO: (AUDIO) Play Door sounds here
		queue_free()
		#else:
			#This is the part where we play the funny door open slam sound
	
