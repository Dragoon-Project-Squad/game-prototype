extends HiddenObject

#minimap
var minimap_icon = "enemy"

#states
enum{
	ROAM, SLASH, AOE, POKE
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

#actions
var action_cooldown = 0
var active_states = [SLASH, AOE, POKE]

#sprites
export (NodePath) onready var sprites = get_node(sprites)

func _ready():
	setType("enemyV2")
	var tree = get_tree()
	if tree.has_group("LevelNavigation"):
		level_navigation = tree.get_nodes_in_group("LevelNavigation")[0]
	if tree.has_group("Player"):
		player = tree.get_nodes_in_group("Player")[0].get_child(0)
	
func _physics_process(delta: float):
	#check if the enemy can do something
	checkAggro()
	if action_cooldown <= 0:
		match current_state:
			ROAM:
				pass
			SLASH:
				slash()
			AOE:
				aoe()
			POKE:
				poke()
			_:
				print("Action not implemented!")
				current_state = ROAM
	else:
		action_cooldown -= delta
	
	#sprites
	sprites.updateDirection(velocity)

#aggro logic
func checkAggro():
	#vision based aggro
	aggro.look_at(player.global_position)
	deaggro.look_at(player.global_position)
	if !player_spotted:
		var collider = aggro.get_collider()
		if collider && collider.get_parent().is_in_group("Player"):
			player_spotted = true
			if action_cooldown <= 0:
				selectActiveState()
	else:
		var collider = deaggro.get_collider()
		if collider && collider.get_parent().is_in_group("Player"):
			pass
		else:
			last_seen = player.global_position
			player_spotted = false

func selectActiveState():
	var states = active_states.duplicate()
	states.shuffle()
	current_state = states[0]

#action specific logic
func slash():
	if global_position.distance_to(player.global_position) > 100:
		chase()
	else:
		print("slash")
		sprites.createSlash(player.global_position)
		action_cooldown = 2
		selectActiveState()
	
func aoe():
	if global_position.distance_to(player.global_position) > 150:
		chase()
	else:
		print("aoe")
		sprites.createAoe(player.global_position)
		action_cooldown = 3
		selectActiveState()

func poke():
	if global_position.distance_to(player.global_position) > 200:
		chase()
	else:
		print("poke")
		sprites.createPoke(player.global_position)
		action_cooldown = 2
		selectActiveState()

func chase():
	#default action, no cooldown required
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
	velocity = move_and_slide(velocity)

#on death
func triggerDeath():
	pass
