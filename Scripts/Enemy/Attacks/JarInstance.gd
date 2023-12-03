extends Node2D

@export var animation_player : Node
@export var hitbox : Node

@export var pool: PackedScene

var projectile_speed = 350
var target_pos = null

@export var damage: int = 1

func _ready() -> void:
	animation_player.play("spin")
	hitbox.connect("body_entered", Callable(self, "onBodyEnteredHitbox"))

func _process(delta: float) -> void:
	if target_pos:
		if global_position.distance_to(target_pos) > 5:
			global_position += global_position.direction_to(target_pos) * delta * projectile_speed
		else:
			create_pool()
#Porting Node: instance() is dead, long live instantiate()
func create_pool():
	var pool_instance = pool.instantiate()
	pool_instance.global_position = global_position
	get_parent().add_child(pool_instance)
	queue_free()

func onBodyEnteredHitbox(body):
	if body.is_in_group("Player"):
		print("player hit")
		create_pool()
		body.take_damage(damage)
