extends Node2D

#Enemy Behaviours
export (float) var PATROL_MAX_SPEED := 200.0
export (float) var PATROL_ACCEL := 400.0

onready var START_POS = global_position

func getTargetVelocity(data: Dictionary) -> Vector2:
	var direction: Vector2 = getDirection(data)
	
	return data.velocity.move_toward(direction.normalized() * PATROL_MAX_SPEED, PATROL_ACCEL * get_process_delta_time())

func getViewConeDirection(data: Dictionary) -> Vector2:
	var direction: Vector2 = getDirection(data)
	
	return direction

func getDirection(data: Dictionary) -> Vector2:
	return START_POS - global_position
