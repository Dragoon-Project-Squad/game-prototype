extends Node2D

<<<<<<< Updated upstream
var equipped
=======
@export (NodePath) onready var bulletSpawnNode = get_node(bulletSpawnNode)

@export (NodePath) onready var weaponSprite = get_node(weaponSprite)
@onready var weaponSpriteStartScale: Vector2 = weaponSprite.scale
>>>>>>> Stashed changes

func _ready():
	if get_child(0) != null:
		equipped = get_child(0)

func _process(delta):
	if equipped:
		equipped.pointToMouse()

#Aesthetics
@export var WEAPON_ROTATE_LERP_CONSTANT := 0.1
var shootDirection: Vector2

func setEquippedWeapon(name):
	equipped = null
	for n in get_children():
		remove_child(n)
		n.queue_free()
	
<<<<<<< Updated upstream
	var newWeapon = load("res://Scenes/Player/Weapons/" + name + ".tscn").instantiate()
	add_child(newWeapon)
	equipped = newWeapon
=======
	weaponSprite.rotation = lerp_angle(weaponSprite.rotation, shootDirection.angle(), WEAPON_ROTATE_LERP_CONSTANT)
	weaponSprite.scale.y = sign(shootDirection.x) * weaponSpriteStartScale.y

#Shooting
@export var startingWeaponResource: Resource
var weaponResource: WeaponResource

var isBulletBuffered := false
var timeLastShootBullet: float
const BULLET_BUFFER_PERIOD := 0.2


func setNewWeapon(_weaponResource: WeaponResource):
	weaponResource = _weaponResource
	
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
	for i in range(weaponResource.BULLET_NUM_PER_SHOT):
		var bulletInstance = weaponResource.bulletScene.instantiate()
		
		bulletInstance.velocity = getSpreadDirection(i) * weaponResource.BULLET_INITIAL_SPEED
		
		bulletSpawnNode.add_child(bulletInstance)
		
		bulletInstance.global_position = global_position
		bulletInstance.startPos = global_position

func getSpreadDirection(index: int) -> Vector2:
	var baseDirection = shootDirection
	
	var spreadAngle = deg_to_rad(weaponResource.BULLET_SPREAD_ANGLE)
	
	var rotationAngle = 0.0
	
	if weaponResource.BULLET_NUM_PER_SHOT > 1:
		rotationAngle = spreadAngle * (0.5 - index * 1/float(weaponResource.BULLET_NUM_PER_SHOT-1))
	
	if weaponResource.BULLET_SPREAD_RANDOMNESS <= 0.0:
		return baseDirection.rotated(rotationAngle)
	
	rotationAngle += randf_range(0.0, weaponResource.BULLET_SPREAD_RANDOMNESS * spreadAngle)
	rotationAngle = fmod(rotationAngle + spreadAngle/2, spreadAngle) - spreadAngle/2
	
	return baseDirection.rotated(rotationAngle)

>>>>>>> Stashed changes
