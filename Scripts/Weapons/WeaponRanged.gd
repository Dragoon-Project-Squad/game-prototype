extends Node2D
class_name WeaponRanged

@export var bulletSpawnNode : Node
@export var weaponOrigin : Node
@export var animationPlayer : Node

@export var weaponId : String
var weaponData = null
var bulletCD = null

@export var bulletScene: PackedScene

#Shooting
var isBulletBuffered := false
var timeLastShootBullet: float
const BULLET_BUFFER_PERIOD := 0.2

#Aesthetics
@export var WEAPON_ROTATE_LERP_CONSTANT := 0.1
var shootDirection: Vector2

func _ready():
	if WeaponData.weapon_ids.has(weaponId):
		for weapon in WeaponData.weapons:
			if weapon.weapon_id == weaponId:
				initWeapon(weapon)

func _process(delta):
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
	timeLastShootBullet = bulletCD

#Returns if bullet shoot successful
func attemptAttack() -> bool:
	var currentTime = Time.get_ticks_usec() / 1000000.0
	
	if currentTime - timeLastShootBullet > bulletCD - BULLET_BUFFER_PERIOD:
		isBulletBuffered = true
	
	if currentTime - timeLastShootBullet < bulletCD:
		return false
	
	timeLastShootBullet = currentTime
	isBulletBuffered = false
	shootBullet()
	return true

func shootBullet():
	animationPlayer.stop()
	animationPlayer.play("Shoot")
	
	for i in range(weaponData.bullets_per_trigger):
		var bulletInstance = bulletScene.instantiate()
		
		bulletInstance.damage = weaponData.bullet_damage # pass value to spawned scene
		bulletInstance.velocity = getSpreadDirection(i) * weaponData.bullet_velocity
		
		bulletSpawnNode.add_child(bulletInstance)
		
		bulletInstance.global_position = global_position
		bulletInstance.startPos = global_position

func getSpreadDirection(index: int) -> Vector2:
	var baseDirection = shootDirection
	
	var spreadAngle = deg_to_rad(weaponData.spread_angle)
	
	var rotationAngle = 0.0
	
	if weaponData.bullets_per_trigger > 1:
		rotationAngle = spreadAngle * (0.5 - index * 1/float(weaponData.bullets_per_trigger-1))
	
	if weaponData.spread_variance <= 0.0:
		return baseDirection.rotated(rotationAngle)
	
	rotationAngle += randf_range(0.0, weaponData.spread_variance * spreadAngle)
	rotationAngle = fmod(rotationAngle + spreadAngle/2, spreadAngle) - spreadAngle/2
	
	return baseDirection.rotated(rotationAngle)

func handleInput():
	if weaponData:
		if weaponData.firing_mode == "single":
			if Input.is_action_just_pressed("Shoot") or isBulletBuffered:
				var isBulletShot = attemptAttack()
		if weaponData.firing_mode == "auto":
			if Input.is_action_pressed("Shoot") or isBulletBuffered:
				var isBulletShot = attemptAttack()
