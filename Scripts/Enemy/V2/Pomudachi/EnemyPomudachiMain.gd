extends HiddenObject

#minimap
var minimap_icon = "enemy"

export (NodePath) onready var hidden_sprites = get_node(hidden_sprites)

#overrrides
func updateTransparency():
	var changeInAlpha = -1 * TRANSPARENCY_CHANGE_RATE * get_process_delta_time()
	
	if isLitUp():
		changeInAlpha *= -1
		hidden_sprites.modulate.a = max(TRANSPARENCY_ON_LIT, hidden_sprites.modulate.a)
	
	hidden_sprites.modulate.a += changeInAlpha
	hidden_sprites.modulate.a = clamp(hidden_sprites.modulate.a, 0.0, 1.0)

func onHitByBullet():
	return
