class_name monitor extends Node2D

@onready var monitor_bottom_left = $MonitorPNG/ScreenBottomLeft
@onready var monitor_bottom_right = $MonitorPNG/ScreenBottomRight
@onready var monitor_upper_right =$MonitorPNG/ScreenUpperRight

var monitor_x_range : Vector2 = Vector2(-1,-1)
var monitor_y_range : Vector2 = Vector2(-1,-1)

func _ready() -> void:
	monitor_x_range.x = monitor_bottom_left.position.x
	monitor_x_range.y = monitor_bottom_right.position.x
	
	monitor_y_range.x = monitor_bottom_right.position.y
	monitor_y_range.y = monitor_upper_right.position.y
	
	var random_x = randf_range(monitor_x_range.x, monitor_x_range.y)
	var random_y = randf_range(monitor_y_range.x, monitor_y_range.y)
	
	print(str(random_x) + " " + str(random_y))
