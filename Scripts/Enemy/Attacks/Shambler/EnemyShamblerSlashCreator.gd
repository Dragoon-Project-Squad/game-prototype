extends Node2D

export (PackedScene) var slashNW: PackedScene
export (PackedScene) var slashNE: PackedScene
export (PackedScene) var slashSW: PackedScene
export (PackedScene) var slashSE: PackedScene
export (NodePath) onready var attack_origin = get_node(attack_origin)
export (NodePath) onready var enemy_control = get_node(enemy_control)

var attack_range = 80
var animation_name = "Attack"
var cooldown = 1

func createAttack():
	
	var attackInstance
	
	var direction = global_position.direction_to(enemy_control.player.global_position)
	if direction.x < 0 and direction.y < 0:
		attackInstance = slashNW.instance()
	if direction.x > 0 and direction.y < 0:
		attackInstance = slashNE.instance()
	if direction.x < 0 and direction.y > 0:
		attackInstance = slashSW.instance()
	if direction.x > 0 and direction.y > 0:
		attackInstance = slashSE.instance()
	
	
	attack_origin.add_child(attackInstance)
	enemy_control.current_attack_instance = attackInstance
