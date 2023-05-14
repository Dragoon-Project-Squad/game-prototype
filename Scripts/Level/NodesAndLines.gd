extends Node2D

var nodes = []

func _ready() -> void:
	pass

func _draw():
	for node in nodes:
		for dest in node.next_nodes:
			draw_line(node.position, dest.position, Color(255, 255, 255), 5)
