extends HiddenObject

@export var movement : Node
@export var aesthetics : Node

#On Hit
@export var ENEMY_MAX_HEALTH := 3
@export_range(0.01, 1000) var ENEMY_MASS := 1.0

func onHitByBullet(bulletNode: Bullet, damage: int):
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
