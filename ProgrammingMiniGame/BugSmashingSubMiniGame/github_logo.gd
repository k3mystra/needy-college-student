extends Sprite2D

func _on_button_mouse_entered() -> void:
	ProgrammingMiniGameSignal.cursor_in.emit()


func _on_button_mouse_exited() -> void:
	ProgrammingMiniGameSignal.cursor_out.emit()
