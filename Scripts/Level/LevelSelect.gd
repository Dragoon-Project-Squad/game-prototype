extends Node2D

const level_node = preload("res://Scenes/Menus/LevelSelectNode.tscn")

@export (NodePath) onready var parent_node = get_node(parent_node)
@export (NodePath) onready var camera = get_node(camera)

var scene_size = Vector2(1280, 720)
var node_distance = 200
var scroll_speed = 800

var nodes = []
var current_node
var hovered_node = null
var next_node = null
var last_node = null

var current_time = 0
var time_until_next_scene = 0.5
var is_changing_scenes = false

func _ready() -> void:
	if(LevelSelectData.nodes.size() == 0):
		generateNewPath()
	else:
		loadPath()
	
func _process(delta):
	#camera controls
	if !is_changing_scenes:
		if Input.is_action_pressed("LeftMove"):
			if camera.position.x > 640:
				camera.position.x -= delta * scroll_speed
		if Input.is_action_pressed("RightMove"):
			if camera.position.x < last_node.position.x + node_distance - 640:
				camera.position.x += delta * scroll_speed
	
	#changing scenes
	if is_changing_scenes:
		if current_time < time_until_next_scene:
			current_time += delta
		else:
			current_time = 0
			is_changing_scenes = false
			print("selection made, changing to level scene")
			if(next_node.content == "combat"):
				if(LevelSelectData.combat_pool.size() < 1):
					LevelSelectData.combat_pool = DataLibrary.getCurrentCombatPool(LevelSelectData.area_id)
				LevelSelectData.combat_pool.shuffle()
				var random_room = LevelSelectData.combat_pool.pop_front()
				get_tree().change_scene_to_file("res://Scenes/Levels/" + random_room + ".tscn")
			elif(next_node.content == "shop"):
				get_tree().change_scene_to_file("res://Scenes/Levels/Shop.tscn")
			elif(next_node.content == "scavenge"):
				if(LevelSelectData.scavenge_pool.size() < 1):
					LevelSelectData.scavenge_pool = DataLibrary.getCurrentScavangePool(LevelSelectData.area_id)
				LevelSelectData.scavenge_pool.shuffle()
				var random_room = LevelSelectData.scavenge_pool.pop_front()
				get_tree().change_scene_to_file("res://Scenes/Levels/" + random_room + ".tscn")
			else:
				print("could not find next scene")
				get_tree().change_scene_to_file("res://Scenes/Test Files/RandomWorld.tscn")
	
	if Input.is_action_just_pressed("Click") && hovered_node != null && is_changing_scenes == false:
		if current_node.next_nodes.has(hovered_node):
			LevelSelectData.path_taken.append({"path": hovered_node.path_number, "col": hovered_node.col})
			next_node = hovered_node
			for item in current_node.next_nodes:
				item.is_next = false
				if item == hovered_node:
					item.setHighlightSprite(true)
			
			for item in hovered_node.next_nodes:
				item.is_next = true
			
			is_changing_scenes = true

