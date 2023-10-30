extends Resource
class_name WeaponResource

@export (PackedScene) var bulletScene: PackedScene
@export (float) var BULLET_INITIAL_SPEED: float = 1000.0
@export (float) var BULLETS_PER_SECOND: float = 15.0
@export (float) var BULLET_FIRE_CAM_SHAKE_TRAUMA_INCREMENT := 0.3
@export (float) var BULLET_SELF_KNOCKBACK_IMPULSE: float = 0.4
@export (float) var BULLET_SELF_KNOCKBACK_SPEED_LIMIT: float = 100.0
@export (float) var BULLET_MUZZLE_FLASH_DUR: float = 0.2
@export (float) var BULLET_SPREAD_ANGLE: float = 0.0
@export (float, 0.0, 1.0) var BULLET_SPREAD_RANDOMNESS: float = 0.0
@export (int) var BULLET_NUM_PER_SHOT: int = 1
@export (int) var BULLET_DAMAGE: int = 1

@onready var BULLET_CD_PERIOD: float: get = getBulletCDPeriod

func getBulletCDPeriod():
	return 1 / BULLETS_PER_SECOND
