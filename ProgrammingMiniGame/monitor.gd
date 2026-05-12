class_name monitor extends Node2D

@export var bug : PackedScene

@onready var monitor_bottom_left = $MonitorPNG/ScreenBottomLeft
@onready var monitor_bottom_right = $MonitorPNG/ScreenBottomRight
@onready var monitor_upper_right =$MonitorPNG/ScreenUpperRight
@onready var AllBugs = $AllBugs

var monitor_x_range : Vector2 = Vector2(-1,-1)
var monitor_y_range : Vector2 = Vector2(-1,-1)

func _ready() -> void:
	monitor_x_range.x = monitor_bottom_left.global_position.x
	monitor_x_range.y = monitor_bottom_right.global_position.x
	
	monitor_y_range.x = monitor_bottom_right.global_position.y
	monitor_y_range.y = monitor_upper_right.global_position.y
	
	var random_position : Vector2 = choose_rand_position() 
	print(str(random_position.x) + " " + str(random_position.y))
	$BugSpawnCD.start()
	
func choose_rand_position() -> Vector2:
	var random_x = randf_range(monitor_x_range.x, monitor_x_range.y)
	var random_y = randf_range(monitor_y_range.x, monitor_y_range.y)
	return Vector2(random_x,random_y)		
	
func _process(delta: float) -> void:
	pass
	
func _on_bug_spawn_cd_timeout() -> void:
	var new_bug : code_bug = bug.instantiate()
	AllBugs.add_child(new_bug)
	new_bug.position = choose_rand_position()
	new_bug.rotation = randi_range(0,360)
	print("a bug is spawned")
