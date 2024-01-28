extends Node2D
class_name WeaponMelee

@export var weaponHitbox : Area2D
var hitboxActive : bool = false

@export var weaponOrigin : Node
@export var animationPlayer : Node

@export var weaponId : String
var weaponData = null
var bulletCD = null

#Shooting
var isAttackBuffered := false
var timeLastAttacked: float
const ATTACK_BUFFER_PERIOD := 0.2

#Aesthetics
@export var WEAPON_ROTATE_LERP_CONSTANT := 0.1
var shootDirection: Vector2

func _ready():
	if WeaponData.weapon_ids.has(weaponId):
		for weapon in WeaponData.weapons:
			if weapon.weapon_id == weaponId:
				initWeapon(weapon)
	weaponHitbox.body_entered.connect(bodyEnteredHitbox)
	weaponHitbox.monitoring = false

func _process(_delta):
	handleInput()

func pointToMouse():
	shootDirection = (get_global_mouse_position() - global_position).normalized()
	
	weaponOrigin.rotation = lerp_angle(weaponOrigin.rotation, shootDirection.angle(), WEAPON_ROTATE_LERP_CONSTANT)
	if sign(shootDirection.x) < 0:
		weaponOrigin.get_child(0).flip_v = true
	else:
		weaponOrigin.get_child(0).flip_v = false

func initWeapon(weapon):
	weaponData = weapon
	bulletCD = 1 / weaponData.bullets_per_second
	timeLastAttacked = bulletCD

#Returns if bullet shoot successful
func attemptAttack() -> bool:
	var currentTime = Time.get_ticks_usec() / 1000000.0
	
	if currentTime - timeLastAttacked > bulletCD - ATTACK_BUFFER_PERIOD:
		isAttackBuffered = true
	
	if currentTime - timeLastAttacked < bulletCD:
		return false
	
	timeLastAttacked = currentTime
	isAttackBuffered = false
	startAttack()
	return true

func startAttack():
	animationPlayer.stop()
	animationPlayer.play("Attack")
	
func bodyEnteredHitbox(body: Node) -> void:
	print(body)

func enableHitbox():
	weaponHitbox.monitoring = true

func disableHitbox():
	weaponHitbox.monitoring = false

func handleInput():
	if weaponData:
		if weaponData.firing_mode == "single":
			if Input.is_action_just_pressed("Shoot") or isAttackBuffered:
				var isAttacking = attemptAttack()
		if weaponData.firing_mode == "auto":
			if Input.is_action_pressed("Shoot") or isAttackBuffered:
				var isAttacking = attemptAttack()
