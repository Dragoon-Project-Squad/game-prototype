extends Node2D

#Enemy Behaviours
@export var CHASE_MAX_SPEED := 200.0
@export var CHASE_ACCEL := 400.0

func getTargetVelocity(data: Dictionary) -> Vector2:
	var direction: Vector2 = getDirection(data)
	
	return data.velocity.move_toward(direction.normalized() * CHASE_MAX_SPEED, CHASE_ACCEL * get_process_delta_time())

func getViewConeDirection(data: Dictionary) -> Vector2:
	var direction: Vector2 = getDirection(data)
	
	return direction

func getDirection(data: Dictionary) -> Vector2:
	return data.lastSeenLocation - global_position
