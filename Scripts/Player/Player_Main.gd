extends Node

export (NodePath) onready var movement = get_node(movement)
export (NodePath) onready var aesthetics = get_node(aesthetics)
export (NodePath) onready var camera = get_node(camera)
export (NodePath) onready var lights = get_node(lights)
export (NodePath) onready var weapon = get_node(weapon)

export (NodePath) onready var minimap = get_node(minimap)

var blockPlayerActions = false
var isMinimapShowing = false

export (int) onready var health = 10000 # integer to track hp, maybe change to bits for optimization later on
export (int) onready var damageHighlightLength = 2 #ms, how many ticks the highlight lasts
export (Color) onready var damageHighlightColor # decides what color the damage highlight is
export (NodePath) onready var damageHighlightTimer = get_node(damageHighlightTimer) # ref to timer

func _ready():
	# sets up timer for damage highlight
	damageHighlightTimer.connect("timeout", self, "_endHighlight") # connect _endHighlight() to the timer's "timeout" signal

func _process(delta):
	# test code
	
	if Input.is_action_just_pressed("ChangeDisplay"):
		OS.window_fullscreen = not OS.window_fullscreen
	
	if(!blockPlayerActions):
		movement()
		shooting()
		tab()
	
	#if Input.is_action_pressed("Shoot"):
	#	gotHurt(1)

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
			camera.addShake(weapon.BULLET_FIRE_CAM_SHAKE_TRAUMA_INCREMENT)
			movement.addImpulse(weapon.BULLET_SELF_KNOCKBACK_IMPULSE * - weapon.shootDirection, weapon.BULLET_SELF_KNOCKBACK_SPEED_LIMIT)
			lights.triggerMuzzleFlash(min(weapon.BULLET_CD_PERIOD / 2, weapon.BULLET_MUZZLE_FLASH_DUR))
			
# Called when damaged
func gotHurt(damage: int):
	# updates player's health value
	health -= damage
	
	# highlights the player
	aesthetics.changeColor(damageHighlightColor) # changes highlight
	
	# starts timer for when to stop highlight
	damageHighlightTimer.start(damageHighlightLength / 10000) # starts timer w/ length, start() uses seconds as unit
	
# Changes the sprite's highlight back to neutral
# Called by DamageHighlightTimer's "timeout" signal
func _endHighlight():
	aesthetics.changeColor(Color("ffffff")) # changes highlight
	damageHighlightTimer.stop() # stops timer, tbh to be safe
