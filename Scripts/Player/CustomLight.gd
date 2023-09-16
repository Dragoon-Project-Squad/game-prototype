extends Light2D

export (NodePath) onready var viewCheck = get_node(viewCheck)
export (NodePath) onready var viewCheckShape = get_node(viewCheckShape)

#An array of all physics bodies that the light should ignore when raycasting
export (Array, NodePath) onready var nonHiddenObjectBodiesToIgnore

var hiddenObjectsInViewCheck: Array = []

func _ready():
	setupNonHiddenObjectBodiesToIgnoreArray()
	setupViewCheckSignals()

func _process(delta):
	lightUpHiddenBodiesInViewCheck()

#Setup
func setupNonHiddenObjectBodiesToIgnoreArray():
	var finalArray = []
	
	for nodepath in nonHiddenObjectBodiesToIgnore:
		finalArray.append(get_node(nodepath))
	
	nonHiddenObjectBodiesToIgnore = finalArray

func setupViewCheckSignals():
	viewCheck.connect("body_entered", self, "onBodyEnteredViewCheck")
	viewCheck.connect("body_exited", self, "onBodyExitedViewCheck")

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
	
	var visibilityVertices: PoolVector2Array = hiddenObject.visibilityVertices
	
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

func isPointWithinViewCheck(space_state, point: Vector2) -> bool:
	var result: Array = space_state.intersect_point(point, 32, [], LightViewCheckAreaLayer, false, true)
	
	if result.empty():
		return false
	
	return true

func isPointWithinLineOfSight(space_state, point: Vector2, exceptionArray: Array) -> bool:
	var result: Dictionary = space_state.intersect_ray(point, global_position, exceptionArray)
	
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
