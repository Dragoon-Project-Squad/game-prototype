extends Node2D

@export var animation_player : Node

func setPortrait(name: String):
	animation_player.play(name)
