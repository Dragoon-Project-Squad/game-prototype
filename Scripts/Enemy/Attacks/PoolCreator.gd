extends Node2D

@export var pool: PackedScene
@export var attack_origin : Node
@export var enemy_control : Node

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
