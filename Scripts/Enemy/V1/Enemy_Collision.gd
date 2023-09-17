extends HiddenObject

export (NodePath) onready var movement = get_node(movement)
export (NodePath) onready var aesthetics = get_node(aesthetics)

#On Hit
signal hitByPlayer
signal killedByPlayer
const ENEMY_MAX_HEALTH := 3
export (float, 0.01, 1000) var ENEMY_MASS := 1.0
var currentHealth = ENEMY_MAX_HEALTH
func onHitByBullet(bulletNode: Bullet):
	var knockbackForce = bulletNode.velocity.normalized() * bulletNode.BULLET_KNOCKBACK
	getKnockedBack(knockbackForce)
	emit_signal("hitByPlayer")
	#Update this with damage calculation math once thats a thing
	var damage = 1
	takeDamage(damage)
	if (currentHealth <= 0):
		triggerDeath()
	
func isLitUp() -> bool:
	var hasLightSource = lightSources.size() > 0
	var isHitFlash = aesthetics.hitFlashDur > 0
	return hasLightSource or isHitFlash

#On Hit Movement
func getKnockedBack(knockbackForce):
	aesthetics.hitFlash()
	movement.addImpulse(knockbackForce / ENEMY_MASS)
	movement.currentMovementBehaviourIndex = 2


#On Damage
func takeDamage(damage):
	currentHealth = currentHealth - damage

#On Death
func triggerDeath():
	emit_signal("killedByPlayer")
	activateDeathParticles()
	#deathSounds()
	queue_free()
	pass

func activateDeathParticles():
	pass
