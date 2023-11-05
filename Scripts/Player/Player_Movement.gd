extends CharacterBody2D

#Movement
@export var MAX_MOVE_SPEED := 300.0
@export var MOVE_ACCEL := 2000.0
@export var MOVE_FRICT := 2200.0

func basicMovement(direction: Vector2):
	set_velocity(velocity)
	move_and_slide()
	velocity = velocity
	
	var isInputMove = (direction != Vector2(0,0))
	
	if isInputMove:
		velocity = velocity.move_toward(2 * (direction * MAX_MOVE_SPEED), MOVE_ACCEL * get_process_delta_time())
	else:
		velocity = velocity.move_toward(Vector2.ZERO, MOVE_FRICT * get_process_delta_time())

func addImpulse(force: Vector2, speedLimit: float = 1000000.0):
	if (velocity+force).dot(force.normalized()) > speedLimit:
		return
	
	velocity += force

#Dodging
@export var DODGE_ROLL_DISTANCE := 200.0
@export var DODGE_ROLL_DURATION := 0.2
@onready var DODGE_ROLL_VELOCITY := DODGE_ROLL_DISTANCE / DODGE_ROLL_DURATION
@export var DODGE_ROLL_CD := 0.6

var isDodging := false
@onready var timeLastDodged := -DODGE_ROLL_CD

const DODGE_BUFFER_PERIOD := 0.2
var isDodgeBuffered := false

func attemptDodgeRoll(direction: Vector2) -> bool:
	var currentTime = Time.get_ticks_usec() / 1000000.0
	
	if direction == Vector2.ZERO:
		return false
	
	if currentTime - timeLastDodged > DODGE_ROLL_CD - DODGE_BUFFER_PERIOD:
		isDodgeBuffered = true
	
	if currentTime - timeLastDodged < DODGE_ROLL_CD or isDodging:
		return false
	
	isDodgeBuffered = false
	timeLastDodged = currentTime
	isDodging = true
	dodgeRoll(direction)
	return true

func dodgeRoll(direction: Vector2):
	velocity = direction * DODGE_ROLL_VELOCITY
	await get_tree().create_timer(DODGE_ROLL_DURATION).timeout
	velocity = velocity.limit_length(MAX_MOVE_SPEED)
	isDodging = false

func dodgeRollMovement():
	set_velocity(velocity)
	move_and_slide()
	velocity = velocity
	
# Receiving damage call
signal ReceivedDamage(amount) # signal snet to parent(player_main.gd) to inform about damage

#required to get around get_parent() call
func take_damage(amount: int):
	emit_signal("ReceivedDamage", amount)
