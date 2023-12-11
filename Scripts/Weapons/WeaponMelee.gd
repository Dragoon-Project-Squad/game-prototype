extends Node2D

@export var bulletSpawnNode : Node

@export var weaponOrigin : Node
@export var animationPlayer : Node

@export var weaponOriginStartScale: Vector2 

func _ready():
	initWeapon(weaponResource)

#Aesthetics
@export var WEAPON_ROTATE_LERP_CONSTANT := 0.1
var shootDirection: Vector2

func pointToMouse():
	shootDirection = (get_global_mouse_position() - global_position).normalized()
	weaponOrigin.scale.x = sign(shootDirection.x) * weaponOriginStartScale.x

#Shooting
@export var weaponResource: Resource

var isBulletBuffered := false
var timeLastShootBullet: float
const BULLET_BUFFER_PERIOD := 0.2


func initWeapon(_weaponResource: WeaponResource):
	timeLastShootBullet = -_weaponResource.BULLET_CD_PERIOD 

#Returns if bullet shoot successful
func attemptAttack() -> bool:
	var currentTime = Time.get_ticks_usec() / 1000000.0
	
	if currentTime - timeLastShootBullet > weaponResource.BULLET_CD_PERIOD - BULLET_BUFFER_PERIOD:
		isBulletBuffered = true
	
	if currentTime - timeLastShootBullet < weaponResource.BULLET_CD_PERIOD:
		return false
	
	timeLastShootBullet = currentTime
	isBulletBuffered = false
	startAttack()
	return true

func startAttack():
	animationPlayer.stop()
	animationPlayer.play("Swing")
	

