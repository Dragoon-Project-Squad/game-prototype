extends Node2D

<<<<<<< Updated upstream
@export var animation_player : Node
=======
@export (NodePath) onready var animation_player = get_node(animation_player)
>>>>>>> Stashed changes

func setPortrait(name: String):
	animation_player.play(name)
