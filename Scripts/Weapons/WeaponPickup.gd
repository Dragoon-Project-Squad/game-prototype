extends HiddenObject
@export var weaponResource: Resource

func _ready():
	setup()

func setup():
	var Hitbox = get_node("Area2D")
	
	Hitbox.connect("body_entered", Callable(self, "on_area2d_area_entered"))

func on_area2d_area_entered(body):
	if body.is_in_group("Player"):
		body.get_parent().weapon.setNewWeapon(weaponResource)
		
		queue_free()
