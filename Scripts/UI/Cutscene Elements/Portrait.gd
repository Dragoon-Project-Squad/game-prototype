extends Node2D

@export (NodePath) onready var animation_player = get_node(animation_player)

func setPortrait(name: String):
	animation_player.play(name)
