extends Node2D
class_name HealthComponent

@export var MAX_HEALTH := 100
var currentHealth : float

func _ready():
	currentHealth = MAX_HEALTH
	

