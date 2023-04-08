extends CanvasLayer

const level_node = preload("res://LevelSelect/LevelSelectNode.tscn")

export (NodePath) onready var parent_node = get_node(parent_node)

var scene_size = Vector2(1280, 720)

var nodes = [];
var path_taken = [];
var player_stage = 0;
var hovered_node = null;

func _ready() -> void:
	if(nodes.size() == 0):
		generateNewPath()
	else:
		loadPath()
	
func _process(delta):
	if Input.is_action_just_pressed("Click") && hovered_node != null:
		var currentNode = path_taken[path_taken.size() - 1]
		if currentNode.nextNodes.has(hovered_node):
			path_taken.append(hovered_node)
			for item in currentNode.nextNodes:
				item.isNext = false
				if item == hovered_node:
					item.setHighlightSprite(true)
			
			for item in hovered_node.nextNodes:
				item.isNext = true

func generateNewPath():
	randomize()
	
	var cols = 6
	
	#add start node
	var start_node = level_node.instance()
	parent_node.add_child(start_node)
	start_node.isStart = true
	start_node.col = 0
	nodes.append(start_node)
	path_taken.append(start_node)
	
	#generate main path(s)
	var main_paths = 3
	for path in main_paths:
		for col in cols:
			var new_node = level_node.instance()
			parent_node.add_child(new_node)
			new_node.path_number = path
			new_node.col = col+1
			if(col == 0):
				connectNodes(start_node, new_node)
				new_node.isNext = true
			else:
				connectNodes(nodes[nodes.size()-1], new_node)
			nodes.append(new_node)
	
	#add end node
	var end_node = level_node.instance()
	parent_node.add_child(end_node)
	end_node.isEnd = true
	end_node.col = cols + 1
	nodes.append(end_node)
	for node in nodes:
		if node.col == cols:
			connectNodes(node, end_node)
	
	#generate additional connections betweeen paths, filtering impossible connections
	var extra_path_count = 8
	for i in extra_path_count:
		var node = nodes[randi() % nodes.size()]	#get random node
		while(node.isStart || node.isEnd || node.col == cols):
			node = nodes[randi() % nodes.size()]	#that isnt start or end, or connecting to end
		
		var upper_path_neighbor = node.path_number - 1
		var lower_path_neighbor = node.path_number + 1
		
		var possible_nodes = []
		for n in nodes:
			if (n.col == node.col + 1) && !(node.blockedNodes.has(n)):
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
	var special_rooms = ["shop", "scavenge", "scavenge", "shop", "scavenge"]
	var random_nodes = nodes
	random_nodes.shuffle()
	
	for node in random_nodes:
		if(node.isStart):
			node.setSprite("combat")
			node.setHighlightSprite(true)
			node.position = Vector2((float(1)/(cols+2)) * scene_size.x, scene_size.y/2)
			
		if(node.isEnd):
			node.setSprite("boss")
			node.position = Vector2((float(cols+1)/(cols+2)) * scene_size.x, scene_size.y/2)
			
		if(!node.isStart && !node.isEnd):
			if(special_rooms.size() > 0):
				node.setSprite(special_rooms.pop_front())
			else:
				node.setSprite("combat")
			
			var posx = float(node.col+1)/(cols+3) * scene_size.x + rand_range(-20, 20)
			var posy = float(node.path_number+1)/(main_paths+1) * scene_size.y + rand_range(-20, 20)
			node.position = Vector2(posx,posy)
			node.saved_pos = Vector2(posx,posy)
			
	#place lines
	parent_node.nodes = nodes
	parent_node.update()

func assign_nodes():
	for node in nodes:
		pass

func connectNodes(source, dest):
	source.nextNodes.append(dest)
	source.blockedNodes.append(dest)
	dest.prevNodes.append(source)
	pass

func loadPath():
	pass

