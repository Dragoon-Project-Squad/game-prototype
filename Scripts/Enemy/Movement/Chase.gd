extends Node2D

export (NodePath) onready var enemy_control = get_node(enemy_control)

func move():
	if enemy_control.level_navigation:
		var path = []
		if enemy_control.player_spotted:
			path = enemy_control.level_navigation.get_simple_path(global_position, enemy_control.player.global_position, false)
		elif enemy_control.last_seen:
			path = enemy_control.level_navigation.get_simple_path(global_position, enemy_control.last_seen, false)
		else:
			return
		
		if path.size() > 2:
			enemy_control.velocity = global_position.direction_to(path[1]) * enemy_control.speed
		else:
			enemy_control.last_seen = null
			enemy_control.current_state = enemy_control.ROAM
	else:
		if enemy_control.player_spotted:
			enemy_control.velocity = global_position.direction_to(enemy_control.player.global_position) * enemy_control.speed
		elif enemy_control.last_seen:
			enemy_control.velocity = global_position.direction_to(enemy_control.last_seen) * enemy_control.speed
			if global_position.distance_to(enemy_control.last_seen) < 10:
				enemy_control.last_seen = null
				enemy_control.current_state = enemy_control.ROAM
		else:
			return
		
	enemy_control.velocity = enemy_control.enemy_body.move_and_slide(enemy_control.velocity)
