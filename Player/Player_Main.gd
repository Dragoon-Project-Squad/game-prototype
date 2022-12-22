extends KinematicBody2D

export (NodePath) onready var aesthetics = get_node(aesthetics)
export (NodePath) onready var camera = get_node(camera)
export (NodePath) onready var lights = get_node(lights)

func _process(delta):
	movement()
	dodgeAesthetics()
	
	if Input.is_action_just_pressed("DodgeRoll"):
		dodgeRoll(getDirectionalInput())

#Inputs
func getDirectionalInput() -> Vector2:
	var x_axis_input
	var y_axis_input
	
	x_axis_input = float(Input.is_action_pressed("RightMove")) - float(Input.is_action_pressed("LeftMove"))
	y_axis_input = float(Input.is_action_pressed("DownMove")) - float(Input.is_action_pressed("UpMove"))
	
	return Vector2(x_axis_input, y_axis_input).normalized()

#Movement
const MAX_MOVE_SPEED := 300.0
const MOVE_ACCEL := 1500.0
const MOVE_FRICT := 2000.0

var velocity: Vector2 = Vector2.ZERO

func movement():
	var direction = getDirectionalInput()
	var isInputMove = (direction != Vector2(0,0))
	
	if isInputMove:
		velocity = velocity.move_toward(direction * MAX_MOVE_SPEED, MOVE_ACCEL * get_process_delta_time())
	else:
		velocity = velocity.move_toward(Vector2.ZERO, MOVE_FRICT * get_process_delta_time())
	
	aesthetics.moveBounce(isInputMove)
	aesthetics.spriteFlip(sign(direction.x))
	
	move_and_slide(velocity)

#Dodging
const DODGE_ROLL_DISTANCE := 200.0
onready var DODGE_ROLL_IMPULSE := sqrt( pow(MAX_MOVE_SPEED, 2) + 2 * MOVE_ACCEL * DODGE_ROLL_DISTANCE )
const DODGE_ROLL_CD := 0.6

var isDodging := false
onready var timeLastDodged := -DODGE_ROLL_CD

func dodgeRoll(direction: Vector2):
	var currentTime = Time.get_ticks_usec() / 1000000.0
	
	if currentTime - timeLastDodged < DODGE_ROLL_CD:
		return
	
	if isDodging: 
		return
	
	velocity = direction * DODGE_ROLL_IMPULSE
	timeLastDodged = currentTime
	isDodging = true

func dodgeAesthetics():
	if not isDodging:
		return
	
	if velocity.length() <= MAX_MOVE_SPEED:
		isDodging = false
	
	aesthetics.dodgeSquish()
