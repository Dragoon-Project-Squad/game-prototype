extends EnemyBase

@export var special_options : Array
var next_is_special = false

#minimap
var minimap_icon = "enemy"

@export var hidden_sprites : Node

#overrrides
func updateTransparency():
	var changeInAlpha = -1 * TRANSPARENCY_CHANGE_RATE * get_process_delta_time()
	
	if isLitUp():
		changeInAlpha *= -1
		hidden_sprites.modulate.a = max(TRANSPARENCY_ON_LIT, hidden_sprites.modulate.a)
	
	hidden_sprites.modulate.a += changeInAlpha
	hidden_sprites.modulate.a = clamp(hidden_sprites.modulate.a, 0.0, 1.0)

func _ready() -> void:
	super()
	speed = 200

func selectNextAction():
	var valid_specials = []
	
	for action in special_options:
		if get_node(action).current_special_cooldown <= 0:
			valid_specials.append(action)
	
	if valid_specials.size() > 0:
		valid_specials.shuffle()
		next_attack = valid_specials[0]
		next_is_special = true
	else:
		var options = action_options.duplicate()
		options.shuffle()
		next_attack = options[0]
		next_is_special = false

func startSpecial(position, attack_name):
	if position.x > global_position.x:
		main.set_flip_h(false)
		telegraph.set_flip_h(false)
	elif position.x < global_position.x:
		main.set_flip_h(true)
		telegraph.set_flip_h(true)
	attack_player_pos = position
	action_ready = false
	animation_player.play(attack_name)

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
					animation_player.play("Walk")
				else:
					if action_cooldown <= 0:
						if next_is_special:
							startSpecial(player.global_position, get_node(next_attack).telegraph_name)
						else:
							startAttack(player.global_position, get_node(next_attack).animation_name)
			_:
				print("Action not implemented!")
				current_state = ROAM
