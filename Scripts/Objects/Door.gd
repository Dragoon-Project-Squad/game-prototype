extends Node2D
class_name DragoonGameDoor
#0 for Closed, 1 for Open
signal door_used(oldval, newval)
var is_near_door = false
var is_open = false
@onready var door_sprite: Sprite2D = $DoorSprite
@onready var door_collision: CollisionShape2D = $BlockCollision/CollisionShape2D
# Called when the node enters the scene tree for the first time.
func _ready():
	door_sprite.frame = 0
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if is_near_door:
		if Input.is_action_just_pressed("Interact"):
			if (!is_open):
				emit_signal("door_used", 0, 1)
				open_door()
			else:
				emit_signal("door_used", 1, 0)
				close_door()
			#Enable this if the door isn't refreshing 
			#doorTiles.update_dirty_quadrants()
		#else:
			#The door won't do anything.
	
func open_door():
	is_open = true
	door_sprite.frame = 1
	if door_collision:
		door_collision.set_deferred("disabled", true)
	else:
		print("Door Collision data not found!")
	#TODO: (Audio) Door open sound
	
func close_door():
	is_open = false
	door_sprite.frame = 0
	if door_collision:
		door_collision.set_deferred("disabled", false)
	else:
		print("Door Collision data not found!")
	#TODO: (Audio) Door close sound
	
func _on_door_area_body_entered(_body):
	if _body.is_in_group("Player"):
		self.is_near_door = true


func _on_door_area_body_exited(_body):
	if _body.is_in_group("Player"):
		self.is_near_door = false
