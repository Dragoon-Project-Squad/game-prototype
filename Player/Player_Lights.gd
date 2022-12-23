extends Node2D

export (NodePath) onready var muzzleFlash = get_node(muzzleFlash)
export (NodePath) onready var muzzleFlashCheckShape = get_node(muzzleFlashCheckShape)
export (NodePath) onready var viewZone = get_node(viewZone)
export (NodePath) onready var viewCone = get_node(viewCone)
export (NodePath) onready var viewConeCheckShape = get_node(viewConeCheckShape)
export (NodePath) onready var muzzleFlashRotate = get_node(muzzleFlashRotate)
export (NodePath) onready var viewConeRotate = get_node(viewConeRotate)

func _ready():
	resizeViewCone()
	resizeViewZone()
	resizeMuzzleFlash()
	setUpMuzzleFlash()

func _process(delta):
	pointLightToMouse()

#View cone Pointing
export var LIGHT_ROTATE_LERP_CONSTANT := 0.1

func pointLightToMouse():
	var vectorToMouse = get_global_mouse_position() - global_position
	
	var angle = lerp_angle(viewConeRotate.rotation, vectorToMouse.angle(), LIGHT_ROTATE_LERP_CONSTANT)
	viewConeRotate.rotation = angle
	muzzleFlashRotate.rotation = angle

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
	
	updateViewConeCheckShapePolygon()

func updateViewConeCheckShapePolygon():
	var points = []
	
	var radius = viewConeLength / cos(viewConeAngle/2)
	
	points.append(Vector2.ZERO)
	points.append(radius * Vector2.RIGHT.rotated(viewConeAngle/2))
	points.append(radius * Vector2.RIGHT.rotated(-viewConeAngle/2))
	
	viewConeCheckShape.polygon = points

#Size of MuzzleFlash
onready var MUZZLE_FLASH_TEXTURE_SIZE: Vector2 = muzzleFlash.texture.get_size()

var muzzleFlashLength := 50.0 setget setMuzzleFlashLength
var muzzleFlashHeight := 200.0 setget setMuzzleFlashHeight

func setMuzzleFlashLength(input):
	muzzleFlashLength = input
	resizeMuzzleFlash()

func setMuzzleFlashHeight(input):
	muzzleFlashHeight = input
	resizeMuzzleFlash()

func resizeMuzzleFlash():
	var targetMuzzleFlashTextureScale = Vector2(muzzleFlashLength, muzzleFlashHeight) / VIEW_CONE_TEXTURE_SIZE
	
	muzzleFlash.scale = targetMuzzleFlashTextureScale
	
	setupMuzzleFlashCheckShapePolygon()

func setupMuzzleFlashCheckShapePolygon():
	var points = []
	
	points.append(Vector2.ZERO)
	points.append(Vector2(muzzleFlashLength, muzzleFlashHeight/2))
	points.append(Vector2(muzzleFlashLength, -muzzleFlashHeight/2))
	
	muzzleFlashCheckShape.polygon = points

#MuzzleFlash
func setUpMuzzleFlash():
	muzzleFlash.switchLightOff()

func triggerMuzzleFlash(duration: float):
	muzzleFlash.switchLightOn()
	yield(get_tree().create_timer(duration), "timeout")
	muzzleFlash.switchLightOff()
