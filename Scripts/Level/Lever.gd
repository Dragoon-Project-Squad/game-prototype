extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal lever_set(oldval, newval)
var isLeverActive = false;
# Called when the node enters the scene tree for the first time.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("Interact"):
		if (!isLeverActive): 
			emit_signal("lever_set", 0, 1)
			isLeverActive = true;
		else:
			emit_signal("lever_set", 1, 0)
			isLeverActive = false;
		#Cosmetic lever effects go here.
