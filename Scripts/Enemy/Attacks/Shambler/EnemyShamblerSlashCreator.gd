extends Node2D

@export (PackedScene) var slashNW: PackedScene
@export (PackedScene) var slashNE: PackedScene
@export (PackedScene) var slashSW: PackedScene
@export (PackedScene) var slashSE: PackedScene
@export var attack_origin : Node
@export var enemy_control : Node

var attack_range = 80
var animation_name = "Attack"
var cooldown = 1

func createAttack():
	
	var attackInstance
	
	var direction = global_position.direction_to(enemy_control.player.global_position)
	if direction.x < 0 and direction.y < 0:
		attackInstance = slashNW.instantiate()
	if direction.x > 0 and direction.y < 0:
		attackInstance = slashNE.instantiate()
	if direction.x < 0 and direction.y > 0:
		attackInstance = slashSW.instantiate()
	if direction.x > 0 and direction.y > 0:
		attackInstance = slashSE.instantiate()
	
	
	attack_origin.add_child(attackInstance)
	enemy_control.current_attack_instance = attackInstance
