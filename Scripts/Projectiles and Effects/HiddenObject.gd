extends KinematicBody2D
class_name HiddenObject

var lightSources: Array = []
var type = "";
var visible_to_player = false;
#Contains the Nodes telling this object that it is currently under a light

func _process(delta):
	if type == "enemyV2":
		updateVisibility()
	else:
		updateTransparency()

#For Smooth transition from invisible to visible
export (float) var TRANSPARENCY_CHANGE_RATE := 10
export (float) var TRANSPARENCY_ON_LIT := 0.6

func updateTransparency():
	var changeInAlpha = -1 * TRANSPARENCY_CHANGE_RATE * get_process_delta_time()
	
	if isLitUp():
		changeInAlpha *= -1
		modulate.a = max(TRANSPARENCY_ON_LIT, modulate.a)
	
	modulate.a += changeInAlpha
	modulate.a = clamp(modulate.a, 0.0, 1.0)
	
func updateVisibility():
	if isLitUp():
		visible_to_player = true;
	else:
		visible_to_player = false;

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

func setType(typestring):
	type = typestring

#Custom visibility check offsets
export (NodePath) var visibilityPolygon2DPath: NodePath
var visibilityPolygon2D: Polygon2D = null
var visibilityVertices: PoolVector2Array setget , getVisibilityVertices

func getVisibilityVertices() -> PoolVector2Array:
	if visibilityPolygon2DPath.is_empty():
		return PoolVector2Array([Vector2.ZERO])
	
	if visibilityPolygon2D == null:
		visibilityPolygon2D = get_node(visibilityPolygon2DPath)
	
	visibilityVertices = visibilityPolygon2D.polygon
	
	if visibilityVertices.empty():
		return PoolVector2Array([Vector2.ZERO])
	
	return visibilityVertices

