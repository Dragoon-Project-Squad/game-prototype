extends HiddenObject
class_name EnemyBase

#states
enum{
	ROAM, CHASE, HALT
}
var current_state = ROAM

#stats
@export var health: int = 10000

#movement
var speed = 200;
var velocity = Vector2.ZERO

#external objects
var level_navigation: NavigationAgent2D = null
var player = null

#vision
@export var aggro : RayCast2D
@export var deaggro : RayCast2D
var player_spotted = false
var last_seen = null

#kinematic body
@export var enemy_body : CharacterBody2D

#visuals
@export var telegraph_sprite : Sprite2D
@export var main_sprite : Sprite2D
@export var animation_player : AnimationPlayer

#attack flags
var current_attack_instance = null
var action_ready = true
var attack_player_pos = null
var action_cooldown = 0

#export arrays
@export var move_options : Array
@export var action_options : Array
var next_attack = null

#damage highlight
var damageHighlightTimer: Timer = null
@export var damageHighlightLength: int = 20 # centiseconds, how long highlight lasts
@export var damageHighlightColor: Color = Color("#78ff0000") # decides what color the damage highlight is

func _ready():
	# sets up timer for damage highlight
	setupHighlightTimers()
	selectNextAction()
	animation_player.animation_finished.connect(animationFinished)
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
	pass
	#print("getCurrentState has not been implemented")

func selectNextAction():
	var options = action_options.duplicate()
	options.shuffle()
	next_attack = options[0]

#on death
func triggerDeath():
	print("triggerDeath has not been implemented")


func updateDirection(enemy_velocity):
	if enemy_velocity.x > 0:
		main_sprite.set_flip_h(false)
		telegraph_sprite.set_flip_h(false)
	elif enemy_velocity.x < 0:
		main_sprite.set_flip_h(true)
		telegraph_sprite.set_flip_h(true)


func animationFinished(anim_name = "Idle"):
	if get_node(next_attack) && anim_name == get_node(next_attack).animation_name:
		action_cooldown = get_node(next_attack).cooldown
		action_ready = true
		current_attack_instance = null
		selectNextAction()

func startAttack(attack_position, attack_name):
	if attack_position.x > global_position.x:
		main_sprite.set_flip_h(false)
		telegraph_sprite.set_flip_h(false)
	elif attack_position.x < global_position.x:
		main_sprite.set_flip_h(true)
		telegraph_sprite.set_flip_h(true)
	attack_player_pos = attack_position
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
	damageHighlightTimer.connect("timeout", Callable(self, "_onDamagedTimerEnd"))

func _highlightSelf(): # made into helper func if onHitByBullet() is overriden
	# changes highlight
	modulate = damageHighlightColor

	# starts timer
	damageHighlightTimer.start()

func onHitByBullet(_bullet: Bullet, damage: int):
	# updates health value
	health -= damage

	# highlights self to indicate was damaged
	_highlightSelf()

func _onDamagedTimerEnd():
	# resets color to default
	modulate = Color("ffffff")

	# stops timer
	damageHighlightTimer.stop()
