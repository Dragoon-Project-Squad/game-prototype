extends CanvasLayer

export (PackedScene) var dialogue: PackedScene
export (PackedScene) var monologue: PackedScene

export (Array, PackedScene) var portraits
var portrait_dict = {
	"Selen": 0,
	"Pomu": 1
}

var is_active = true

var event_list = []

var current_scene = null
var current_type

var event_counter
var line_counter
var event_size
var line_size

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Menu Select") and is_active and current_scene:
		if(current_scene.is_scrolling):
			current_scene.skipText()
		elif(line_counter < line_size):
			handleNext()
		else:
			line_counter = 0
			event_counter += 1
			current_scene.queue_free()
			if(event_counter < event_size):
				loadScene()
			else:
				is_active = false

func _ready() -> void:
	loadEvents()
	loadScene()

func handleNext():
	if current_type == "dialogue":
		current_scene.nextLine(event_list[event_counter].lines[line_counter].focus, event_list[event_counter].lines[line_counter].text)
		if event_list[event_counter].lines[line_counter].portrait:
			current_scene.updatePortrait(event_list[event_counter].lines[line_counter].focus, event_list[event_counter].lines[line_counter].portrait)
		
	if current_type == "monologue":
		current_scene.nextLine(event_list[event_counter].lines[line_counter].text)
		if event_list[event_counter].lines[line_counter].portrait:
			current_scene.updatePortrait(event_list[event_counter].lines[line_counter].portrait)
	
	line_counter += 1

func loadScene():
	current_type = event_list[event_counter].type
	line_size = event_list[event_counter].lines.size()
	line_counter = 0
	
	if current_type == "dialogue":
		current_scene = dialogue.instance()
		add_child(current_scene)
		current_scene.setNames(event_list[event_counter].left_id, event_list[event_counter].right_id)
		current_scene.setPortraits(portraits[portrait_dict[event_list[event_counter].left_id]], portraits[portrait_dict[event_list[event_counter].right_id]])
	
	if current_type == "monologue":
		current_scene = monologue.instance()
		add_child(current_scene)
		current_scene.setName(event_list[event_counter].id)
		current_scene.setPortrait(portraits[portrait_dict[event_list[event_counter].id]])
		
	handleNext()

func loadEvents():
	event_list = [
		{
			"type": "dialogue",
			"left_id": "Selen",
			"right_id": "Pomu",
			"lines": [
				{
					"focus": "right",
					"text": "Hey... do you like me?",
					"portrait": "1"
				},
				{
					"focus": "left",
					"text": "Domain Expansion",
					"portrait": "1"
				},
				{
					"focus": "right",
					"text": "???????",
					"portrait": "2"
				},
			]
		},
		{
			"type": "monologue",
			"id": "Selen",
			"lines": [
				{
					"text": "...",
					"portrait": "2"
				},
				{
					"text": "She wouldn't get it",
					"portrait": "3"
				},
				{
					"text": "Scrolling text aaaaaaaaaaaaaaaa aaaaaaaaaaaaaaaaaaaaaaaaaaaa aaaaaaaaaaaaaaaaaaaaaaaa aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa aaaaaaaaa",
					"portrait": "3"
				},
			]
		}
	]
	event_size = event_list.size()
	event_counter = 0