func generateNewPath():
	randomize()
	
	var cols = LevelSelectData.cols
	var main_paths = LevelSelectData.main_paths
	var extra_path_count = LevelSelectData.extra_paths
	var special_rooms = LevelSelectData.special_rooms
	
	#add start node
	var start_node = level_node.instantiate()
	parent_node.add_child(start_node)
	start_node.is_start = true
	start_node.col = 0
	nodes.append(start_node)
	LevelSelectData.path_taken.append({"path": -1, "col": 0})
	
	#generate main path(s)
	for path in main_paths:
		for col in cols:
			var new_node = level_node.instantiate()
			parent_node.add_child(new_node)
			new_node.path_number = path
			new_node.col = col+1
			if(col == 0):
				connectNodes(start_node, new_node)
			else:
				connectNodes(nodes[nodes.size()-1], new_node)
			nodes.append(new_node)
	
	#add end node
	var end_node = level_node.instantiate()
	parent_node.add_child(end_node)
	end_node.is_end = true
	end_node.col = cols + 1
	nodes.append(end_node)
	for node in nodes:
		if node.col == cols:
			connectNodes(node, end_node)
	
	#generate additional connections betweeen paths, filtering impossible connections
	for i in extra_path_count:
		var node = nodes[randi() % nodes.size()]	#get random node
		while(node.is_start || node.is_end || node.col == cols):
			node = nodes[randi() % nodes.size()]	#that isnt start or end, or connecting to end
		
		var upper_path_neighbor = node.path_number - 1
		var lower_path_neighbor = node.path_number + 1
		
		var possible_nodes = []
		for n in nodes:
			if (n.col == node.col + 1) && !(node.blocked_nodes.has(n)):
				if(n.path_number == upper_path_neighbor && node.can_cross_up):
					possible_nodes.append(n)
					
				if(n.path_number == lower_path_neighbor && node.can_cross_down):
					possible_nodes.append(n)
		
		if(possible_nodes.size() > 0):
			#add connection
			var dest = possible_nodes[randi() % possible_nodes.size()]
			connectNodes(node, dest)
			
			#block neighbor
			for n in nodes:
				if(n.col == node.col && n.path_number == dest.path_number):
					if(node.path_number < dest.path_number):
						n.can_cross_up = false
					else:
						n.can_cross_down = false
	
	#place nodes
	var random_nodes = nodes
	random_nodes.shuffle()
	
	for node in random_nodes:
		if(node.is_start):
			node.setContent("combat")
			node.setHighlightSprite(true)
			node.position = Vector2((node.col+1) * node_distance, scene_size.y/2)
			node.saved_pos = node.position
			
		if(node.is_end):
			node.setContent("boss")
			last_node = node
			node.position = Vector2((node.col+1) * node_distance, scene_size.y/2)
			node.saved_pos = node.position
			
		if(!node.is_start && !node.is_end):
			if(special_rooms.size() > 0):
				node.setContent(special_rooms.pop_front())
			else:
				node.setContent("combat")
			
			var posx = (node.col+1) * node_distance + randf_range(-20, 20)
			var posy = float(node.path_number+1)/(main_paths+1) * scene_size.y + randf_range(-20, 20)
			node.position = Vector2(posx,posy)
			node.saved_pos = node.position
		
		#save to level select
		var next_node_pos = []
		for next_node in node.next_nodes:
			next_node_pos.append(Vector2(next_node.path_number, next_node.col))
			
		LevelSelectData.nodes.append({"path": node.path_number, "col": node.col, "saved_pos": node.saved_pos, "content": node.content, "next_node_pos": next_node_pos})
			
	findCurrent()
	
	#place lines
	parent_node.nodes = nodes
	parent_node.update()
	

func connectNodes(source, dest):
	source.next_nodes.append(dest)
	source.blocked_nodes.append(dest)
	dest.prev_nodes.append(source)
	pass

func loadPath():
	for node_data in LevelSelectData.nodes:
		var new_node = level_node.instantiate()
		parent_node.add_child(new_node)
		new_node.path_number = node_data.path
		new_node.col = node_data.col
		new_node.position = node_data.saved_pos
		new_node.setContent(node_data.content)
		new_node.next_node_pos = node_data.next_node_pos
		nodes.append(new_node)
		if new_node.col == LevelSelectData.cols + 1:
			last_node = new_node
		
	for node in nodes:
		for next_node in node.next_node_pos:
			for dest in nodes:
				if(dest.path_number == next_node.x && dest.col == next_node.y):
					connectNodes(node, dest)
					
	findCurrent()
	
	for path_node in LevelSelectData.path_taken:
		for node in nodes:
			if(node.path_number == path_node.path && node.col == path_node.col):
				node.setHighlightSprite(true)
				break
	
	#place lines
	parent_node.nodes = nodes
	parent_node.update()
	
func findCurrent():
	var current_node_data = LevelSelectData.path_taken[LevelSelectData.path_taken.size() - 1]
	for node in nodes:
		if(node.path_number == current_node_data.path && node.col == current_node_data.col):
			current_node = node
			for next_node in current_node.next_nodes:
				next_node.is_next = true;
			break
