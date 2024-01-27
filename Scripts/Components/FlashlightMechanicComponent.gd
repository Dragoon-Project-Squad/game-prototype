extends Node2D

var LIGHT_ROTATE_LERP_CONSTANT := 0.1

var viewPlayerArea: PointLight2D
var viewCone: PointLight2D

func _ready():
	viewPlayerArea = get_node("ViewPlayerArea")
	viewCone = get_node("ViewCone")


func _process(delta):
	pointLightToMouse()

func pointLightToMouse():
	var vectorToMouse = get_global_mouse_position() - global_position
	
	var angle = lerp_angle(viewCone.rotation, vectorToMouse.angle(), LIGHT_ROTATE_LERP_CONSTANT)
	viewCone.rotation = angle
