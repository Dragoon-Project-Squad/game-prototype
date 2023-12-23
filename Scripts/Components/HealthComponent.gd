extends Node2D
class_name HealthComponent

@export_category("Default Value")
@export var MAX_HEALTH := 100
var currentHealth : int

func _ready():
	currentHealth = MAX_HEALTH
	
func heal(amount: int):
	# Might do what you're doing faster unless you've got other features to implement
	# currentHealth = min(currentHealth+amount, MAX_HEALTH) # adds healing w/ a limit
	
	# Checks if the heal will go under the max HP
	if currentHealth < MAX_HEALTH and (currentHealth+amount) < MAX_HEALTH:
		currentHealth += amount
		return true
	# Checks if the heal will go over the max HP, will set the current hp to max hp
	elif currentHealth < MAX_HEALTH and (currentHealth+amount) > MAX_HEALTH:
		currentHealth = MAX_HEALTH
		return true
	else:
		return false

func damage(amount: int):
	currentHealth -= amount
	if currentHealth <= 0:
		get_parent().queue_free()
