class_name game_cursor extends Node2D

func _process(delta: float) -> void:
	global_position = get_global_mouse_position()

func switch_normal():
	$Mouse.play("default")
	
func switch_hand():
	$Mouse.play("Hand")
