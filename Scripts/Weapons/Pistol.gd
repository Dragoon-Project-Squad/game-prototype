extends WeaponRanged

func _process(_delta):
	if Input.is_action_pressed("Shoot") or isBulletBuffered:
			var isBulletShot = attemptAttack()
