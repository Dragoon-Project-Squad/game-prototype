extends ParallaxBackground

# https://www.asmaloney.com/2021/02/code/vertical-scrolling-parallax-backgrounds-in-godot/
@export var camera_velocity: Vector2 # X changes angle, Y changes velocity | If won't loop, modify ParallaxLayer in scene

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var new_offset: Vector2 = get_scroll_offset() + camera_velocity * delta
	set_scroll_offset( new_offset )
