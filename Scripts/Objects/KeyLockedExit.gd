extends Area2D

#minimap
var minimap_icon = "objective"

signal key_checked
signal leaving_level
var isOpen = false
var isNearExit = false

func _process(_delta):
	if isNearExit:
		if Input.is_action_just_pressed("Interact"):
			if isOpen:
				emit_signal("leaving_level")
			else:
				emit_signal("key_checked")

func _on_Exit_body_entered(_body: Node) -> void:
	print("You entered the door's area. The door is: ")
	print(isOpen)
	isNearExit = true

func _on_KeyLockedExit_body_exited(_body):
	print("You exited the door's area. The door is: ")
	print(isOpen)
	isNearExit = false

func _on_ModulePlayer_door_stuck():
	print("DOOR STUCK: Not enough keys.")
	#Play door locked sound


func _on_ModulePlayer_key_used():
	isOpen = true
	$ColorRect.color = Color(0.8, 0.1, 0.9, 1)
	print("The path is open.")
	#Play opening sound



