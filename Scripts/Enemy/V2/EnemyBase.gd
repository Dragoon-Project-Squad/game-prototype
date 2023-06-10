extends Node2D
class_name EnemyBase

#states
enum{
	ROAM, CHASE, HALT
}
var current_state = ROAM

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

#state pool
var active_states = [CHASE]

#actions node
export (NodePath) onready var actions = get_node(actions)

#kinematic body
export (NodePath) onready var enemy_body = get_node(enemy_body)

#telegraph node
export (NodePath) onready var telegraph = get_node(telegraph)

func _ready():
	var tree = get_tree()
	if tree.has_group("LevelNavigation"):
		level_navigation = tree.get_nodes_in_group("LevelNavigation")[0]
	if tree.has_group("Player"):
		player = tree.get_nodes_in_group("Player")[0].get_child(0)
	
func _physics_process(delta: float):
	#check if the enemy can do something
	if player:
		checkAggro()
		getCurrentStateAction()

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
				if actions.current_attack == null:
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
func getCurrentStateAction():
	if actions.action_ready && player:
		match current_state:
			HALT:
				pass
			ROAM:
				telegraph.modulate.a = 0
			CHASE:
				telegraph.modulate.a = 1
				#attack logic, ability cooldown checks will happen here
				if global_position.distance_to(player.global_position) > 100:
					chasePlayer()
				else:
					actions.startAttack(player.global_position)
					selectNextAction()
			_:
				print("Action not implemented!")
				current_state = ROAM

func selectNextAction():
	pass

func chasePlayer():
	actions.updateDirection(velocity)
	if level_navigation:
		var path = []
		if player_spotted:
			path = level_navigation.get_simple_path(global_position, player.global_position, false)
		elif last_seen:
			path = level_navigation.get_simple_path(global_position, last_seen, false)
		else:
			return
		
		if path.size() > 2:
			velocity = global_position.direction_to(path[1]) * speed
		else:
			last_seen = null
			current_state = ROAM
	else:
		if player_spotted:
			velocity = global_position.direction_to(player.global_position) * speed
		elif last_seen:
			velocity = global_position.direction_to(last_seen) * speed
			if global_position.distance_to(last_seen) < 10:
				last_seen = null
				current_state = ROAM
		else:
			return
		
	velocity = enemy_body.move_and_slide(velocity)

#on death
func triggerDeath():
	pass
