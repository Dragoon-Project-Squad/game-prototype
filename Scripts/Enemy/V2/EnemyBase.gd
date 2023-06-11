extends Node2D
class_name EnemyBase

#states
enum{
	ROAM, CHASE, HALT
}
var current_state = ROAM
var next_attack = null

#movement
var speed = 200;
var velocity = Vector2.ZERO

#external objects
var level_navigation: Navigation2D = null
var player = null

#vision
export (NodePath) onready var aggro = get_node(aggro)
export (NodePath) onready var deaggro = get_node(deaggro)
var player_spotted = false
var last_seen = null

#kinematic body
export (NodePath) onready var enemy_body = get_node(enemy_body)

#visuals
export (NodePath) onready var telegraph = get_node(telegraph)
export (NodePath) onready var main = get_node(main)
export (NodePath) onready var animation_player = get_node(animation_player)

#attack flags
var current_attack = null
var action_ready = true
var attack_player_pos = null

#export arrays
export (Array, NodePath) onready var move_options
export (Array, NodePath) onready var action_options

func _ready():
	selectNextAction()
	animation_player.connect("animation_finished", self, "animationFinished")
	animation_player.play("Idle")
	
	var tree = get_tree()
	if tree.has_group("LevelNavigation"):
		level_navigation = tree.get_nodes_in_group("LevelNavigation")[0]
	if tree.has_group("Player"):
		player = tree.get_nodes_in_group("Player")[0].get_child(0)
	
func _physics_process(delta: float):
	if player:
		checkAggro()
		getCurrentState()

#aggro logic
func checkAggro():
	#vision based aggro
	if player:
		aggro.look_at(player.global_position)
		deaggro.look_at(player.global_position)
		if !player_spotted:
			var collider = aggro.get_collider()
			if collider && collider.get_parent().is_in_group("Player"):
				player_spotted = true
				if current_attack == null:
					selectNextAction()
					current_state = CHASE
		else:
			var collider = deaggro.get_collider()
			if collider && collider.get_parent().is_in_group("Player"):
				pass
			else:
				last_seen = player.global_position
				player_spotted = false

#state behavior, this will be overrided between enemies
func getCurrentState():
	print("getCurrentState has not been implemented")

func selectNextAction():
	print("selectNextAction has not been implemented")

#on death
func triggerDeath():
	print("triggerDeath has not been implemented")


func updateDirection(velocity):
	if velocity.x > 0:
		main.set_flip_h(false)
		telegraph.set_flip_h(false)
	elif velocity.x < 0:
		main.set_flip_h(true)
		telegraph.set_flip_h(true)
		

func animationFinished(anim_name):
	if anim_name == "Attack":
		action_ready = true
		current_attack = null

func startAttack(position, attack_name):
	if position.x > global_position.x:
		main.set_flip_h(false)
		telegraph.set_flip_h(false)
	elif position.x < global_position.x:
		main.set_flip_h(true)
		telegraph.set_flip_h(true)
	attack_player_pos = position
	action_ready = false
	animation_player.play(attack_name)
