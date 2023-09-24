extends HiddenObject

signal lever_set(oldval, newval)
var isLeverActive = false
var isNearLever = false

func _process(_delta):
	if Input.is_action_just_pressed("Interact"):
		if isNearLever:
			if (!isLeverActive): 
				emit_signal("lever_set", 0, 1)
				isLeverActive = true;
			else:
				emit_signal("lever_set", 1, 0)
				isLeverActive = false;
			#Cosmetic lever effects go here.
		#else:
			#print("ligma")

func _on_LeverArea_body_entered(_body):
	if _body.is_in_group("Player"):
		isNearLever = true


func _on_LeverArea_body_exited(_body):
	if _body.is_in_group("Player"):
		isNearLever = false
