extends MarginContainer

export (NodePath) var player
export var zoom = 1.5

onready var grid = $Container/Grid
onready var player_marker = $Container/Grid/PlayerMarker
onready var enemy_marker = $Container/Grid/EnemyMarker
onready var objective_marker = $Container/Grid/ObjectiveMarker

onready var icons = {"enemy": enemy_marker, "objective": objective_marker}

var grid_scale
var markers = {}

func _ready():
	player_marker.position = grid.rect_size / 2
	grid_scale = grid.rect_size / (get_viewport_rect().size * zoom)

func _process(delta):
	if !player:
		return
	
	for item in markers:
		var obj_pos = (item.position - get_node(player).position) * grid_scale + grid.rect_size / 2
		
		if grid.get_rect().has_point(obj_pos + grid.rect_position):
			markers[item].show()
		else:
			markers[item].hide()
		
		obj_pos.x = clamp(obj_pos.x, 0, grid.rect_size.x)
		obj_pos.y = clamp(obj_pos.y, 0, grid.rect_size.y)
		
		markers[item].position = obj_pos

func getMapObjects():
	var map_objects = get_tree().get_nodes_in_group("minimap_objects")
	for item in map_objects:
		var new_marker = icons[item.minimap_icon].duplicate()
		grid.add_child(new_marker)
		new_marker.show()
		markers[item] = new_marker
