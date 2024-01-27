extends Node2D
class_name HealthComponent

@export_category("Default Value")
@export var MAX_HEALTH := 100
var currentHealth : int

func _ready():
	currentHealth = MAX_HEALTH
	
func heal(amount: int):
	# Might do what you're doing faster unless you've got other features to implement
	currentHealth = min(currentHealth+amount, MAX_HEALTH) # adds healing w/ a limit
	return true

func damage(amount: int):
	currentHealth -= amount
	if currentHealth <= 0:
		get_parent().queue_free()
