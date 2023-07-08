extends Node2D

export (NodePath) onready var animation_player = get_node(animation_player)
export (NodePath) onready var hitbox = get_node(hitbox)

export (PackedScene) var pool: PackedScene

var projectile_speed = 350
var target_pos = null

func _ready() -> void:
	animation_player.play("spin")
	hitbox.connect("body_entered", self, "onBodyEnteredHitbox")

func _process(delta: float) -> void:
	if target_pos:
		if global_position.distance_to(target_pos) > 5:
			global_position += global_position.direction_to(target_pos) * delta * projectile_speed
		else:
			create_pool()

func create_pool():
	var pool_instance = pool.instance()
	pool_instance.global_position = global_position
	get_parent().add_child(pool_instance)
	queue_free()

func onBodyEnteredHitbox(body):
	if body.is_in_group("Player"):
		print("player hit")
		create_pool()
