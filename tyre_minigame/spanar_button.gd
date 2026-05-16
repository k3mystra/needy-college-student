extends TextureButton

func _on_mouse_entered() -> void:
	ProgrammingMiniGameSignal.cursor_in.emit()
	
func _on_mouse_exited() -> void:
	ProgrammingMiniGameSignal.cursor_out.emit()
