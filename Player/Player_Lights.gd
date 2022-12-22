extends Node2D

export (NodePath) onready var viewZone = get_node(viewZone)
export (NodePath) onready var viewCone = get_node(viewCone)
export (NodePath) onready var viewConeCheck = get_node(viewConeCheck)
export (NodePath) onready var viewConeCheckShape = get_node(viewConeCheckShape)

func _ready():
	resizeViewCone()
	resizeViewZone()

func _process(delta):
	pointLightToMouse()

#View cone Pointing
const LIGHT_ROTATE_LERP_CONSTANT := 0.1

func pointLightToMouse():
	var vectorToMouse = get_global_mouse_position() - global_position
	
	viewCone.rotation = lerp_angle(viewCone.rotation, vectorToMouse.angle(), LIGHT_ROTATE_LERP_CONSTANT)
	viewConeCheck.rotation = viewCone.rotation

#Size of View zone
onready var VIEW_ZONE_TEXTURE_SIZE: Vector2 = viewZone.texture.get_size()

var viewZoneRadius := 150.0 setget setViewZoneRadius

func setViewZoneRadius(input):
	viewZoneRadius = input
	resizeViewZone()

func resizeViewZone():
	var targetViewZoneRadius = viewZoneRadius
	
	var targetViewZoneTextureScale = Vector2(viewZoneRadius, viewZoneRadius) / VIEW_ZONE_TEXTURE_SIZE
	
	viewZone.scale = targetViewZoneTextureScale

#Size of View cone
onready var VIEW_CONE_TEXTURE_SIZE: Vector2 = viewCone.texture.get_size()

var viewConeLength := 400.0 setget setViewConeLength
var viewConeAngle := deg2rad(30.0) setget setViewConeAngle

func setViewConeLength(input):
	viewConeLength = input
	resizeViewCone()

func setViewConeAngle(input):
	viewConeAngle = input
	resizeViewCone()

func resizeViewCone():
	#viewConeAngle is in radians and in 1st quadrant
	
	var targetViewConeLength = viewConeLength
	var targetViewConeHeight = viewConeLength * tan(viewConeAngle/2) * 2
	
	var targetViewConeTextureScale = Vector2(targetViewConeLength, targetViewConeHeight) / VIEW_CONE_TEXTURE_SIZE
	
	viewCone.scale = targetViewConeTextureScale
	
	setupViewConeCheckShapePolygon()

#Light up Hidden Objects in View Cone and View Zone
var hiddenObjectsInViewConeCheck: Array = []
var hiddenObjectsInViewZoneCheck: Array = []

func setupViewConeCheckShapePolygon():
	var points = []
	
	var radius = viewConeLength / cos(viewConeAngle/2)
	
	points.append(Vector2.ZERO)
	points.append(radius * Vector2.RIGHT.rotated(viewConeAngle/2))
	points.append(radius * Vector2.RIGHT.rotated(-viewConeAngle/2))
	
	viewConeCheckShape.polygon = points
