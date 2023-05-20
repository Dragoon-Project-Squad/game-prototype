extends Node2D

export (NodePath) onready var main = get_node(main)
export (NodePath) onready var attack_origin = get_node(attack_origin)

export (PackedScene) var slash: PackedScene

var current_attack = null
var time_to_clear = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	if current_attack:
		if time_to_clear > 0:
			time_to_clear -= delta
		else:
			current_attack.queue_free()
			current_attack = null

func updateDirection(velocity):
	if velocity.x > 0:
		main.set_flip_h(false)
	elif velocity.x < 0:
		main.set_flip_h(true)
		
func facePlayer(player_pos):
	if player_pos.x > global_position.x:
		main.set_flip_h(false)
	elif player_pos.x < global_position.x:
		main.set_flip_h(true)

func windupFrames():
	pass
	
func recoveryFrames():
	pass

func basicAttack(position):
	facePlayer(position)
	var attackInstance = slash.instance()
	attack_origin.look_at(position)
	attack_origin.add_child(attackInstance)
	current_attack = attackInstance;
	time_to_clear = 1