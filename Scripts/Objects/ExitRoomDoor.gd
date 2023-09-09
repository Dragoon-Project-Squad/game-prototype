extends Node2D

signal exit_door_used(oldval, newval)
signal leaving_level
var isOpen = false
var isNearDoor = false
var canExit = false
onready var doorTiles: TileMap = $"DoorSprite"

func _ready():
	pass

func _process(delta):
	if isNearDoor:
		if Input.is_action_just_pressed("Interact"):
			if (!isOpen):
				emit_signal("exit_door_used", 0, 1)
				isOpen = true
				#TODO: (AUDIO) Play Door Open sounds here
				#Set Door Sprite to the open door, hardcoded
				doorTiles.set_cell(0, 0, 1)
			else:
				emit_signal("exit_door_used", 1, 0)
				isOpen = false
				#TODO: (AUDIO) Play Door Closed sounds here
				#Set Door Sprite to the closed door, hardcoded
				doorTiles.set_cell(0, 0, 0)
			#Enable this if the door isn't refreshing 
			#doorTiles.update_dirty_quadrants()
		#else:
			#The door won't do anything.
	if canExit && Input.is_action_just_pressed("Interact") && isOpen:
		#Run level clear stuff
		emit_signal("leaving_level")
		
func _on_DoorAreaBottom_body_entered(_body):
	isNearDoor = true

func _on_DoorAreaBottom_body_exited(_body):
	isNearDoor = false
	
func _on_DoorAreaTop_body_entered(_body):
	canExit = true

func _on_DoorAreaTop_body_exited(_body):
	canExit = false
