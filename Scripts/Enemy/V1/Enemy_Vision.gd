extends Node2D

@export var viewCone : Area2D

func _ready():
	setupViewConeSignals()

func _process(_delta):
	if isTargetInLineOfSight():
		lastSeenLocation = targetWithinViewCone.global_position

#Vision
@onready var lastSeenLocation: Vector2 = global_position

var targetWithinViewCone = null

func setupViewConeSignals():
	viewCone.body_entered.connect(onBodyEnteredViewCone)
	viewCone.body_exited.connect(onBodyExitedViewCone)

func onBodyEnteredViewCone(body):
	if targetWithinViewCone == null:
		targetWithinViewCone = body

func onBodyExitedViewCone(body):
	targetWithinViewCone = null

#Porting Note: Now uses PhysicsRayQueryParameters2D
func isTargetInLineOfSight():
	if targetWithinViewCone == null:
		return false
	
	var space_state = get_world_2d().direct_space_state
	var raycast_query = PhysicsRayQueryParameters2D.create(targetWithinViewCone.global_position, global_position, viewCone.collision_mask)
	var result: Dictionary = space_state.intersect_ray(raycast_query)
	
	if result.has("collider"):
		return true
	
	return false

#Look Direction
func rotateViewCone(direction: Vector2):
	viewCone.rotation = direction.angle()
