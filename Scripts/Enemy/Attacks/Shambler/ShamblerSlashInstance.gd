extends Area2D

var duration = 0.375
var knockback = 8
export (int) var damage

export (NodePath) onready var animation_player = get_node(animation_player)

func _ready() -> void:
	animation_player.play("Start")

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
