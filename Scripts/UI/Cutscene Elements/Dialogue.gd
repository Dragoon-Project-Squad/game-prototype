extends CanvasLayer

export (NodePath) onready var left_sprite = get_node(left_sprite)
export (NodePath) onready var left_toggle = get_node(left_toggle)
export (NodePath) onready var left_text = get_node(left_text)
export (NodePath) onready var left_name = get_node(left_name)
export (NodePath) onready var left_main = get_node(left_main)

export (NodePath) onready var right_sprite = get_node(right_sprite)
export (NodePath) onready var right_toggle = get_node(right_toggle)
export (NodePath) onready var right_text = get_node(right_text)
export (NodePath) onready var right_name = get_node(right_name)
export (NodePath) onready var right_main = get_node(right_main)

export (NodePath) onready var screen_options = get_node(screen_options)
export (PackedScene) var dia_option

export (Array, PackedScene) var portraits
var portrait_dict = {
	"Selen": 0,
	"Pomu": 1
}

var left_portrait = null
var right_portrait = null

var current_text = ""
var current_textbox = null
var is_scrolling = false

var options = []
var current_option = -1
var current_option_val = -1
var options_showing = false

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if current_textbox and current_text != "":
		if current_textbox.visible_characters < current_text.length():
			current_textbox.visible_characters += 1
		else:
			is_scrolling = false
		
		if !is_scrolling and !options_showing and options.size() > 0:
			options_showing = true
			screen_options.visible = options_showing
		
		if options_showing:
			if Input.is_action_just_pressed("UpMove"):
				screen_options.get_child(current_option).setHighlight(false)
				
				current_option += 1
				if current_option >= options.size():
					current_option = 0
				
				screen_options.get_child(current_option).setHighlight(true)
				setNextLine()
				
			if Input.is_action_just_pressed("DownMove"):
				screen_options.get_child(current_option).setHighlight(false)
				
				current_option -= 1
				if current_option < 0:
					current_option = options.size() - 1
				
				screen_options.get_child(current_option).setHighlight(true)
				setNextLine()

func setLeftName(left: String):
	left_name.text = left
	
func setRightName(right: String):
	right_name.text = right

func setLeftPortrait(left: PackedScene):
	if left_portrait:
		left_portrait.queue_free()
	left_portrait = left.instance()
	left_sprite.add_child(left_portrait)
	
func setRightPortrait(right: PackedScene):
	if right_portrait:
		right_portrait.queue_free()
	right_portrait = right.instance()
	right_sprite.add_child(right_portrait)

func setLeftState(state: String):
	left_portrait.setPortrait(state)

func setRightState(state: String):
	right_portrait.setPortrait(state)

func skipText():
	current_textbox.visible_characters = current_text.length()
	is_scrolling = false

func nextLine(line, counter) -> int:
	var add_counter = 1
	
	options = []
	options_showing = false
	for child in screen_options.get_children():
		child.queue_free()
	screen_options.visible = options_showing
	
	if "text" in line:
		if line.text.length() < 999:
			current_text = line.text
			
			if "left_portrait" in line:
				setLeftPortrait(portraits[portrait_dict[line.change_left_portrait]])
			
			if "right_portrait" in line:
				setLeftPortrait(portraits[portrait_dict[line.change_right_portrait]])
			
			if "left_state" in line:
				left_portrait.setPortrait(line.left_state)
			
			if "right_state" in line:
				right_portrait.setPortrait(line.right_state)
			
			if "options" in line:
				setOptions(line.options.duplicate())
			
			if "add_counter" in line:
				add_counter = line.add_counter
			
			if "focus" in line:
				if line.focus == "left":
					toggleLeft()
				elif line.focus == "right":
					toggleRight()
				else:
					print(str("focus '", line.focus, "' is not valid for this cutscene element"))
				
			current_textbox.visible_characters = 0
			current_textbox.text = current_text
			is_scrolling = true
				
		else:
			print("line is too long to output, try splitting it into multiple lines")
			current_text = ""
	
	return counter + add_counter

func setOptions(opt):
	var x_offset = 192
	var y_offset = 380
	
	opt.invert()
	for item in opt:
		options.append(item)
		var new_option = dia_option.instance()
		new_option.position = Vector2(x_offset, y_offset)
		screen_options.add_child(new_option)
		new_option.setText(item.text)
		y_offset -= 60
	
	current_option = options.size() - 1
	setNextLine()
	
	screen_options.get_child(current_option).setHighlight(true)

func setNextLine():
	current_option_val = options[current_option].set_line
	if get_parent():
		get_parent().line_counter = current_option_val

func toggleLeft():
	left_main.layer = 16
	right_main.layer = 14
	
	left_toggle.visible = true
	right_toggle.visible = false
	
	current_textbox = left_text
	
func toggleRight():
	left_main.layer = 14
	right_main.layer = 16
	
	left_toggle.visible = false
	right_toggle.visible = true
	
	current_textbox = right_text
