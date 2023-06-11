extends Node

export (NodePath) onready var movement = get_node(movement)
export (NodePath) onready var aesthetics = get_node(aesthetics)
export (NodePath) onready var camera = get_node(camera)
export (NodePath) onready var lights = get_node(lights)
export (NodePath) onready var weapon = get_node(weapon)

export (NodePath) onready var minimap = get_node(minimap)

var blockPlayerActions = false
var isMinimapShowing = false
var currentKeys = 0
const MAX_KEYS = 9

signal key_used
signal door_stuck

func _process(delta):
	if(!blockPlayerActions):
		movement()
		shooting()
		tab()

#Inputs
func getDirectionalInput() -> Vector2:
	var x_axis_input
	var y_axis_input
	
	x_axis_input = float(Input.is_action_pressed("RightMove")) - float(Input.is_action_pressed("LeftMove"))
	y_axis_input = float(Input.is_action_pressed("DownMove")) - float(Input.is_action_pressed("UpMove"))
	
	return Vector2(x_axis_input, y_axis_input).normalized()

func tab():
	#update this with more options later on
	if Input.is_action_just_pressed("Tab"):
		if(isMinimapShowing):
			minimap.hide()
			isMinimapShowing = false
		else:
			minimap.show()
			isMinimapShowing = true

func interact():
	if Input.is_action_just_pressed("Interact"):
		print("Interact")

#Movement
func movement():
	var direction = getDirectionalInput()
	
	if Input.is_action_just_pressed("DodgeRoll") or movement.isDodgeBuffered:
		movement.attemptDodgeRoll(direction)
	
	if movement.isDodging:
		movement.dodgeRollMovement()
		aesthetics.dodgeSquish()
	else:
		movement.basicMovement(direction)
		aesthetics.moveBounce(direction != Vector2(0,0))
		aesthetics.spriteFlip(sign(direction.x))

#Shooting
func shooting():
	if Input.is_action_pressed("Shoot") or weapon.isBulletBuffered:
		var isBulletShot = weapon.attemptShootBullet()
		
		if isBulletShot:
			camera.addShake(weapon.weaponResource.BULLET_FIRE_CAM_SHAKE_TRAUMA_INCREMENT)
			movement.addImpulse(weapon.weaponResource.BULLET_SELF_KNOCKBACK_IMPULSE * - weapon.shootDirection, weapon.weaponResource.BULLET_SELF_KNOCKBACK_SPEED_LIMIT)
			lights.triggerMuzzleFlash(min(weapon.weaponResource.BULLET_CD_PERIOD / 2, weapon.weaponResource.BULLET_MUZZLE_FLASH_DUR))


func _on_Key_key_acquired():
	print("Key accepted by Player...")
	currentKeys = min(currentKeys+1, MAX_KEYS)


func _on_KeyLockedExit_key_checked():
	if (currentKeys > 0):
		currentKeys = currentKeys - 1
		print("Removing key...")
		emit_signal("key_used")
	else:
		emit_signal("door_stuck")
