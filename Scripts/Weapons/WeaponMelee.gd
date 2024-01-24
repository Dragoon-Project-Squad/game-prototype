extends Node2D
class_name WeaponMelee

@export var weaponHitbox : Area2D
var hitboxActive : bool = false

@export var weaponOrigin : Node
@export var animationPlayer : Node

@export var weaponOriginStartScale: Vector2 

func _ready():
	initWeapon(weaponResource)
	weaponHitbox.body_entered.connect(bodyEnteredHitbox)
	weaponHitbox.monitoring = false

func _process(_delta):
	if Input.is_action_pressed("Shoot") or isAttackBuffered:
		var isBulletShot = attemptAttack()

#Aesthetics
@export var WEAPON_ROTATE_LERP_CONSTANT := 0.1
var shootDirection: Vector2

func pointToMouse():
	shootDirection = (get_global_mouse_position() - global_position).normalized()
	
	weaponOrigin.rotation = lerp_angle(weaponOrigin.rotation, shootDirection.angle(), WEAPON_ROTATE_LERP_CONSTANT)
	if sign(shootDirection.x) < 0:
		weaponOrigin.get_child(0).flip_v = true
	else:
		weaponOrigin.get_child(0).flip_v = false

#Shooting
@export var weaponResource: Resource

var isAttackBuffered := false
var timeLastAttacked: float
const ATTACK_BUFFER_PERIOD := 0.2


func initWeapon(_weaponResource: WeaponResource):
	timeLastAttacked = -_weaponResource.BULLET_CD_PERIOD 

#Returns if bullet shoot successful
func attemptAttack() -> bool:
	var currentTime = Time.get_ticks_usec() / 1000000.0
	
	if currentTime - timeLastAttacked > weaponResource.BULLET_CD_PERIOD - ATTACK_BUFFER_PERIOD:
		isAttackBuffered = true
	
	if currentTime - timeLastAttacked < weaponResource.BULLET_CD_PERIOD:
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
