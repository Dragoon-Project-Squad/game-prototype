extends Node2D

export (NodePath) onready var viewCone = get_node(viewCone)

func _ready():
	setupViewConeSignals()

func _process(delta):
	if isTargetInLineOfSight():
		lastSeenLocation = targetWithinViewCone.global_position

#Vision
onready var lastSeenLocation: Vector2 = global_position

var targetWithinViewCone = null

func setupViewConeSignals():
	viewCone.connect("body_entered", self, "onBodyEnteredViewCone")
	viewCone.connect("body_exited", self, "onBodyExitedViewCone")

func onBodyEnteredViewCone(body):
	if targetWithinViewCone == null:
		targetWithinViewCone = body

func onBodyExitedViewCone(body):
	targetWithinViewCone = null

func isTargetInLineOfSight():
	if targetWithinViewCone == null:
		return false
	
	var space_state = get_world_2d().direct_space_state
	
	var result: Dictionary = space_state.intersect_ray(targetWithinViewCone.global_position, global_position, [], viewCone.collision_mask)
	
	if result.has("collider"):
		return true
	
	return false

#Look Direction
func rotateViewCone(direction: Vector2):
	viewCone.rotation = direction.angle()
