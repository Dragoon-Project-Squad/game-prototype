extends HiddenObject

export (NodePath) onready var enemyBody = get_node(enemyBody)
export (NodePath) onready var enemyAesthetics = get_node(enemyAesthetics)
onready var enemyAestheticsStartMaterial: Material = enemyAesthetics.material

func _ready():
	setupViewConeSignals()

func _process(delta):
	chase()
	movement()
	updateHitFlashMat()

#On Hit
export (int) var ENEMY_MAX_HEALTH := 3
export (float, 0.01, 1000) var ENEMY_MASS := 1.0

func onHitByBullet(bulletNode: Bullet):
	var knockbackForce = bulletNode.velocity.normalized() * bulletNode.BULLET_KNOCKBACK
	hitKnockback(knockbackForce)
	hitFlash()

func hitKnockback(knockbackForce: Vector2):
	addImpulse(knockbackForce / ENEMY_MASS)

var hitFlashDur:= 0.0

func hitFlash():
	hitFlashDur = 0.1
	
	if enemyAesthetics.material != MaterialReferences.hitFlashMat:
		enemyAesthetics.material = MaterialReferences.hitFlashMat

func updateHitFlashMat():
	hitFlashDur -= get_process_delta_time()
	
	if hitFlashDur < 0 and enemyAesthetics.material != enemyAestheticsStartMaterial:
		enemyAesthetics.material = enemyAestheticsStartMaterial

func isLitUp() -> bool:
	var hasLightSource = lightSources.size() > 0
	var isHitFlash = hitFlashDur > 0
	
	return hasLightSource or isHitFlash

#On Death
func triggerDeath():
	pass

func activateDeathParticles():
	pass

#Enemy Behaviours
export (float) var CHASE_MAX_SPEED := 200.0
export (float) var CHASE_ACCEL := 400.0

export (NodePath) onready var viewCone = get_node(viewCone)

func setupViewConeSignals():
	viewCone.connect("body_entered", self, "onBodyEnteredViewCone")
	viewCone.connect("body_exited", self, "onBodyExitedViewCone")

var target = null

func onBodyEnteredViewCone(body):
	if target == null:
		target = body

func onBodyExitedViewCone(body):
	target = null

onready var lastSeenLocation: Vector2 = global_position

func chase():
	var targetLocation
	
	if target == null:
		targetLocation = lastSeenLocation
	else:
		targetLocation = target.global_position
		lastSeenLocation = targetLocation
	
	var direction: Vector2 = targetLocation - global_position
	turnViewCone(direction)
	
	velocity = velocity.move_toward(direction.normalized() * CHASE_MAX_SPEED, CHASE_ACCEL * get_process_delta_time())
	
	velocity.clamped(direction.length())

func turnViewCone(direction: Vector2):
	viewCone.rotation = direction.angle()

#Movement
export (float) var MOVE_FRICT := 400.0

var velocity: Vector2 = Vector2.ZERO

func addImpulse(force: Vector2, speedLimit: float = 1000000.0):
	if velocity.dot(force.normalized()) > speedLimit:
		return
	
	velocity += force

func movement():
	velocity = enemyBody.move_and_slide(velocity)
	
	velocity = velocity.move_toward(Vector2.ZERO, MOVE_FRICT * get_process_delta_time())

#Attacking
