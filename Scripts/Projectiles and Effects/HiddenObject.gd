extends Node2D
class_name HiddenObject

var lightSources: Array = []
#Contains the Nodes telling this object that it is currently under a light

func _process(_delta):
	updateTransparency()

#For Smooth transition from invisible to visible
@export var TRANSPARENCY_CHANGE_RATE = 10
@export var TRANSPARENCY_ON_LIT = 0.6

func updateTransparency():
	var changeInAlpha = -1 * TRANSPARENCY_CHANGE_RATE * get_process_delta_time()
	
	if isLitUp():
		changeInAlpha *= -1
		modulate.a = max(TRANSPARENCY_ON_LIT, modulate.a)
	
	modulate.a += changeInAlpha
	modulate.a = clamp(modulate.a, 0.0, 1.0)

#For handling the lighting
func isLitUp() -> bool:
	return lightSources.size() > 0

func addLightSource(node):
	if lightSources.has(node):
		return
	
	lightSources.append(node)

func removeLightSource(node):
	if not lightSources.has(node):
		return
	
	lightSources.erase(node)

#Custom visibility check offsets
@export var visibilityPolygon2DPath: NodePath
var visibilityPolygon2D: Polygon2D = null
var visibilityVertices: PackedVector2Array: get = getVisibilityVertices

func getVisibilityVertices() -> PackedVector2Array:
	if visibilityPolygon2DPath.is_empty():
		return PackedVector2Array([Vector2.ZERO])
	
	if visibilityPolygon2D == null:
		visibilityPolygon2D = get_node(visibilityPolygon2DPath)
	
	visibilityVertices = visibilityPolygon2D.polygon
	
	if visibilityVertices.is_empty():
		return PackedVector2Array([Vector2.ZERO])
	
	return visibilityVertices
