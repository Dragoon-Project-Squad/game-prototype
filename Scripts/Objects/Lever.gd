extends HiddenObject

signal lever_set(oldval, newval)
var isLeverActive = false;
var isNearLever = false

func _process(_delta):
	if isNearLever:
		if Input.is_action_just_pressed("Interact"):
			if (!isLeverActive): 
				emit_signal("lever_set", 0, 1)
				print("Lever is set to 1")
				isLeverActive = true;
			else:
				emit_signal("lever_set", 1, 0)
				print("Lever is set to 0")
				isLeverActive = false;
			#Cosmetic lever effects go here.
			

func _on_LeverArea_body_entered(_body):
	isNearLever = true


func _on_LeverArea_body_exited(_body):
	isNearLever = false
