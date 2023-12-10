extends Node2D

func _process(_delta):
	updateHitFlashMat()

<<<<<<< Updated upstream
@export var enemySprite : Sprite2D
=======
@export (NodePath) onready var enemySprite = get_node(enemySprite)
>>>>>>> Stashed changes
@onready var enemySpriteStartMaterial: Material = enemySprite.material

var hitFlashDur := 0.0

func hitFlash():
	hitFlashDur = 0.1
	
	if enemySprite.material != MaterialReferences.hitFlashMat:
		enemySprite.material = MaterialReferences.hitFlashMat

func updateHitFlashMat():
	hitFlashDur -= get_process_delta_time()
	
	if hitFlashDur < 0 and enemySprite.material != enemySpriteStartMaterial:
		enemySprite.material = enemySpriteStartMaterial
