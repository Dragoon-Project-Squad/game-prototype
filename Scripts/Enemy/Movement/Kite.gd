extends Node2D

@export (NodePath) onready var enemy_control = get_node(enemy_control)
@export var inner_distance = 150

var kite_direction = null
var kite_time = 0
var move_override = false

func _process(delta: float) -> void:
	if(kite_time > 0):
		kite_time -= delta

func move():
	if(global_position.distance_to(enemy_control.player.global_position) < inner_distance and !move_override):
		enemy_control.velocity = global_position.direction_to(enemy_control.player.global_position) * enemy_control.speed * -1
	else:
		if(kite_direction == null):
			kite_direction = Vector2(randf()*2-1,randf()*2-1)
			move_override = true
			kite_time = 0.5
			
		enemy_control.velocity = kite_direction * enemy_control.speed
		if(kite_time <= 0):
			kite_direction = null
			move_override = false
		
	enemy_control.enemy_body.set_velocity(enemy_control.velocity)
	enemy_control.enemy_body.move_and_slide()
	enemy_control.velocity = enemy_control.enemy_body.velocity
