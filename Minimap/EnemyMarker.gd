extends KinematicBody2D

var is_in_frame
var is_shown
var vis_amount

var fade_out = 0.5

func _ready() -> void:
	is_in_frame = false
	is_shown = false
	vis_amount = 0

func _process(delta):
	if is_shown && vis_amount > 0:
		modulate.a = vis_amount
		vis_amount -= delta * fade_out
	elif is_shown:
		is_shown = false

func show_marker():
	if is_in_frame && !is_shown:
		vis_amount = 1
		is_shown = true
		print(self)
