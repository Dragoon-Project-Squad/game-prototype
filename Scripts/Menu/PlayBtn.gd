extends Node

# getting variables via Inspector
@export(NodePath) onready var playBtn = get_node(playBtn) # reference to actual button
@export(String, FILE) onready var scenePath # file path for scene to go to

# Called when the node enters the scene tree for the first time.
func _ready():
	# assigning funuction in this script(self) as call when playBtn is pressed
	playBtn.connect("pressed", Callable(self, "_button_pressed"))
	print(scenePath)

func _button_pressed():
	get_tree().change_scene_to_file(scenePath) # changes scene to whatever is at scenePath, also deletes current scene

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
