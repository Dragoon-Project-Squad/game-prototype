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
func lightUpHiddenBodiesInViewCheck():
	var space_state = get_world_2d().direct_space_state
	
	for i in range(hiddenObjectsInViewCheck.size()):
		var exceptionArray = []
		exceptionArray.append_array(hiddenObjectsInViewCheck)
		exceptionArray.append_array(nonHiddenObjectBodiesToIgnore)
		
		var result: Dictionary = space_state.intersect_ray(hiddenObjectsInViewCheck[i].global_position, global_position, exceptionArray)
		
		if not result.has("collider"):
			hiddenObjectsInViewCheck[i].addLightSource(self)
			continue
		
		hiddenObjectsInViewCheck[i].removeLightSource(self)

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
