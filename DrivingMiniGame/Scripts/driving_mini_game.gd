extends Node2D

var potholeScene = preload("res://DrivingMiniGame/Scenes/potholes.tscn")
var spawnRange 
var repairChance
@onready var CarDashboard = $CarDashboard
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_draw()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_car_tire_puncture()

func _on_timer_timeout() -> void:
	spawnRange = randi_range(200, 3200)
	_spawnPotholes(Vector2(spawnRange, 300))

func _spawnPotholes(pos):
	var scene_to_instantiate = potholeScene.instantiate()
	scene_to_instantiate.CarDashboard = $CarDashboard
	scene_to_instantiate.add_to_group("pothole")
	scene_to_instantiate.position = pos
	add_child(scene_to_instantiate)

func _draw():
	draw_line(Vector2(0, 580), Vector2(4000, 580), Color.WHITE, 2.0)

func _car_tire_puncture():
	#if CarDashboard.potholeHit == true:	
		#repairChance = randi_range(0, 10)
		##if repairChance <= 2:
			##print("Player now has to repair tire")
			##CarDashboard.potholeHit = false
		##else:
			##CarDashboard.potholeHit = false
		
	if CarDashboard.tireHealth <= 0:
		print("Player now has to repair tire")
		CarDashboard.potholeHit = false
		CarDashboard.tireHealth = 3
	else:
		CarDashboard.potholeHit = false
			
