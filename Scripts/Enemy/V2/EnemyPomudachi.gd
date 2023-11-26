extends EnemyBase

var max_kite = 300

@onready var charSpriteStartPos: Vector2 = main_sprite.position
@onready var charSpriteStartScale: Vector2 = main_sprite.scale
var animationTime: float = 0.0

#Move Bounce animation
@export var MB_animationBasePeriod: float = 0.5
@export var MB_animationJumpHeight: float = 10.0
@export var MB_animationRotationAngle: float = 10.0

#minimap
var minimap_icon = "enemy"

@export var hidden_sprites : Node

#overrrides
func updateTransparency():
	super()
	var changeInAlpha = -1 * TRANSPARENCY_CHANGE_RATE * get_process_delta_time()
	
	if isLitUp():
		changeInAlpha *= -1
		hidden_sprites.modulate.a = max(TRANSPARENCY_ON_LIT, hidden_sprites.modulate.a)
	
	hidden_sprites.modulate.a += changeInAlpha
	hidden_sprites.modulate.a = clamp(hidden_sprites.modulate.a, 0.0, 1.0)


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
	var targetRotation = deg_to_rad(MB_animationRotationAngle) * sin(2 * PI * animationTime / MB_animationPeriod) 
	
	main_sprite.position = lerp(main_sprite.position, targetPosition, 0.4)
	main_sprite.rotation = lerp_angle(main_sprite.rotation, targetRotation, 0.4)
	main_sprite.scale.y = lerp(main_sprite.scale.y, charSpriteStartScale.y, 0.2)
	
	if !isMove:
		main_sprite.rotation = 0

func getCurrentState():
	super()
	if action_ready && player:
		match current_state:
			HALT:
				moveBounce(false)
				pass
			ROAM:
				telegraph_sprite.modulate.a = 0
				moveBounce(false)
				animation_player.play("Idle")
			CHASE:
				updateDirection(velocity)
				telegraph_sprite.modulate.a = 1
				#attack logic, ability cooldown checks will happen here
				if action_cooldown <= 0:
					if global_position.distance_to(player.global_position) > get_node(next_attack).attack_range:
						get_node(move_options[1]).move()
						moveBounce(true)
						animation_player.play("Chase")
					else:
						startAttack(player.global_position, get_node(next_attack).animation_name)
						moveBounce(false)
				else:
					if global_position.distance_to(player.global_position) > max_kite and !get_node(move_options[2]).move_override:
						get_node(move_options[1]).move()
						moveBounce(true)
						animation_player.play("Chase")
					else:
						moveBounce(true)
						get_node(move_options[2]).move()
						animation_player.play("Chase")
			_:
				print("Action not implemented!")
				current_state = ROAM
