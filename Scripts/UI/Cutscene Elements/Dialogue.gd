extends CanvasLayer

<<<<<<< Updated upstream
@export var left_sprite : Node
@export var left_toggle : Node
@export var left_text : Node
@export var left_name : Node
@export var left_main : Node

@export var right_sprite : Node
@export var right_toggle : Node
@export var right_text : Node
@export var right_name : Node
@export var right_main : Node
=======
@export (NodePath) onready var left_sprite = get_node(left_sprite)
@export (NodePath) onready var left_toggle = get_node(left_toggle)
@export (NodePath) onready var left_text = get_node(left_text)
@export (NodePath) onready var left_name = get_node(left_name)
@export (NodePath) onready var left_main = get_node(left_main)

@export (NodePath) onready var right_sprite = get_node(right_sprite)
@export (NodePath) onready var right_toggle = get_node(right_toggle)
@export (NodePath) onready var right_text = get_node(right_text)
@export (NodePath) onready var right_name = get_node(right_name)
@export (NodePath) onready var right_main = get_node(right_main)
>>>>>>> Stashed changes


var current_text = ""
var current_textbox = null
var is_scrolling = false

func _ready() -> void:
	pass

func _process(_delta) -> void:
	if current_textbox and current_text != "":
		if current_textbox.visible_characters < current_text.length():
			current_textbox.visible_characters += 1
		else:
			is_scrolling = false

func setNames(left: String, right: String):
	left_name.text = left
	right_name.text = right

func setPortraits(left: PackedScene, right: PackedScene):
	var left_portrait = left.instantiate()
	var right_portrait = right.instantiate()
	
	left_sprite.add_child(left_portrait)
	right_sprite.add_child(right_portrait)

func skipText():
	current_textbox.visible_characters = current_text.length()
	is_scrolling = false

func nextLine(focus: String, line: String):
	if line.length() < 999:
		current_text = line
		if focus == "left":
			toggleLeft()
		elif focus == "right":
			toggleRight()
		else:
			print(str("focus '", focus, "' is not valid for this cutscene element"))
	else:
		print("line is too long to output, try splitting it into multiple lines")

func updatePortrait(focus: String, state: String):
	if focus == "left":
		left_sprite.get_child(0).setPortrait(state)
	elif focus == "right":
		right_sprite.get_child(0).setPortrait(state)
	

func toggleLeft():
	left_main.layer = 16
	right_main.layer = 14
	
	left_toggle.visible = true
	right_toggle.visible = false
	
	current_textbox = left_text
	current_textbox.visible_characters = 0
	current_textbox.text = current_text
	is_scrolling = true
	
func toggleRight():
	left_main.layer = 14
	right_main.layer = 16
	
	left_toggle.visible = false
	right_toggle.visible = true
	
	current_textbox = right_text
	current_textbox.visible_characters = 0
	current_textbox.text = current_text
	is_scrolling = true
