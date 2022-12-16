extends KinematicBody2D

func _process(delta):
	movement()
	
	checkCrouch()
	
	pointLightToMouse()

#Movement
var max_speed: float = 150.0
const accel: float = 1000.0
const frict: float = 2000.0

var velocity: Vector2 = Vector2.ZERO

func movement():
	var direction = get_directional_input()
	var isInputMove = (direction != Vector2(0,0))
	
	if isInputMove:
		velocity = velocity.move_toward(direction * max_speed, accel * get_process_delta_time())
	else:
		velocity = velocity.move_toward(Vector2(0,0), frict * get_process_delta_time())
	
	moveBounce(isInputMove)
	spriteFlip(sign(direction.x))
	
	move_and_slide(velocity)

func get_directional_input() -> Vector2:
	var x_axis_input
	var y_axis_input
	
	x_axis_input = float(Input.is_action_pressed("RightMove")) - float(Input.is_action_pressed("LeftMove"))
	y_axis_input = float(Input.is_action_pressed("DownMove")) - float(Input.is_action_pressed("UpMove"))
	
	return Vector2(x_axis_input, y_axis_input).normalized()

#Sprinting and Crouching
var isCrouch: bool
const crouch_max_speed: float = 75.0
const normal_max_speed: float = 150.0

func checkCrouch():
	isCrouch = Input.is_action_pressed("Crouch")
	
	if isCrouch:
		max_speed = crouch_max_speed
	else:
		max_speed = normal_max_speed

#Aesthetics
onready var charSprite: Sprite = $Sprite
onready var charSpriteStartPos: Vector2 = charSprite.position
onready var charSpriteStartScale: Vector2 = charSprite.scale
var animationTime: float = 0.0

const MB_animationBasePeriod: float = 0.5
const MB_animationJumpHeight: float = 10.0
const MB_animationRotationAngle: float = deg2rad(10.0)

func moveBounce(isMove: bool):
	var MB_animationPeriod = MB_animationBasePeriod
	if isCrouch:
		MB_animationPeriod *= normal_max_speed / crouch_max_speed
	
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

func spriteFlip(signX: int):
	if signX == 0:
		return
	
	charSprite.scale.x = signX * charSpriteStartScale.x

#Lights
onready var Torchlight: Light2D = $Lights/TorchLight

func pointLightToMouse():
	var vectorToMouse = get_global_mouse_position() - global_position
	
	Torchlight.rotation = vectorToMouse.angle()

#Camera
