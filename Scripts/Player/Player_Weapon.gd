extends Node2D

var equipped

func _ready():
	if get_child(0) != null:
		equipped = get_child(0)

func _process(delta):
	if equipped:
		equipped.pointToMouse()

#Aesthetics
@export var WEAPON_ROTATE_LERP_CONSTANT := 0.1
var shootDirection: Vector2

func setEquippedWeapon(name):
	equipped = null
	for n in get_children():
		remove_child(n)
		n.queue_free()
	
	var newWeapon = load("res://Scenes/Player/Weapons/" + name + ".tscn").instantiate()
	add_child(newWeapon)
	equipped = newWeapon
