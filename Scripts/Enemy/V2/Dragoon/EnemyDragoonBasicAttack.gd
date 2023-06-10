extends Node2D

export (PackedScene) var slash: PackedScene
export (NodePath) onready var attack_origin = get_node(attack_origin)
export (NodePath) onready var actions = get_node(actions)

func createAttack():
	var attackInstance = slash.instance()
	attackInstance.connect("tree_exited", self, "attackEnded")
	attack_origin.look_at(actions.player_pos)
	attack_origin.add_child(attackInstance)
	actions.current_attack = attackInstance
