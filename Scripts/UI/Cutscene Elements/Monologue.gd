extends CanvasLayer

@export var left_sprite : Node
@export var left_toggle : Node
@export var left_text : Node
@export var left_name : Node
@export var left_main : Node

var current_text = ""
var current_textbox = null
var is_scrolling = false

func _ready() -> void:
	current_textbox = left_text

func _process(_delta) -> void:
	if current_textbox and current_text != "":
		if current_textbox.visible_characters < current_text.length():
			current_textbox.visible_characters += 1
		else:
			is_scrolling = false

func setName(left: String):
	left_name.text = left

func setPortrait(left: PackedScene):
	var left_portrait = left.instantiate()
	
	left_sprite.add_child(left_portrait)
	
func updatePortrait(state: String):
	left_sprite.get_child(0).setPortrait(state)

func skipText():
	current_textbox.visible_characters = current_text.length()
	is_scrolling = false

func nextLine(line: String):
	if line.length() < 999:
		current_text = line
		current_textbox.visible_characters = 0
		current_textbox.text = current_text
		is_scrolling = true
	else:
		print("line is too long to output, try splitting it into multiple lines")

func updateLeftPortrait(name: String, portrait: String):
	pass
