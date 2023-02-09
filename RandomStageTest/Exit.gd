extends Area2D

signal leaving_level

func _on_Exit_body_entered(body: Node) -> void:
	emit_signal("leaving_level")
