extends Node2D

func toggleLight():
	if $Viewzone.isSwitchedOn:
		$Viewzone.switchLightOff()
		$Timer.start(randf_range(0.1,3))
	else:
		$Viewzone.switchLightOn()
		$Timer.start(randf_range(0.1,0.6))

func _on_Timer_timeout():
	toggleLight()
