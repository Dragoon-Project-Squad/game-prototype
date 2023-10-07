extends HiddenObject

#minimap
var minimap_icon = "enemy"

export (NodePath) onready var hidden_sprites = get_node(hidden_sprites)

export (int) var health: int = 1000.0
export (Color) var damageHighlightColor: Color =  Color("#78ff0000") # decides what color the damage highlight is
export (int) var damageHighlightLength: int = 10 # decides how long this will be highlighted upon taking damage
var damageHighlightTimer = null

func _ready():
	# creates a timer and adds it as a child
	damageHighlightTimer = Timer.new() # constructs a new timer
	damageHighlightTimer.wait_time = damageHighlightLength / 100.0 # defines its length, measured in centiseconds
	add_child(damageHighlightTimer)
	damageHighlightTimer.connect("timeout", self, "_endHighlight") # connects signal to function
	
	return

#overrrides
func updateTransparency():
	var changeInAlpha = -1 * TRANSPARENCY_CHANGE_RATE * get_process_delta_time()
	
	if isLitUp():
		changeInAlpha *= -1
		hidden_sprites.modulate.a = max(TRANSPARENCY_ON_LIT, hidden_sprites.modulate.a)
	
	hidden_sprites.modulate.a += changeInAlpha
	hidden_sprites.modulate.a = clamp(hidden_sprites.modulate.a, 0.0, 1.0)

func onHitByBullet(damage: int):
	health -= damage # updates health value
	
	modulate = damageHighlightColor # modulate is defined already, no keyword required
	
	damageHighlightTimer.start() # should reset remaining time to it's wait_time value

func _endHighlight():
	damageHighlightTimer.stop() # stops timer
	
	modulate = Color("ffffff") # resets modulate back to default
