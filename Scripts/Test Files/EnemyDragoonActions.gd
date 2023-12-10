extends Node2D

<<<<<<< Updated upstream
@export var main : Node
@export var telegraph : Node
@export var animation_player : Node
=======
@export (NodePath) onready var main = get_node(main)
@export (NodePath) onready var telegraph = get_node(telegraph)
@export (NodePath) onready var animation_player = get_node(animation_player)
>>>>>>> Stashed changes



var current_attack = null
var action_ready = true
var player_pos = null

func _ready() -> void:
<<<<<<< Updated upstream
	animation_player.animation_finished.connect(animationFinished)
=======
	animation_player.connect("animation_finished", Callable(self, "animationFinished"))
>>>>>>> Stashed changes
	animation_player.play("Idle")

func _process(delta: float) -> void:
	pass

func updateDirection(velocity):
	if velocity.x > 0:
		main.set_flip_h(false)
		telegraph.set_flip_h(false)
	elif velocity.x < 0:
		main.set_flip_h(true)
		telegraph.set_flip_h(true)
		
func facePlayer(player_pos):
	if player_pos.x > global_position.x:
		main.set_flip_h(false)
		telegraph.set_flip_h(false)
	elif player_pos.x < global_position.x:
		main.set_flip_h(true)
		telegraph.set_flip_h(true)

func animationFinished(anim_name):
	if anim_name == "Attack":
		action_ready = true

func startAttack(position):
	facePlayer(position)
	player_pos = position
	action_ready = false
	animation_player.play("Attack")

#var attackInstance = slash.instance()
		#attackInstance.connect("tree_exited", self, "attackEnded")
		#attack_origin.look_at(player_pos)
		#attack_origin.add_child(attackInstance)
		#current_attack = attackInstance
