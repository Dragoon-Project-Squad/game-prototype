# basic inheritance
extends Node2D 

# importing node that determines where the bullet spawns at
export (NodePath) onready var bulletSpawnNode = get_node(bulletSpawnNode) 

# importing weapon sprite
export (NodePath) onready var weaponSprite = get_node(weaponSprite)
# getting the sprite child's scale(can be found in the inspector)
onready var weaponSpriteStartScale: Vector2 = weaponSprite.scale # onready indicates that it is grabbing the value before ready() call

# function call for each frame
func _process(delta):
	pointToMouse()

#Aesthetics
# for more https://gamedevbeginner.com/the-right-way-to-lerp-in-unity-with-examples/#how_to_use_lerp_in_unity
export var WEAPON_ROTATE_LERP_CONSTANT := 0.1 # for interpolation b/w 2 pts on weapon rotate; 
var shootDirection: Vector2 # contains direction bullet is fired

func pointToMouse():
	# find the vector difference's unit vector bw mouse's pos & character's pos where their starts is the canvas layer's origin
	# the vector difference is the vector bw the two ends of both vectors
	shootDirection = (get_global_mouse_position() - global_position).normalized()
	
	# perform linear interpolation(lerp) to turn the weapon sprite to the mouse's direction smoothly
	weaponSprite.rotation = lerp_angle(weaponSprite.rotation, shootDirection.angle(), WEAPON_ROTATE_LERP_CONSTANT) # smoothness/spd is determined by the lerp constant
	weaponSprite.scale.y = sign(shootDirection.x) * weaponSpriteStartScale.y # Flips the sprite if direction is turning it upside down

#Shooting
export (PackedScene) var bulletScene: PackedScene # scene/prefab of a bullet object

# variety of variables for bullet attributes
# - export keyword tells Godot to show these as a variable in the Inspector
export (float) var BULLET_INITIAL_SPEED: float = 1000.0
export (float) var BULLETS_PER_SECOND: float = 15.0
export (float) var BULLET_FIRE_CAM_SHAKE_TRAUMA_INCREMENT := 0.3
export (float) var BULLET_SELF_KNOCKBACK_IMPULSE: float = 0.4
export (float) var BULLET_SELF_KNOCKBACK_SPEED_LIMIT: float = 100.0
export (float) var BULLET_MUZZLE_FLASH_DUR: float = 0.2
export (float) var BULLET_SPREAD_ANGLE: float = 0.0
export (float, 0.0, 1.0) var BULLET_SPREAD_RANDOMNESS: float = 0.0
export (int) var BULLET_NUM_PER_SHOT: int = 1

onready var BULLET_CD_PERIOD: float = 1 / BULLETS_PER_SECOND
var isBulletBuffered := false
onready var timeLastShootBullet: float = -BULLET_CD_PERIOD # stores system clock of when bullet was last fired
const BULLET_BUFFER_PERIOD := 0.2

# Returns if bullet shoot successful
# performs checks if player can fire a bullet and if so, does
func attemptShootBullet() -> bool:
	# gets how long the game has been running and converts units from microseconds to ??? 
	var currentTime = Time.get_ticks_usec() / 1000000.0
	
	# ???
	if currentTime - timeLastShootBullet > BULLET_CD_PERIOD - BULLET_BUFFER_PERIOD: 
		isBulletBuffered = true
	
	# checks if player tried to fire during gun's cooldown period
	if currentTime - timeLastShootBullet < BULLET_CD_PERIOD: # compares time elapsed since last bullet vs cooldown period
		return false # just end the function right away

	# since we past the last check, we know we're firing a bullet	
	timeLastShootBullet = currentTime # update time when bullet was last fired
	isBulletBuffered = false # idk why this is here if we have an if statement to make it true prior
	shootBullet() # call function to actually fire bullet
	return true # tell other code that a bullet was successively fired

# fires bullet on call
func shootBullet():
	for i in range(BULLET_NUM_PER_SHOT): # fire as many bullets in 1s as possible
		var bulletInstance = bulletScene.instance() # creates a bullet dynamically
		
		bulletInstance.velocity = getSpreadDirection(i) * BULLET_INITIAL_SPEED # defines the bullet's speed and direction
		
		bulletSpawnNode.add_child(bulletInstance) # adds bullet to scene/level
		
		# defines the bullet's position in the world
		bulletInstance.global_position = global_position
		bulletInstance.startPos = global_position

# returns the dirrection to fire bullet
func getSpreadDirection(index: int) -> Vector2:
	var baseDirection = shootDirection # get the direction towards mouse
	
	var spreadAngle = deg2rad(BULLET_SPREAD_ANGLE) # convert variable for bullet spread from degrees to radians
	
	var rotationAngle = 0.0 # default rotation ie none, fire straight ahead
	
	# if we're firing more than 1 shot, move the next bullet some degrees
	if BULLET_NUM_PER_SHOT > 1:
		rotationAngle = spreadAngle * (0.5 - index * 1/float(BULLET_NUM_PER_SHOT-1))
	
	# if there is no randomness, return the direction vector with default rotation
	if BULLET_SPREAD_RANDOMNESS <= 0.0:
		return baseDirection.rotated(rotationAngle)
	
	# add randomness to bullet's angle
	rotationAngle += rand_range(0.0, BULLET_SPREAD_RANDOMNESS * spreadAngle)
	
	# ???
	rotationAngle = fmod(rotationAngle + spreadAngle/2, spreadAngle) - spreadAngle/2 # fmod returns the remainder of num/denom
	
	# apply rotation and return
	return baseDirection.rotated(rotationAngle)
