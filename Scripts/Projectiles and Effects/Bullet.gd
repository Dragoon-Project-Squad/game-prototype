extends Node2D
class_name Bullet

@export var hitbox : Node

var damage: int # received from script when dynamically made

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
@export var BULLET_KNOCKBACK := 50.0

func setupHitboxSignals():
	hitbox.connect("body_entered", Callable(self, "onBodyEnteredHitbox"))

func onBodyEnteredHitbox(body):
	if body.has_method("onHitByBullet"):
		body.onHitByBullet(self, damage)
	
	activateParticles()
	
	queue_free()

#Particles
@export var particlesScene: PackedScene

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
