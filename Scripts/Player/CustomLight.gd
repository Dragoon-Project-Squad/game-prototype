extends PointLight2D

<<<<<<< Updated upstream
@export var viewCheck : Area2D
@export var viewCheckShape : Node2D

#An array of all physics bodies that the light should ignore when raycasting
@export var nonHiddenObjectBodiesToIgnore : Array = []
=======
@export (NodePath) onready var viewCheck = get_node(viewCheck)
@export (NodePath) onready var viewCheckShape = get_node(viewCheckShape)

#An array of all physics bodies that the light should ignore when raycasting
@export (Array, NodePath) onready var nonHiddenObjectBodiesToIgnore
>>>>>>> Stashed changes

var hiddenObjectsInViewCheck: Array = []

func _ready():
	setupNonHiddenObjectBodiesToIgnoreArray()
	setupViewCheckSignals()

func _process(_delta):
	lightUpHiddenBodiesInViewCheck()

#Setup
func setupNonHiddenObjectBodiesToIgnoreArray():
	var finalArray = []
	
	for nodepath in nonHiddenObjectBodiesToIgnore:
		finalArray.append(get_node(nodepath))
	
	nonHiddenObjectBodiesToIgnore = finalArray

func setupViewCheckSignals():
<<<<<<< Updated upstream
	viewCheck.body_entered.connect(onBodyEnteredViewCheck)
	viewCheck.body_exited.connect(onBodyExitedViewCheck)
=======
	viewCheck.connect("body_entered", Callable(self, "onBodyEnteredViewCheck"))
	viewCheck.connect("body_exited", Callable(self, "onBodyExitedViewCheck"))
>>>>>>> Stashed changes

#Adding Objects found in Area2D
func onBodyEnteredViewCheck(body: Node):
	if body is HiddenObject:
		hiddenObjectsInViewCheck.append(body)

func onBodyExitedViewCheck(body: Node):
	if body is HiddenObject:
		hiddenObjectsInViewCheck.erase(body)
		body.removeLightSource(self)

#Raycasting to Objects found in Area2D for line of sight
const LightViewCheckAreaLayer: int = 64

func lightUpHiddenBodiesInViewCheck():
	var space_state = get_world_2d().direct_space_state
	for i in range(hiddenObjectsInViewCheck.size()):
		var currentHiddenObject: HiddenObject = hiddenObjectsInViewCheck[i]
		var isInLineOfSight = isPointsWithinViewCheckInLineOfSight(space_state, currentHiddenObject)
		
		if isInLineOfSight:
			hiddenObjectsInViewCheck[i].addLightSource(self)
			continue
		
		hiddenObjectsInViewCheck[i].removeLightSource(self)

func isPointsWithinViewCheckInLineOfSight(space_state, hiddenObject: HiddenObject) -> bool:
	var exceptionArray = []
	exceptionArray.append_array(hiddenObjectsInViewCheck)
	exceptionArray.append_array(nonHiddenObjectBodiesToIgnore)
	
	var visibilityVertices: PackedVector2Array = hiddenObject.visibilityVertices
	
	var isAllPointsInLineOfSight: bool = true
	var isAtLeastOnePointInLineOfSightAndWithinViewCheck: bool = false
	
	for j in range(visibilityVertices.size()):
		var pointToCheck: Vector2 = hiddenObject.global_position + visibilityVertices[j]
		
		var withinViewCheck = isPointWithinViewCheck(space_state, pointToCheck)
		var withinLineOfSight = isPointWithinLineOfSight(space_state, pointToCheck, exceptionArray)
		
		if withinLineOfSight and withinViewCheck:
			isAtLeastOnePointInLineOfSightAndWithinViewCheck = true
		
		if not withinLineOfSight:
			isAllPointsInLineOfSight = false
	
	var result = isAllPointsInLineOfSight or isAtLeastOnePointInLineOfSightAndWithinViewCheck
	
	return result

#Porting Note: Now uses a PhysicsPointQueryParamters2D for everything except max targets.
func isPointWithinViewCheck(space_state, point: Vector2) -> bool:
<<<<<<< Updated upstream
	var intersectparams = PhysicsPointQueryParameters2D.new()
	intersectparams.collide_with_areas = true
	intersectparams.collide_with_bodies = false
	intersectparams.collision_mask = LightViewCheckAreaLayer
	intersectparams.position = point
	var result: Array = space_state.intersect_point(intersectparams, 32)
=======
	var result: Array = space_state.intersect_point(point, 32, [], LightViewCheckAreaLayer, false, true)
	
>>>>>>> Stashed changes
	if result.is_empty():
		return false
	
	return true
#Porting Note: Now uses PhysicsRayQueryParameters2D. collision_mask parameter set to default value.
func isPointWithinLineOfSight(space_state, point: Vector2, exceptionArray: Array) -> bool:
	const COLLISION_MASK = 4294967295
	var raycast_query = PhysicsRayQueryParameters2D.create(point, global_position, COLLISION_MASK, exceptionArray)
	var result: Dictionary = space_state.intersect_ray(raycast_query)
	
	if not result.has("collider"):
		return true
	
	return false

#External Control
var isSwitchedOn := true

func switchLightOff():
	if not isSwitchedOn:
		return
	
	isSwitchedOn = false
	energy = 0
	viewCheckShape.disabled = true

func switchLightOn():
	if isSwitchedOn:
		return
	
	isSwitchedOn = true
	energy = 1
	viewCheckShape.disabled = false
