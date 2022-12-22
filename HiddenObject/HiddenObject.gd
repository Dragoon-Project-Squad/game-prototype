extends Node2D
class_name HiddenObject

var lightSources: Array = []
#Contains the Nodes telling this object that it is currently under a light

func _process(delta):
	checkIfLit()

func checkIfLit():
	visible = lightSources.size() > 0

func addLightSource(node):
	if lightSources.has(node):
		return
	
	lightSources.append(node)

func removeLightSource(node):
	if not lightSources.has(node):
		return
	
	lightSources.erase(node)
