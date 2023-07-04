extends Node2D

export (PackedScene) var jar: PackedScene
export (NodePath) onready var attack_origin = get_node(attack_origin)
export (NodePath) onready var enemy_control = get_node(enemy_control)

#all attacks need this
var attack_range = 300
var animation_name = "Attack1"
var cooldown = 5


func createAttack():
	var attackInstance = jar.instance()
	attackInstance.connect("tree_exited", self, "attackEnded")
	attack_origin.look_at(enemy_control.attack_player_pos)
	attack_origin.add_child(attackInstance)
	enemy_control.current_attack_instance = attackInstance
