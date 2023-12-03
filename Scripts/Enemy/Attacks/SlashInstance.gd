extends Area2D

var duration = 1
var knockback = 8

@export var damage: int = 1

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	if duration > 0:
		duration -= delta
	else:
		queue_free()


func _on_Area2D_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		print("player hit")
		body.addImpulse(Vector2(body.global_position.x - get_parent().global_position.x, body.global_position.y - get_parent().global_position.y) * knockback)
		
		body.take_damage(damage) # calls and sends signal to player, triggers highlight and changes HP value
