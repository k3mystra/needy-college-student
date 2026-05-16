extends Node2D

var roadPattern = preload("res://DrivingMiniGame/Scenes/road_pattern.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_spawn_road_pattern()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _spawn_road_pattern():
	var scene_to_instantiate = roadPattern.instantiate()
	scene_to_instantiate.position = Vector2(0, 520)
	add_child(scene_to_instantiate)


func _on_timer_timeout() -> void:
	_spawn_road_pattern()
