extends Node2D

@export var enemyBody : HiddenObject
@export var vision : Node2D
@export var moveBehaviours : Array

@export var MOVE_FRICT := 400.0

func _ready():
	setupMoveBehaviourArray()

func _process(_delta):
	movement()
	checkConditions()

#Basic Movement functions
var velocity: Vector2 = Vector2.ZERO

func addImpulse(force: Vector2, speedLimit: float = 1000000.0):
	if velocity.dot(force.normalized()) > speedLimit:
		return
	
	velocity += force

func movement():
	enemyBody.set_velocity(velocity)
	enemyBody.move_and_slide()
	velocity = enemyBody.velocity
	
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

#Porting Note: The method that accepts this wants a Vector2, 
#it originally released Vector2s, so I'm changing it to Vector2

func behaviourViewConeDirection() -> Vector2:
	if currentMovementBehaviourIndex == null:
		return Vector2.ZERO #Porting Note: 0.0 -> Vector2.ZERO
	
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
 
