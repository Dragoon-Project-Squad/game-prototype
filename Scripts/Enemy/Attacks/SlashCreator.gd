extends Node2D

<<<<<<< Updated upstream
@export var slash: PackedScene
@export var attack_origin : Node
@export var enemy_control : Node
=======
@export (PackedScene) var slash: PackedScene
@export (NodePath) onready var attack_origin = get_node(attack_origin)
@export (NodePath) onready var enemy_control = get_node(enemy_control)
>>>>>>> Stashed changes

var attack_range = 100
var animation_name = "Attack"
var cooldown = 1

func createAttack():
	var attackInstance = slash.instantiate()
	attackInstance.connect("tree_exited", Callable(self, "attackEnded"))
	attack_origin.look_at(enemy_control.attack_player_pos)
	attack_origin.add_child(attackInstance)
	enemy_control.current_attack_instance = attackInstance
