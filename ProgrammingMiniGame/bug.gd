class_name code_bug extends Node2D

var mouse_in : bool = false

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_released(): 
			if mouse_in:
				print("Bug is squashed")
				queue_free()
			
func _on_area_2d_mouse_entered() -> void:
	mouse_in = true
	print("mouse went in")
	
func _on_area_2d_mouse_exited() -> void:
	mouse_in = false
