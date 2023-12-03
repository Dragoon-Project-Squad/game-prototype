extends Area2D

#minimap
var minimap_icon = "objective"

signal leaving_level

func _on_Exit_body_entered(_body: Node) -> void:
	#ONLY IF THE OBJECT COLLIDING WITH ME IS SELEN DO I
	if _body.is_in_group("Player"):
		emit_signal("leaving_level")
