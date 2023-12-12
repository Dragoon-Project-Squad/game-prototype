extends Node2D

@export_category("CharacterBody2D Node")
@export var player: CharacterBody2D

func _ready():
	if player == null:
		player = get_parent()
		
func _process(delta):
	var direction: Vector2
	
	direction.x = Input.get_axis("LeftMove", "RightMove")
	direction.y = Input.get_axis("UpMove", "DownMove")
		
	if direction:
		player.velocity = direction.normalized() * player.SPEED
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.SPEED)
		player.velocity.y = move_toward(player.velocity.x, 0, player.SPEED)
		player.velocity.normalized()
			
	player.move_and_slide()
