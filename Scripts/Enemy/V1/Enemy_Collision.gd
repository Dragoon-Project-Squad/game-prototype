extends HiddenObject

export (NodePath) onready var movement = get_node(movement)
export (NodePath) onready var aesthetics = get_node(aesthetics)

#On Hit
export (int) var ENEMY_MAX_HEALTH := 3
export (float, 0.01, 1000) var ENEMY_MASS := 1.0

func onHitByBullet(bulletNode: Bullet):
	var knockbackForce = bulletNode.velocity.normalized() * bulletNode.BULLET_KNOCKBACK
	aesthetics.hitFlash()
	movement.addImpulse(knockbackForce / ENEMY_MASS)
	movement.currentMovementBehaviourIndex = 2

func isLitUp() -> bool:
	var hasLightSource = lightSources.size() > 0
	var isHitFlash = aesthetics.hitFlashDur > 0
	
	return hasLightSource or isHitFlash

#On Death
func triggerDeath():
	pass

func activateDeathParticles():
	pass
