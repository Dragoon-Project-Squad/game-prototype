extends EnemyBase

#minimap
var minimap_icon = "enemy"

export (NodePath) onready var hidden_sprites = get_node(hidden_sprites)

#overrrides
func updateTransparency():
	var changeInAlpha = -1 * TRANSPARENCY_CHANGE_RATE * get_process_delta_time()
	
	if isLitUp():
		changeInAlpha *= -1
		hidden_sprites.modulate.a = max(TRANSPARENCY_ON_LIT, hidden_sprites.modulate.a)
	
	hidden_sprites.modulate.a += changeInAlpha
	hidden_sprites.modulate.a = clamp(hidden_sprites.modulate.a, 0.0, 1.0)

func getCurrentState():
	if action_ready && player:
		match current_state:
			HALT:
				pass
			ROAM:
				telegraph.modulate.a = 0
			CHASE:
				updateDirection(velocity)
				telegraph.modulate.a = 1
				#attack logic, ability cooldown checks will happen here
				if global_position.distance_to(player.global_position) > get_node(next_attack).attack_range:
					get_node(move_options[1]).move()
				else:
					if action_cooldown <= 0:
						startAttack(player.global_position, get_node(next_attack).animation_name)
			_:
				print("Action not implemented!")
				current_state = ROAM
