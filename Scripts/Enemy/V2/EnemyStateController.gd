extends EnemyBase

func getCurrentStateAction():
	if actions.action_ready && player && level_navigation:
		match current_state:
			ROAMING:
				telegraph.modulate.a = 0
			ATTACKING:
				telegraph.modulate.a = 1
				#attack logic, ability cooldown checks will happen here
				if global_position.distance_to(player.global_position) > 100:
					chasePlayer()
				else:
					actions.startAttack(player.global_position)
					selectNextActiveState()
			_:
				print("Action not implemented!")
				current_state = ROAMING
