extends Node2D
class_name Bullet

export (NodePath) onready var hitbox = get_node(hitbox)

func _ready():
	setupHitboxSignals()

func _process(delta):
	movement()
	queueFreeIfFar()

#Movement
var velocity: Vector2

func movement():
	position += velocity * get_process_delta_time()
	rotation = velocity.angle()

#Hitting Objects
export (float) var BULLET_KNOCKBACK := 50.0

func setupHitboxSignals():
	hitbox.connect("body_entered", self, "onBodyEnteredHitbox")

func onBodyEnteredHitbox(body):
	if body.has_method("onHitByBullet"):
		body.onHitByBullet(self)
	
	activateParticles()
	
	queue_free()

#Particles
export (PackedScene) var particlesScene: PackedScene

func activateParticles():
	if particlesScene == null:
		return
	
	var particlesInstance = particlesScene.instance()
	
	get_parent().add_child(particlesInstance)
	
	particlesInstance.global_position = global_position
	particlesInstance.rotation = rotation

#QueueFreeing
export var DISTANCE_TO_FREE := 3000.0
var startPos: Vector2

func queueFreeIfFar():
	if (global_position - startPos).length_squared() > pow(DISTANCE_TO_FREE,2):
		queue_free()
