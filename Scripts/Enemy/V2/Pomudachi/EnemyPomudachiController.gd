extends EnemyBase

var move_override = false

onready var charSpriteStartPos: Vector2 = main.position
onready var charSpriteStartScale: Vector2 = main.scale
var animationTime: float = 0.0

#Move Bounce animation
export var MB_animationBasePeriod: float = 0.5
export var MB_animationJumpHeight: float = 10.0
export var MB_animationRotationAngle: float = 10.0

func selectNextAction():
	var options = action_options.duplicate()
	options.shuffle()
	next_attack = options[0]

func moveBounce(isMove: bool):
	var MB_animationPeriod = MB_animationBasePeriod
	
	if animationTime > MB_animationPeriod:
		animationTime -= MB_animationPeriod
	
	if isMove:
		animationTime += get_process_delta_time()
	else:
		if animationTime > MB_animationPeriod/2:
			animationTime += get_process_delta_time()
		else:
			animationTime -= get_process_delta_time()
		
		animationTime = max(0,animationTime)
	
	var targetPosition = charSpriteStartPos + MB_animationJumpHeight * pow(sin(2 * PI * animationTime / MB_animationPeriod), 2) * Vector2.UP
	var targetRotation = deg2rad(MB_animationRotationAngle) * sin(2 * PI * animationTime / MB_animationPeriod) 
	
	main.position = lerp(main.position, targetPosition, 0.4)
	main.rotation = lerp_angle(main.rotation, targetRotation, 0.4)
	main.scale.y = lerp(main.scale.y, charSpriteStartScale.y, 0.2)
	
	if !isMove:
		main.rotation = 0

func getCurrentState():
	if action_ready && player:
		match current_state:
			HALT:
				moveBounce(false)
				pass
			ROAM:
				telegraph.modulate.a = 0
				moveBounce(false)
				animation_player.play("Idle")
			CHASE:
				updateDirection(velocity)
				telegraph.modulate.a = 1
				#attack logic, ability cooldown checks will happen here
				if global_position.distance_to(player.global_position) > get_node(next_attack).attack_range and !move_override:
					get_node(move_options[1]).move()
					moveBounce(true)
					animation_player.play("Chase")
				else:
					if action_cooldown <= 0:
						startAttack(player.global_position, get_node(next_attack).animation_name)
						moveBounce(false)
						selectNextAction()
					else:
						moveBounce(true)
						get_node(move_options[2]).move()
			_:
				print("Action not implemented!")
				current_state = ROAM
