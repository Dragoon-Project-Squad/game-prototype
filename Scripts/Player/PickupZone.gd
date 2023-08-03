extends Area2D

signal tru

func _ready():
	pass

func _on_Pick_up_Zone_body_entered(body: Node) -> void:
	if ! body.is_in_group("Item"):
		if Input.is_action_pressed("Pickup"):
			emit_signal("tru")
			get_parent().queue_free()

func _on_Pick_up_Zone_body_exited(body: Node) -> void:
	 pass
