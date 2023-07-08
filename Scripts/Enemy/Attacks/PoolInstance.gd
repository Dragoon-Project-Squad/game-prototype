extends Node2D

export (NodePath) onready var hitbox = get_node(hitbox)

var growth_rate = 2
var duration = 5
var is_spreading = true

func _ready() -> void:
	hitbox.connect("body_entered", self, "onBodyEnteredHitbox")

func _process(delta: float) -> void:
	if !is_spreading:
		if duration >= 0:
			duration -= delta
		else:
			queue_free()
	else:
		if scale <= Vector2(2,1):
			scale += Vector2(delta * growth_rate * 2, delta * growth_rate)
		else:
			is_spreading = false


func onBodyEnteredHitbox(body):
	if body.is_in_group("Player"):
		print("player hit")
