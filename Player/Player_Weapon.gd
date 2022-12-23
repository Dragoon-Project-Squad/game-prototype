extends Node2D

export (NodePath) onready var bulletSpawnNode = get_node(bulletSpawnNode)

export (NodePath) onready var weaponSprite = get_node(weaponSprite)
onready var weaponSpriteStartScale: Vector2 = weaponSprite.scale

func _process(delta):
	pointToMouse()

#Aesthetics
export var WEAPON_ROTATE_LERP_CONSTANT := 0.1
var shootDirection: Vector2

func pointToMouse():
	shootDirection = get_global_mouse_position() - global_position
	
	weaponSprite.rotation = lerp_angle(weaponSprite.rotation, shootDirection.angle(), WEAPON_ROTATE_LERP_CONSTANT)
	weaponSprite.scale.y = sign(shootDirection.x) * weaponSpriteStartScale.y

#Shooting
export (PackedScene) var bulletScene: PackedScene

export (float) var BULLET_INITIAL_SPEED: float = 1000.0
export (float) var BULLETS_PER_SECOND: float = 15.0
export (float) var BULLET_FIRE_CAM_SHAKE_TRAUMA_INCREMENT := 0.3
export (float) var BULLET_SELF_KNOCKBACK_IMPULSE: float = 0.4
export (float) var BULLET_SELF_KNOCKBACK_SPEED_LIMIT: float = 100.0
export (float) var BULLET_MUZZLE_FLASH_DUR: float = 0.2

onready var BULLET_CD_PERIOD: float = 1 / BULLETS_PER_SECOND
var isBulletBuffered := false
onready var timeLastShootBullet: float = -BULLET_CD_PERIOD 

#Returns if bullet shoot successful
func attemptShootBullet() -> bool:
	var currentTime = Time.get_ticks_usec() / 1000000.0
	
	if currentTime - timeLastShootBullet < BULLET_CD_PERIOD:
		return false
	
	timeLastShootBullet = currentTime
	isBulletBuffered = false
	shootBullet()
	return true

func shootBullet():
	var bulletInstance = bulletScene.instance()
	
	bulletInstance.velocity = shootDirection.normalized() * BULLET_INITIAL_SPEED
	
	bulletSpawnNode.add_child(bulletInstance)
	
	bulletInstance.global_position = global_position
	bulletInstance.startPos = global_position
