extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal key_acquired

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", self, "body_entered")
	connect("key_acquired", owner, "key_acquired")

func body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		emit_signal("key_acquired")
		get_parent().queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
