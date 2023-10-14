extends Node2D

export (NodePath) onready var bulletSpawnNode = get_node(bulletSpawnNode)

export (NodePath) onready var weaponOrigin = get_node(weaponOrigin)
export (NodePath) onready var animationPlayer = get_node(animationPlayer)

onready var weaponOriginStartScale: Vector2 = weaponOrigin.scale

func _ready():
	initWeapon(weaponResource)

#Aesthetics
export var WEAPON_ROTATE_LERP_CONSTANT := 0.1
var shootDirection: Vector2

func pointToMouse():
	shootDirection = (get_global_mouse_position() - global_position).normalized()
	
	weaponOrigin.rotation = lerp_angle(weaponOrigin.rotation, shootDirection.angle(), WEAPON_ROTATE_LERP_CONSTANT)
	weaponOrigin.scale.y = sign(shootDirection.x) * weaponOriginStartScale.y

#Shooting
export var weaponResource: Resource

var isBulletBuffered := false
var timeLastShootBullet: float
const BULLET_BUFFER_PERIOD := 0.2


func initWeapon(_weaponResource: WeaponResource):
	timeLastShootBullet = -_weaponResource.BULLET_CD_PERIOD 

#Returns if bullet shoot successful
func attemptShootBullet() -> bool:
	var currentTime = Time.get_ticks_usec() / 1000000.0
	
	if currentTime - timeLastShootBullet > weaponResource.BULLET_CD_PERIOD - BULLET_BUFFER_PERIOD:
		isBulletBuffered = true
	
	if currentTime - timeLastShootBullet < weaponResource.BULLET_CD_PERIOD:
		return false
	
	timeLastShootBullet = currentTime
	isBulletBuffered = false
	shootBullet()
	return true

func shootBullet():
	animationPlayer.stop()
	animationPlayer.play("Shoot")
	
	for i in range(weaponResource.BULLET_NUM_PER_SHOT):
		var bulletInstance = weaponResource.bulletScene.instance()
		
		bulletInstance.damage = weaponResource.BULLET_DAMAGE # pass value to spawned scene
		bulletInstance.velocity = getSpreadDirection(i) * weaponResource.BULLET_INITIAL_SPEED
		
		bulletSpawnNode.add_child(bulletInstance)
		
		bulletInstance.global_position = global_position
		bulletInstance.startPos = global_position

func getSpreadDirection(index: int) -> Vector2:
	var baseDirection = shootDirection
	
	var spreadAngle = deg2rad(weaponResource.BULLET_SPREAD_ANGLE)
	
	var rotationAngle = 0.0
	
	if weaponResource.BULLET_NUM_PER_SHOT > 1:
		rotationAngle = spreadAngle * (0.5 - index * 1/float(weaponResource.BULLET_NUM_PER_SHOT-1))
	
	if weaponResource.BULLET_SPREAD_RANDOMNESS <= 0.0:
		return baseDirection.rotated(rotationAngle)
	
	rotationAngle += rand_range(0.0, weaponResource.BULLET_SPREAD_RANDOMNESS * spreadAngle)
	rotationAngle = fmod(rotationAngle + spreadAngle/2, spreadAngle) - spreadAngle/2
	
	return baseDirection.rotated(rotationAngle)

