extends KinematicBody2D

export (NodePath) onready var aesthetics = get_node(aesthetics)
export (NodePath) onready var camera = get_node(camera)
export (NodePath) onready var lights = get_node(lights)
export (NodePath) onready var weapon = get_node(weapon)

func _process(delta):
	movement()
	dodgeAesthetics()
	
	if Input.is_action_just_pressed("DodgeRoll"):
		dodgeRoll(getDirectionalInput())
	
	shootingBullet()

#Inputs
func getDirectionalInput() -> Vector2:
	var x_axis_input
	var y_axis_input
	
	x_axis_input = float(Input.is_action_pressed("RightMove")) - float(Input.is_action_pressed("LeftMove"))
	y_axis_input = float(Input.is_action_pressed("DownMove")) - float(Input.is_action_pressed("UpMove"))
	
	return Vector2(x_axis_input, y_axis_input).normalized()

#Movement
export var MAX_MOVE_SPEED := 300.0
export var MOVE_ACCEL := 2000.0
export var MOVE_FRICT := 2200.0

var velocity: Vector2 = Vector2.ZERO

func movement():
	velocity = move_and_slide(velocity)
	
	var direction = getDirectionalInput()
	var isInputMove = (direction != Vector2(0,0))
	
	if isInputMove:
		velocity = velocity.move_toward(direction * MAX_MOVE_SPEED, MOVE_ACCEL * get_process_delta_time())
	else:
		velocity = velocity.move_toward(Vector2.ZERO, MOVE_FRICT * get_process_delta_time())
	
	aesthetics.moveBounce(isInputMove)
	aesthetics.spriteFlip(sign(direction.x))

func addImpulse(force: Vector2, speedLimit: float = 1000000.0):
	if (velocity+force).dot(force.normalized()) > speedLimit:
		return
	
	velocity += force

#Dodging
export var DODGE_ROLL_DISTANCE := 200.0
onready var DODGE_ROLL_IMPULSE := sqrt( pow(MAX_MOVE_SPEED, 2) + 2 * MOVE_ACCEL * DODGE_ROLL_DISTANCE )
export var DODGE_ROLL_CD := 0.6

var isDodging := false
onready var timeLastDodged := -DODGE_ROLL_CD

func dodgeRoll(direction: Vector2):
	var currentTime = Time.get_ticks_usec() / 1000000.0
	
	if currentTime - timeLastDodged < DODGE_ROLL_CD:
		return
	
	if isDodging: 
		return
	
	addImpulse(direction * DODGE_ROLL_IMPULSE)
	timeLastDodged = currentTime
	isDodging = true

func dodgeAesthetics():
	if not isDodging:
		return
	
	if velocity.length() <= MAX_MOVE_SPEED:
		isDodging = false
	
	aesthetics.dodgeSquish()

#Shooting
func shootingBullet():
	if Input.is_action_just_pressed("Shoot"):
		weapon.isBulletBuffered = true
	if Input.is_action_pressed("Shoot") or weapon.isBulletBuffered:
		var isBulletShot = weapon.attemptShootBullet()
		
		if isBulletShot:
			camera.addShake(weapon.BULLET_FIRE_CAM_SHAKE_TRAUMA_INCREMENT)
			addImpulse(weapon.BULLET_SELF_KNOCKBACK_IMPULSE * - weapon.shootDirection, weapon.BULLET_SELF_KNOCKBACK_SPEED_LIMIT)
			lights.triggerMuzzleFlash(min(weapon.BULLET_CD_PERIOD / 2, weapon.BULLET_MUZZLE_FLASH_DUR))
