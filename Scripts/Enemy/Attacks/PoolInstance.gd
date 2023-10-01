extends Node2D

export (NodePath) onready var hitbox = get_node(hitbox)

export (NodePath) onready var damageOverTime_Timer = get_node(damageOverTime_Timer) # added for damage over time function
export (int) onready var damageDelay #centisecond, how many ticks between incurring damage in pool | must be longer than the highlight interval

var growth_rate = 2
var duration = 5
var is_spreading = true

var playerBody = null # temporary variable to store player body

func _ready() -> void:
	hitbox.connect("body_entered", self, "onBodyEnteredHitbox")
	hitbox.connect("body_exited", self, "onBodyExitedHitbox")
	
	# timer signals and set-up
	damageOverTime_Timer.connect("timeout", self, "_WhileInPool")
	damageOverTime_Timer.set_one_shot(false) # should make timer loop

func _process(delta: float) -> void:
	if !is_spreading:
		if duration >= 0:
			duration -= delta
		else:
			queue_free()
	else:
		if scale <= Vector2(2,1):
			scale += Vector2(delta * growth_rate * 2, delta * growth_rate)
		else:
			is_spreading = false
			

func onBodyEnteredHitbox(body):
	if body.is_in_group("Player"):
		#print("player hit")
		
		body.take_damage(1) #get_parent() is a bad call, should be changed to something else
		damageOverTime_Timer.start(damageDelay / 100.0) # starts timer
		playerBody = body # required as a reference to the player outside of this function
		
func _WhileInPool():
	#print("damage tick went off")
	playerBody.get_parent().GotHurt(1) #get_parent() is a bad call, should be changed to something else

func onBodyExitedHitbox(body):
	if body.is_in_group("Player"):
		#print("player exited")
		damageOverTime_Timer.stop() # stops the timer
