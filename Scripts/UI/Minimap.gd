extends MarginContainer

@export var player : Node
@export var zoom = 1.5
@export var scan_speed = 200
@export var scan_cooldown = 1

@onready var grid = $Container/Grid
@onready var pulse_line = $Pulse/Area2D
@onready var player_marker = $Container/Grid/PlayerMarker
@onready var enemy_marker = $Container/Grid/EnemyMarker
@onready var objective_marker = $Container/Grid/ObjectiveMarker

@onready var icons = {"enemy": enemy_marker, "objective": objective_marker}

var grid_scale
var on_cooldown = false
var cooldown_timer = 0
var markers = {}

func _ready():
	player_marker.position = grid.size / 2
	grid_scale = grid.size / (get_viewport_rect().size * zoom)

func _process(delta):
	if !player:
		return

	if pulse_line:
		if on_cooldown:
			if cooldown_timer < scan_cooldown:
				cooldown_timer += delta
			else:
				cooldown_timer = 0
				on_cooldown = false
		else:
			if pulse_line.position.y >= grid.size.y:
				pulse_line.position = Vector2(0,0);
				on_cooldown = true
			else:
				pulse_line.position += Vector2(0,scan_speed * delta);

	for item in markers:
		var obj_pos = (item.position - player.position) * grid_scale + grid.size / 2

		if grid.get_rect().has_point(obj_pos + grid.position):
			#markers[item].show()
			markers[item].is_in_frame = true
		else:
			#markers[item].hide()
			markers[item].is_in_frame = false

		obj_pos.x = clamp(obj_pos.x, 0, grid.size.x)
		obj_pos.y = clamp(obj_pos.y, 0, grid.size.y)

		markers[item].position = obj_pos

func getMapObjects():
	var map_objects = get_tree().get_nodes_in_group("minimap_objects")
	for item in map_objects:
		var new_marker = icons[item.minimap_icon].duplicate()
		grid.add_child(new_marker)
		new_marker.modulate.a = 0
		new_marker.show()
		markers[item] = new_marker
