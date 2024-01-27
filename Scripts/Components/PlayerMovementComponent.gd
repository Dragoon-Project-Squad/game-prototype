extends Node2D

@export_category("Dependancies")
@export var player: CharacterBody2D
var acceleration: float = 700.0 #default 500.0
var friction: float = 1500.0 #default 1500.0

#Handles sprite direction from left to right
var SpriteNode: Sprite2D
var SpriteNode_StartingScale 

func _ready():
	
	if player == null:
		player = get_parent()
		
	SpriteNode = player.get_node("Sprite2D")
	SpriteNode_StartingScale = SpriteNode.scale
	
func _physics_process(delta):
	var direction: Vector2
	
	direction.x = Input.get_axis("LeftMove", "RightMove")
	direction.y = Input.get_axis("UpMove", "DownMove")
		
	if direction: #runs when player is pressing an input
		player.velocity = player.velocity.move_toward(2 * (direction.normalized() * player.SPEED), acceleration * delta) 
	else: #runs after when player presses an input, the player will slide based on friction
		player.velocity = player.velocity.move_toward(Vector2.ZERO, friction * delta)
	
	player.move_and_slide()
	spriteFlip(sign(((get_global_mouse_position() - global_position).normalized()).x))
	
func spriteFlip(signX: int):
	if signX == 0:
		return
	SpriteNode.scale.x = signX * SpriteNode_StartingScale.x
