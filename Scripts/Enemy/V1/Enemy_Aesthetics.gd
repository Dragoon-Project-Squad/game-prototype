extends Node2D

func _process(delta):
	updateHitFlashMat()

@export (NodePath) onready var enemySprite = get_node(enemySprite)
@onready var enemySpriteStartMaterial: Material = enemySprite.material

var hitFlashDur:= 0.0

func hitFlash():
	hitFlashDur = 0.1
	
	if enemySprite.material != MaterialReferences.hitFlashMat:
		enemySprite.material = MaterialReferences.hitFlashMat

func updateHitFlashMat():
	hitFlashDur -= get_process_delta_time()
	
	if hitFlashDur < 0 and enemySprite.material != enemySpriteStartMaterial:
		enemySprite.material = enemySpriteStartMaterial
