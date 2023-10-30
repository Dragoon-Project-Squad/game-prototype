extends Node2D

@export (PackedScene) var pool: PackedScene
@export (NodePath) onready var attack_origin = get_node(attack_origin)
@export (NodePath) onready var enemy_control = get_node(enemy_control)

#all attacks need this
var attack_range = 75
var animation_name = "Attack2"
var cooldown = 3


func createAttack():
	var attackInstance = pool.instantiate()
	attackInstance.connect("tree_exited", Callable(self, "attackEnded"))
	attackInstance.global_position = global_position  + Vector2(0, 20)
	attack_origin.add_child(attackInstance)
	enemy_control.current_attack_instance = attackInstance
