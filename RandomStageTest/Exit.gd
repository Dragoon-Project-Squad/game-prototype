extends Area2D

#minimap
var minimap_icon = "objective"

signal leaving_level

func _on_Exit_body_entered(body: Node) -> void:
	print(body.get_parent())
	emit_signal("leaving_level")