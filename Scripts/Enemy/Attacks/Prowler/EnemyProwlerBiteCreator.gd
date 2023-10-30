extends Node2D

@export (PackedScene) var bite: PackedScene
@export (NodePath) onready var attack_origin = get_node(attack_origin)
@export (NodePath) onready var enemy_control = get_node(enemy_control)

var attack_range = 60
var animation_name = "Bite"
var cooldown = 0.36

func snapshotAttackOrigin():
	var direction = global_position.direction_to(enemy_control.player.global_position)
	attack_origin.global_position = enemy_control.global_position
	attack_origin.global_position += Vector2(50 * direction.x, 50 * direction.y)
	

func createAttack():
	var attackInstance = bite.instantiate()
	attack_origin.add_child(attackInstance)
	enemy_control.current_attack_instance = attackInstance
