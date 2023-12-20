extends DragoonGameDoor

signal exit_door_used(oldval, newval)
signal leaving_level
var can_exit = false

func _ready():
	pass

func _process(_delta):
	if self.is_near_door:
		if Input.is_action_just_pressed("Interact"):
			print("Door checked.")
			if (!is_open):
				print("Opening door...")
				exit_door_used.emit(0,1)
				open_door()
			else:
				print("Closing door...")
				exit_door_used.emit(1,0)
				#emit_signal("exit_door_used", 1, 0)
				close_door()
		#else:
			#The door won't do anything.
	if (can_exit && Input.is_action_just_pressed("Interact") && is_open):
		#Run level clear stuff
		super.close_door()
		leaving_level.emit()
	
		
func _on_DoorAreaTop_body_entered(_body):
	if _body.is_in_group("Player"):
		can_exit = true

func _on_DoorAreaTop_body_exited(_body):
	if _body.is_in_group("Player"):
		can_exit = false
