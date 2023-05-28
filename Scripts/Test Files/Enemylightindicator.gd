extends Node2D


onready var init_timer = $InitTimer

export var time_on : float
export var time_off : float

			

func _on_EnemyCheck_body_entered(body):
	if body.is_in_group("Enemy"):
		flicker_lights()
	pass # Replace with function body.

# flicker lights when body enters, should replace with a signal detect instead so 
# continuous flicker if enemy in light

func flicker_lights():
	
	for i in 20:
		if $Viewzone.isSwitchedOn:
			init_timer.start(rand_range(0.1,time_off))
			yield(init_timer, "timeout")
			$Viewzone.switchLightOff()
		else:
			init_timer.start(rand_range(0.1,time_on))
			yield(init_timer, "timeout")
			$Viewzone.switchLightOn()
