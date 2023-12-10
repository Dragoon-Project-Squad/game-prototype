extends Node2D

<<<<<<< Updated upstream
@export var enemy_control : Node
=======
@export (NodePath) onready var enemy_control = get_node(enemy_control)
>>>>>>> Stashed changes

func move():
	pass
