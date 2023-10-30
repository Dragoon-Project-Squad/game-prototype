extends CanvasLayer

@export (NodePath) onready var left_sprite = get_node(left_sprite)
@export (NodePath) onready var left_toggle = get_node(left_toggle)
@export (NodePath) onready var left_text = get_node(left_text)
@export (NodePath) onready var left_name = get_node(left_name)
@export (NodePath) onready var left_main = get_node(left_main)

var current_text = ""
var current_textbox = null
var is_scrolling = false

func _ready() -> void:
	current_textbox = left_text

func _process(delta: float) -> void:
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
