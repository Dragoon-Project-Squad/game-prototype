extends CanvasLayer

@export var dialogue: PackedScene
@export var monologue: PackedScene

@export var cutsceneResource: Resource

@export var portraits : Array
var portrait_dict = {
	"Selen": 0,
	"Pomu": 1
}

var is_active = false
var cutscene_playing = false

var cutscene_ending = false
var current_ending_timer = 0
var end_delay = 0.1

var event_list = []

var current_scene = null
var current_type

var event_counter
var line_counter
var event_size
var line_size

func _process(delta: float) -> void:
	if cutscene_ending:
		if current_ending_timer < end_delay:
			current_ending_timer += delta
		else:
			cutscene_ending = false
			current_ending_timer = 0
			is_active = false
			cutscene_playing = false
			get_tree().paused = false
	
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
				cutscene_ending = true

func _ready() -> void:
	pass

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
		current_scene = dialogue.instantiate()
		add_child(current_scene)
		current_scene.setNames(event_list[event_counter].left_id, event_list[event_counter].right_id)
		current_scene.setPortraits(portraits[portrait_dict[event_list[event_counter].left_id]], portraits[portrait_dict[event_list[event_counter].right_id]])
	
	if current_type == "monologue":
		current_scene = monologue.instantiate()
		add_child(current_scene)
		current_scene.setName(event_list[event_counter].id)
		current_scene.setPortrait(portraits[portrait_dict[event_list[event_counter].id]])
		
	handleNext()

func loadEvents(resource):
	get_tree().paused = true
	is_active = true
	cutscene_playing = true
	var test_json_conv = JSON.new()
	test_json_conv.parse(resource.data)
	var result_json = test_json_conv.get_data()
	if result_json.error == OK:
		event_list = result_json.result.data
		event_size = event_list.size()
		event_counter = 0
		loadScene()
	else:
		print("Error: ", result_json.error)
		print("Error Line: ", result_json.error_line)
		print("Error String: ", result_json.error_string)
	
