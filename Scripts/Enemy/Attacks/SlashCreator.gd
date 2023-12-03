extends Node2D

@export var slash: PackedScene
@export var attack_origin : Node
@export var enemy_control : Node

var attack_range = 100
var animation_name = "Attack"
var cooldown = 1

func createAttack():
	var attackInstance = slash.instantiate()
	attackInstance.connect("tree_exited", Callable(self, "attackEnded"))
	attack_origin.look_at(enemy_control.attack_player_pos)
	attack_origin.add_child(attackInstance)
	enemy_control.current_attack_instance = attackInstance
