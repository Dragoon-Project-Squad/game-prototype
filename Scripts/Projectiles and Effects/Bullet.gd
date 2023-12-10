extends Node2D
class_name Bullet

<<<<<<< Updated upstream
@export var hitbox : Node

var damage: int # received from script when dynamically made
=======
@export (NodePath) onready var hitbox = get_node(hitbox)
>>>>>>> Stashed changes

func _ready():
	setupHitboxSignals()

func _process(_delta):
	movement()
	queueFreeIfFar()

#Movement
var velocity: Vector2

func movement():
	position += velocity * get_process_delta_time()
	rotation = velocity.angle()

#Hitting Objects
<<<<<<< Updated upstream
@export var BULLET_KNOCKBACK := 50.0

func setupHitboxSignals():
	hitbox.body_entered.connect(onBodyEnteredHitbox)
=======
@export (float) var BULLET_KNOCKBACK := 50.0

func setupHitboxSignals():
	hitbox.connect("body_entered", Callable(self, "onBodyEnteredHitbox"))
>>>>>>> Stashed changes

func onBodyEnteredHitbox(body):
	if body.has_method("onHitByBullet"):
		body.onHitByBullet(self, damage)
	
	activateParticles()
	
	queue_free()

#Particles
<<<<<<< Updated upstream
@export var particlesScene: PackedScene
=======
@export (PackedScene) var particlesScene: PackedScene
>>>>>>> Stashed changes

func activateParticles():
	if particlesScene == null:
		return
	
	var particlesInstance = particlesScene.instantiate()
	
	get_parent().add_child(particlesInstance)
	
	particlesInstance.global_position = global_position
	particlesInstance.rotation = rotation

#QueueFreeing
@export var DISTANCE_TO_FREE := 3000.0
var startPos: Vector2

func queueFreeIfFar():
	if (global_position - startPos).length_squared() > pow(DISTANCE_TO_FREE,2):
		queue_free()
