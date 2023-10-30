extends Node2D

@export (NodePath) onready var enemy_control = get_node(enemy_control)

var attack_range = 600
var telegraph_name = "Telegraph"
var animation_name = "Pounce"
var current_special_cooldown = 0
var special_cooldown = 6
var cooldown = 0.5
var hitbox_active = false
var is_attacking = false

var direction
var current_pounce_time = 0
var pounce_time = 0.75

@export (int) var damage: int = 1

func _process(delta: float) -> void:
	if is_attacking:
		if current_pounce_time >= 0:
			enemy_control.velocity = direction * 1000
			enemy_control.enemy_body.set_velocity(enemy_control.velocity)
			enemy_control.enemy_body.move_and_slide()
			enemy_control.velocity = enemy_control.enemy_body.velocity
			current_pounce_time -= delta
		else:
			endAttack()
	
	if current_special_cooldown >= 0:
		current_special_cooldown -= delta

func snapshotDirection():
	direction = global_position.direction_to(enemy_control.attack_player_pos)

func startAttack():
	hitbox_active = true
	is_attacking = true
	current_pounce_time = pounce_time
	enemy_control.animation_player.play("PounceAttack")

func endAttack():
	current_special_cooldown = special_cooldown
	is_attacking = false
	hitbox_active = false
	enemy_control.action_cooldown = cooldown
	enemy_control.action_ready = true
	enemy_control.current_attack_instance = null
	enemy_control.selectNextAction()

func _on_Hitbox_body_entered(body: Node) -> void:
	if hitbox_active:
		if body.is_in_group("Player"):
			enemy_control.animation_player.play("PounceHit")
			print("player hit")
			
			body.take_damage(damage) # calls and sends signal to player, triggers highlight and changes HP value
		elif body.is_in_group("Walls"):
			endAttack()
