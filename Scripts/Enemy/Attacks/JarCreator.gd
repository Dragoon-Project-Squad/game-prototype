extends Node2D

@export var jar: PackedScene
@export var attack_origin : Node
@export var enemy_control : Node

#all attacks need this
var attack_range = 300
var animation_name = "Attack1"
var cooldown = 5


func createAttack():
	var attackInstance = jar.instantiate()
	attackInstance.connect("tree_exited", Callable(self, "attackEnded"))
	attackInstance.global_position = global_position
	attackInstance.target_pos = get_tree().get_nodes_in_group("Player")[0].get_child(0).global_position
	attack_origin.add_child(attackInstance)
	enemy_control.current_attack_instance = attackInstance
