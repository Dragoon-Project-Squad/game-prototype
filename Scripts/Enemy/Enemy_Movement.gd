extends Node2D

export (NodePath) onready var enemyBody = get_node(enemyBody)
export (NodePath) onready var vision = get_node(vision)
export (Array, NodePath) onready var moveBehaviours

export (float) var MOVE_FRICT := 400.0

func _ready():
	setupMoveBehaviourArray()

func _process(delta):
	movement()
	checkConditions()

#Basic Movement functions
var velocity: Vector2 = Vector2.ZERO

func addImpulse(force: Vector2, speedLimit: float = 1000000.0):
	if velocity.dot(force.normalized()) > speedLimit:
		return
	
	velocity += force

func movement():
	velocity = enemyBody.move_and_slide(velocity)
	
	velocity = behaviourTargetVelocity()
	vision.rotateViewCone(behaviourViewConeDirection())

#Using movement behaviours
var currentMovementBehaviourIndex := 0

func setupMoveBehaviourArray():
	var final = []
	
	for i in range(moveBehaviours.size()):
		final.append(get_node(moveBehaviours[i]))
	
	moveBehaviours = final

func behaviourTargetVelocity() -> Vector2:
	if currentMovementBehaviourIndex == null:
		return Vector2.ZERO
	
	var data = getDataDictionary()
	
	return moveBehaviours[currentMovementBehaviourIndex].getTargetVelocity(data)

func behaviourViewConeDirection() -> float:
	if currentMovementBehaviourIndex == null:
		return 0.0
	
	var data = getDataDictionary()
	
	return moveBehaviours[currentMovementBehaviourIndex].getViewConeDirection(data)

func getDataDictionary() -> Dictionary:
	var data = {"velocity": velocity,
				"lastSeenLocation": vision.lastSeenLocation}
	
	return data

#Switching movement behaviours
func checkConditions():
	match currentMovementBehaviourIndex:
		0:
			if vision.isTargetInLineOfSight():
				currentMovementBehaviourIndex = 1
		1:
			if not vision.isTargetInLineOfSight() and (vision.lastSeenLocation - global_position).length() < 5:
				currentMovementBehaviourIndex = 0
		2:
			if velocity.length_squared() < 1:
				currentMovementBehaviourIndex = 0
 
