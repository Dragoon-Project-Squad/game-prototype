extends Node2D

export (float) var KNOCKBACK_FRICT := 600.0

func getTargetVelocity(data: Dictionary) -> Vector2:
	return data.velocity.move_toward(Vector2.ZERO, KNOCKBACK_FRICT * get_process_delta_time())

func getViewConeDirection(data: Dictionary) -> Vector2:
	var direction: Vector2 = data.lastSeenLocation - global_position
	
	return direction
