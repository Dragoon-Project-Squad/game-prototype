extends Node2D

@export var camera : Node

func _ready():
	setUpSimplexNoise()
	camera.set_as_top_level(true)

func _process(_delta: float) -> void:
	updateShakeTimes()
	updateCameraPosition()
	updateCameraRotation()

#Camera
@export_range (0.01, 0.5) var CAMERA_LERP_CONSTANT : float = 0.05

func updateCameraPosition():
	var camOffsetInAimDirectionVector: Vector2 = getCamOffsetInAimDirection()
	var camDisplacementShakeVector: Vector2 = getCamDisplacementShakeVector()
	
	var targetVector: Vector2 = camOffsetInAimDirectionVector + camDisplacementShakeVector
	
	camera.global_position = lerp(camera.global_position, targetVector + global_position, CAMERA_LERP_CONSTANT)

func updateCameraRotation():
	var camRotationalShakeAngle: float = getCamRotationalShakeAngle()
	
	var targetAngle: float = camRotationalShakeAngle
	
	camera.rotation = lerp_angle(camera.rotation, targetAngle, CAMERA_LERP_CONSTANT)

#Look In Aim Direction
@export var MAX_CAMERA_OFFSET : float =  50.0
@export var MAX_MOUSE_OFFSET_DISTANCE : float = 200.0

@export var PERCENT_REMAPPING_CURVE: Curve

func getCamOffsetInAimDirection() -> Vector2:
	var direction: Vector2 = get_global_mouse_position() - global_position
	var percent : float = min(direction.length() / MAX_MOUSE_OFFSET_DISTANCE, 1)
	
	var modifiedPercent := PERCENT_REMAPPING_CURVE.sample(percent)
	
	var offsetVector: Vector2
	offsetVector = direction.normalized() * MAX_CAMERA_OFFSET * modifiedPercent
	
	return offsetVector

#Cam Shake
@export var TRAUMA_DECAY_RATE := 1.2
@export var DISPLACEMENT_SHAKE_MAG := 20.0
@export var ROTATION_SHAKE_MAG := 5

var trauma := 0.0
var noise: FastNoiseLite
var shakeTime := 0.0

#Porting Note: Breaking port change, OpenSimplex replaced with FastNoiseLite
func setUpSimplexNoise():
	noise = FastNoiseLite.new()
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise.fractal_octaves = 3
	#Porting Note: noise.persistence = 0.8 - Persistence is no longer available in Godot 4
	noise.frequency = 0.2

func addShake(addedTrauma: float):
	trauma += addedTrauma
	trauma = clamp(trauma, 0, 1)

func updateShakeTimes():
	var delta = get_process_delta_time()
	
	shakeTime += delta
	trauma -= delta * TRAUMA_DECAY_RATE
	trauma = clamp(trauma, 0, 1)

func getCamDisplacementShakeVector() -> Vector2:
	var shakeVectorX = noise.get_noise_2d(0, shakeTime)
	var shakeVectorY = noise.get_noise_2d(1, shakeTime)
	
	var shakeVector = Vector2(shakeVectorX, shakeVectorY) * pow(trauma, 2) * DISPLACEMENT_SHAKE_MAG
	
	return shakeVector

func getCamRotationalShakeAngle() -> float:
	var shakeAngle = noise.get_noise_2d(2, shakeTime) * pow(trauma, 2) * deg_to_rad(ROTATION_SHAKE_MAG)
	
	return shakeAngle
