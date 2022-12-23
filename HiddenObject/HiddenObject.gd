extends Node2D
class_name HiddenObject

var lightSources: Array = []
#Contains the Nodes telling this object that it is currently under a light

func _process(delta):
	visible = isLitUp()

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

