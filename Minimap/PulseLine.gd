extends Area2D

func _ready():
	print("started")

func _on_Area2D_body_entered(body: Node) -> void:
	body.show_marker()
