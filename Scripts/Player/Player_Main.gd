extends Node2D

@export var movement : Node
@export var aesthetics : Node
@export var camera : Node
@export var lights : Node
@export var weapon : Node

@export var minimap : Node

var blockPlayerActions = false
var isMinimapShowing = false
var currentKeys = 0
const MAX_KEYS = 9

signal key_used
signal door_stuck

var interact_list = []

@export var health: int = 10000 # integer to track hp, maybe change to bits for optimization later on

@export var damageHighlightLength: int = 20 #centiseconds, how long highlight lasts
@export var damageHighlightColor: Color = Color("#78ff0000") # decides what color the damage highlight is
@export var damageHighlightTimer: Node # ref to timer

func _ready():
	# sets up timer for damage highlight
	damageHighlightTimer.connect("timeout", Callable(self, "_endHighlight")) # connect _endHighlight() to the timer's "timeout" signal
	
	# connects signal to function
	movement.connect("ReceivedDamage", Callable(self, "GotHurt")) #required b/c colliders are getting child of main, Movement

func _process(delta):
	# test code
	
	if Input.is_action_just_pressed("ChangeDisplay"):
		get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN if (not ((get_window().mode == Window.MODE_EXCLUSIVE_FULLSCREEN) or (get_window().mode == Window.MODE_FULLSCREEN))) else Window.MODE_WINDOWED
	
	if(!blockPlayerActions):
		pMovement()
		shooting()
		tab()
		interact()

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
	var item = getClosestInteractable()
	
	if Input.is_action_just_pressed("Interact"):
		if item:
			item.onInteract()

#Movement
func pMovement():
	var direction = getDirectionalInput()
	
	#disabled dodgeroll
	#if Input.is_action_just_pressed("DodgeRoll") or movement.isDodgeBuffered:
	#	movement.attemptDodgeRoll(direction)
	
	if movement.isDodging:
		movement.dodgeRollMovement()
		aesthetics.dodgeSquish()
	else:
		movement.basicMovement(direction)
		aesthetics.moveBounce(direction != Vector2(0,0))
		aesthetics.spriteFlip(sign(((get_global_mouse_position() - global_position).normalized()).x))

#Shooting
func shooting():
	if Input.is_action_pressed("Shoot") or weapon.isBulletBuffered:
		var isBulletShot = weapon.attemptShootBullet()
		
		if isBulletShot:
			camera.addShake(weapon.weaponResource.BULLET_FIRE_CAM_SHAKE_TRAUMA_INCREMENT)
			movement.addImpulse(weapon.weaponResource.BULLET_SELF_KNOCKBACK_IMPULSE * - weapon.shootDirection, weapon.weaponResource.BULLET_SELF_KNOCKBACK_SPEED_LIMIT)
			lights.triggerMuzzleFlash(min(weapon.weaponResource.BULLET_CD_PERIOD / 2, weapon.weaponResource.BULLET_MUZZLE_FLASH_DUR))
			
# Called when damaged
func GotHurt(damage: int):
	# updates player's health value
	health -= damage
	
	# highlights the player
	aesthetics.changeColor(damageHighlightColor) # changes highlight/modulate value
	
	# starts timer for when to stop highlight
	damageHighlightTimer.start(damageHighlightLength / 100.0) # starts timer w/ length, start() uses seconds as unit
	
# Changes the sprite's highlight back to neutral
# Called by DamageHighlightTimer's "timeout" signal
func _endHighlight():
	aesthetics.changeColor(Color("ffffff")) # changes highlight/modulate to default
	damageHighlightTimer.stop() # stops timer, tbh to be safe

func addToInteractList(node: Node):
	interact_list.append(node)
	
func removeFromInteractList(node: Node):
	interact_list.erase(node)

func getClosestInteractable():
	if interact_list.size() == 0:
		return null
	
	var closest_item
	for item in interact_list:
		if closest_item:
			if global_position.distance_to(item.global_position) < global_position.distance_to(closest_item.global_position):
				closest_item = item
		else:
			closest_item = item
	
	for item in interact_list:
		if item == closest_item:
			item.setHighlight(true)
		else:
			item.setHighlight(false)
	
	return closest_item

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
