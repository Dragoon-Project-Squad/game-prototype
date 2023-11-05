extends Node2D

export (NodePath) onready var text = get_node(text)
export (NodePath) onready var highlight = get_node(highlight)


func setText(new_text):
	text.text = new_text

func setHighlight(val: bool):
	highlight.visible = val
