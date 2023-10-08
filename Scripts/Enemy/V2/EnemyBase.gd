extends HiddenObject
class_name EnemyBase

#states
enum{
	ROAM, CHASE, HALT
}
var current_state = ROAM

#stats
export (int) var health: int = 10000

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
var current_attack_instance = null
var action_ready = true
var attack_player_pos = null
var action_cooldown = 0

#export arrays
export (Array, NodePath) onready var move_options
export (Array, NodePath) onready var action_options
var next_attack = null

#damage highlight
var damageHighlightTimer: Timer = null
export (int) var damageHighlightLength: int = 20 # centiseconds, how long highlight lasts
export (Color) var damageHighlightColor: Color = Color("#78ff0000") # decides what color the damage highlight is

func _ready():
	# sets up timer for damage highlight
	setupHighlightTimers()
	
	selectNextAction()
	animation_player.connect("animation_finished", self, "animationFinished")
	animation_player.play("Idle")
	
	var tree = get_tree()
	if tree.has_group("LevelNavigation"):
		level_navigation = tree.get_nodes_in_group("LevelNavigation")[0]
	if tree.has_group("Player"):
		player = tree.get_nodes_in_group("Player")[0].get_child(0)
	
func _physics_process(delta: float):
	if action_cooldown > 0:
		action_cooldown -= delta
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
				if current_attack_instance == null:
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
	var options = action_options.duplicate()
	options.shuffle()
	next_attack = options[0]

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
	if get_node(next_attack) && anim_name == get_node(next_attack).animation_name:
		action_cooldown = get_node(next_attack).cooldown
		action_ready = true
		current_attack_instance = null
		selectNextAction()

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
	
#code triggered when hit by an attack
func setupHighlightTimers(): # made into helper func if _ready() is overriden
	# create a new timer
	damageHighlightTimer = Timer.new()
	
	# sets its length
	damageHighlightTimer.wait_time = (damageHighlightLength / 100.0) # measured in centiseconds
	
	# adds to scene's tree
	add_child(damageHighlightTimer) 
	
	# connects timer's signal to function
	damageHighlightTimer.connect("timeout", self, "_onDamagedTimerEnd")

func _highlightSelf(): # made into helper func if onHitByBullet() is overriden
	# changes highlight
	modulate = damageHighlightColor
	
	# starts timer
	damageHighlightTimer.start()

func onHitByBullet(bullet: Bullet, damage: int):
	# updates health value
	health -= damage
	
	# highlights self to indicate was damaged
	_highlightSelf()
	
func _onDamagedTimerEnd():
	# resets color to default
	modulate = Color("ffffff")
	
	# stops timer 
	damageHighlightTimer.stop()
