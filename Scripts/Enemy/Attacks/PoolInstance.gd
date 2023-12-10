extends Node2D

<<<<<<< Updated upstream
@export var hitbox : Node
=======
@export (NodePath) onready var hitbox = get_node(hitbox)
>>>>>>> Stashed changes

var growth_rate = 2
var duration = 5
var is_spreading = true

@export var damageOverTime_Timer : Node # added for damage over time function
@export var damageDelay : int #centisecond, how many ticks between incurring damage in pool | must be longer than the highlight interval
@export var damage : int # how much damage each tick

var playerBody = null

func _ready() -> void:
	hitbox.connect("body_entered", Callable(self, "onBodyEnteredHitbox"))
<<<<<<< Updated upstream
	hitbox.connect("body_exited", Callable(self, "onBodyExitedHitbox"))
	
	# timer signals and set-up
	damageOverTime_Timer.connect("timeout", Callable(self, "_WhileInPool"))
	damageOverTime_Timer.set_one_shot(false) # should make timer loop
=======
>>>>>>> Stashed changes

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
		print("player hit")
		
		body.take_damage(damage) # takes damage on first contact
		damageOverTime_Timer.start(damageDelay / 100.0) # starts timer
		playerBody = body # required as a reference to the player outside of this function
		
func _WhileInPool():
	#print("damage tick went off")
	playerBody.take_damage(damage)

func onBodyExitedHitbox(body):
	if body.is_in_group("Player"):
		#print("player exited")
		damageOverTime_Timer.stop() # stops the timer
		
		
