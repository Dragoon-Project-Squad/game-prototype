extends Node2D

export (NodePath) onready var charSprite = get_node(charSprite)
onready var charSpriteStartPos: Vector2 = charSprite.position
onready var charSpriteStartScale: Vector2 = charSprite.scale
var animationTime: float = 0.0

#Move Bounce animation
export var MB_animationBasePeriod: float = 0.5
export var MB_animationJumpHeight: float = 10.0
export var MB_animationRotationAngle: float = deg2rad(10.0)

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
	var targetRotation = MB_animationRotationAngle * sin(2 * PI * animationTime / MB_animationPeriod) 
	
	charSprite.position = lerp(charSprite.position, targetPosition, 0.4)
	charSprite.rotation = lerp_angle(charSprite.rotation, targetRotation, 0.4)
	charSprite.scale.y = lerp(charSprite.scale.y, charSpriteStartScale.y, 0.2)

#Dodge Squish 
export var DODGE_SQUISH_FACTOR := 0.6

func dodgeSquish():
	charSprite.scale.y = lerp(charSprite.scale.y, charSpriteStartScale.y * DODGE_SQUISH_FACTOR, 0.2)

func spriteFlip(signX: int):
	if signX == 0:
		return
	
	charSprite.scale.x = signX * charSpriteStartScale.x
