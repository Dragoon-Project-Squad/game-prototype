extends DragoonGameDoor

signal entry_door_opened
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if is_near_door:
		if Input.is_action_just_pressed("Interact"):
			emit_signal("entry_door_opened")
			#TODO: (AUDIO) Play Door sounds here
			get_node("DoorArea/DoorCollision").queue_free()
			#Set Door Sprite to the open door, hardcoded
			door_tiles.set_cell(0, Vector2.ZERO, 1, Vector2i.ZERO)
			#Enable this if the door isn't refreshing 
			#doorTiles.update_dirty_quadrants()
		#else:
			#The door won't do anything.
	
func _on_DoorArea_body_entered(_body):
	super._on_DoorArea_body_entered(_body)


func _on_DoorArea_body_exited(_body):
	super._on_DoorArea_body_exited(_body)
