extends HiddenObject

#minimap
var minimap_icon = "enemy"

#On Hit
export (int) var ENEMY_MAX_HEALTH := 3
export (float, 0.01, 1000) var ENEMY_MASS := 1.0

func isLitUp() -> bool:
	var hasLightSource = lightSources.size() > 0
	
	return hasLightSource

#On Death
func triggerDeath():
	pass

func activateDeathParticles():
	pass
