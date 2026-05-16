extends Node2D

var potholeScene = preload("res://DrivingMiniGame/Scenes/potholes.tscn")
var spawnRange 
var repairChance
@onready var CarDashboard = $CarDashboard
@onready var Camera = $CarDashboard/Camera2D
@onready var CrashSound = $CrashSound
@onready var DrivingSound = $DrivingSound

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	_car_tire_puncture()

func _on_timer_timeout() -> void:
	spawnRange = randi_range(770, 2580)
	_spawnPotholes(Vector2(spawnRange, 520))

func _spawnPotholes(pos):
	var scene_to_instantiate = potholeScene.instantiate()
	scene_to_instantiate.CarDashboard = $CarDashboard
	scene_to_instantiate.add_to_group("pothole")
	scene_to_instantiate.position = pos
	add_child(scene_to_instantiate)

func _car_tire_puncture():
	if CarDashboard.potholeHit:
		Camera.shakeCamera = true
		_crash_sound()
	
	if CarDashboard.tireHealth <= 0:
		print("Player now has to repair tire")
		CarDashboard.potholeHit = false
		CarDashboard.tireHealth = 3
	else:
		CarDashboard.potholeHit = false
			
func _crash_sound():
	CrashSound.play(0.60)
	await get_tree().create_timer(1.55).timeout
	CrashSound.stop()
